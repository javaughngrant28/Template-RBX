
--// Sevices
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")


--// Modules
local ProfileStore = require(ServerStorage.Libraries.ProfileStore)
local PlayerDataTemplate = require(script.Parent.PlayerDataTemplate)
local PlayerLeaderstats = require(script.Parent.PlayerLeaderstats)
local PlayerDataAttributes = require(script.Parent.PlayerDataAttributes)
local PlayerDataAPI = require(script.Parent.PlayerDataAPI)

local playerStoreName = RunService:IsStudio() and "Save_0" or "Data_0"
local PlayerStore = ProfileStore.New(playerStoreName, PlayerDataTemplate)
local PlayerProfiles = require(script.Parent.PlayerProfiles) :: {[Player]: typeof(PlayerStore:StartSessionAsync())}

local UpdateAttributeSignal = PlayerDataAPI._GetUpdateAttributeSignal()


local function PlayerAdded(player: Player)
	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile.OnSessionEnd:Connect(function()
			PlayerProfiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			PlayerProfiles[player] = profile
			print(`Profile loaded for {player.DisplayName}!`)

			PlayerDataAttributes.Create(player)
			PlayerLeaderstats.Create(player,PlayerProfiles[player].Data)

		else
			profile:EndSession()
		end

	else
		player:Kick(`Profile load fail - Please rejoin`)
	end

	local playerIdList = {}
	for _, player in Players:GetPlayers() do
		table.insert(playerIdList, player.UserId)
	end
end

local function PlayerRemoving(player: Player)
	local profile = PlayerProfiles[player]

	if profile ~= nil then
		profile:EndSession()
	end
end


local function UpdateAttributes(player: Player)
	PlayerDataAttributes.Update(player)
end


for _, player in Players:GetPlayers() do
	task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)

UpdateAttributeSignal:Connect(UpdateAttributes)