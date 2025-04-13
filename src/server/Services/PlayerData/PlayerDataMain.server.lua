
local Players = game:GetService('Players')
local DataStoreService = game:GetService('DataStoreService')

local DataStore = DataStoreService:GetDataStore('Data0')

local TransformData = require(game.ReplicatedStorage.Shared.Modules.TransformData)
local PlayerDataAPI = require(game.ServerScriptService.Services.PlayerData.PlayerDataAPI)
local PlayerDataTemplate = require(game.ServerScriptService.Services.PlayerData.PlayerDataTemplate)
local PlayerDataInstances = require(game.ServerScriptService.Services.PlayerData.PlayerDataInstances)
local SyncMathachingData = require(game.ServerScriptService.Services.PlayerData.SyncMathachingData)


Players.PlayerAdded:Connect(function(player: Player)
	-- local success: boolean, value: PlayerDataTemplate.PlayerDataTemplateType? = pcall(DataStore.GetAsync, DataStore, player.UserId)
	local success = true
	local value = nil

	if not success then
		player:Kick('Failed To Load: Rejoin')
		return
	end

	
	local Data
	local templateData = PlayerDataTemplate.Get()

	if value then
		Data = SyncMathachingData.Fire(value, templateData)
		else
			Data = templateData
	end

	local InstanceData = PlayerDataInstances.Get()
	local UpdatedInstanceData = SyncMathachingData.Fire(Data,InstanceData)

	PlayerDataAPI.Set(player.Name, Data)
	TransformData.ToInstance(player, UpdatedInstanceData)
end)


Players.PlayerRemoving:Connect(function(player: Player)
	local playerName = player.Name
	local instanceData = TransformData.FromInstanceToDataType(player)
	local playerData = PlayerDataAPI.Get(playerName)
	if playerData == nil then return end

	-- local Data = SyncMathachingData.Fire(instanceData,playerData)
	-- local success: boolean, _ = pcall(DataStore.SetAsync, DataStore, player.UserId,Data)
	local success = true

	if success then
		print('Saved Player Data:', player)
		else
			print('Faild To Save PlayerData')
	end

	PlayerDataAPI.Clear(playerName)
end)