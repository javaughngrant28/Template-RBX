local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local CharacterConfig = require(game.ReplicatedStorage.Shared.Configs.CharacterConfig)

local player = Players.LocalPlayer


local maid: MaidModule.Maid = MaidModule.new()

local function CreateBodyVelocity(): BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
    bv.Velocity = Vector3.zero
    return bv
end

local function SetMovementConstraints(walkSpeed:number?, jumpHeight: number?)
    maid:DoCleaning()

    local character = player.Character
    if not character then warn('Character Not Found') return end

    local humanoid = character:WaitForChild('Humanoid',10) :: Humanoid
    if not humanoid then warn('Humanoid Not Found') return end

    local rootPart = character:WaitForChild('HumanoidRootPart',10) :: BasePart

    humanoid.UseJumpPower = false

    local bv = CreateBodyVelocity()
    bv.Parent = rootPart

    maid["RS"] = RunService.Heartbeat:Connect(function()
        local moveDirection = humanoid.MoveDirection
        humanoid.JumpHeight = jumpHeight or CharacterConfig.JumpHeight

        if moveDirection.Magnitude > 0 then
            bv.Velocity = moveDirection.Unit * (walkSpeed or CharacterConfig.WalkSpeed)
        else
            bv.Velocity = Vector3.zero
        end
    end)

    maid['Died'] = humanoid.Died:Once(function()
        maid:DoCleaning()
    end)
end

local function onCharacterSpawn()
    SetMovementConstraints()
end

CharacterEvents.Spawn(onCharacterSpawn)
RemoteUtil.OnClient("UpdateMovementConstraints", SetMovementConstraints)

