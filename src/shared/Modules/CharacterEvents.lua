local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local CharacterEvents = {}

type Callback = (character: Model) -> ()
type CallbackTable = {Callback}
type PlayerCallbacks = { [Player]: { [string]: CallbackTable, _characterAddedConnection: RBXScriptConnection? } }

local registeredCallbacks: PlayerCallbacks = {}
local validEventTypes = { Spawn = true, Loaded = true, Died = true, Removing = true }

local function FireCallbacks(player: Player, eventType: string, character: Model)
    local playerCallbacks = registeredCallbacks[player]
    if not playerCallbacks then return end

    local eventCallbacks = playerCallbacks[eventType]
    if not eventCallbacks then return end

    for _, callback in ipairs(eventCallbacks) do -- FIX: Use ipairs for numeric iteration
        local success, err = pcall(callback, character)
        if not success then
            warn(`Error in callback for eventType {eventType}: {err}`)
        end
    end
end

local function OnCharacterAdded(player: Player, character: Model)
    task.defer(function()
        FireCallbacks(player, "Spawn", character)

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            FireCallbacks(player, "Loaded", character)

            local diedConnection
            diedConnection = humanoid.Died:Connect(function()
                FireCallbacks(player, "Died", character)
                diedConnection:Disconnect()
            end)
        end

        local ancestryConnection
        ancestryConnection = character.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                FireCallbacks(player, "Removing", character)
                ancestryConnection:Disconnect()
            end
        end)
    end)
end

local function RegisterCallback(player: Player?, eventType: string, callback: Callback)
    assert(type(callback) == "function", `Invalid callback for {eventType}. Expected function.`)
    assert(validEventTypes[eventType], `Invalid eventType: {eventType}`)

    -- Prevent `Players.LocalPlayer` from being used on the server
    if not player and RunService:IsServer() then
        error("Server-side RegisterCallback requires a player argument.")
    end

    player = player or Players.LocalPlayer
    if not player then return end

    registeredCallbacks[player] = registeredCallbacks[player] or {}
    registeredCallbacks[player][eventType] = registeredCallbacks[player][eventType] or {}

    table.insert(registeredCallbacks[player][eventType], callback)

    -- Immediately trigger callback if character is already present for Spawn/Loaded
    local character = player.Character
    if character and (eventType == "Loaded" or eventType == "Spawn") then
        task.defer(function()
            if character.Parent then
                local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
                if humanoid then
                    callback(character)
                end
            end
        end)
    end
end

function CharacterEvents.Spawn(callback: Callback, player: Player?)
    RegisterCallback(player, "Spawn", callback)
end

function CharacterEvents.Loaded(callback: Callback, player: Player?)
    RegisterCallback(player, "Loaded", callback)
end

function CharacterEvents.Died(callback: Callback, player: Player?)
    RegisterCallback(player, "Died", callback)
end

function CharacterEvents.Removing(callback: Callback, player: Player?)
    RegisterCallback(player, "Removing", callback)
end

local function TrackPlayer(player: Player)
    local characterAddedConnection
    characterAddedConnection = player.CharacterAdded:Connect(function(character)
        OnCharacterAdded(player, character)
    end)

    -- Fire if player already has a character
    if player.Character then
        task.defer(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                OnCharacterAdded(player, player.Character)
            end
        end)
    end

    registeredCallbacks[player] = registeredCallbacks[player] or {}
    registeredCallbacks[player]._characterAddedConnection = characterAddedConnection
end

for _, player in Players:GetPlayers() do
    TrackPlayer(player)
end

Players.PlayerAdded:Connect(TrackPlayer)

Players.PlayerRemoving:Connect(function(player)
    local data = registeredCallbacks[player]
    if data and data._characterAddedConnection then
        data._characterAddedConnection:Disconnect()
    end
    registeredCallbacks[player] = nil
end)

return CharacterEvents
