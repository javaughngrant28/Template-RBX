

local PlayerDataTemplate = require(game.ServerScriptService.Services.PlayerData.PlayerDataTemplate)
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)
local LoadedData: {[string]: PlayerDataTemplate.PlayerDataTemplateType} = {}


game:BindToClose(function()
	while next(LoadedData) do
		task.wait()
	end
end)


local function GetData(playerName: string): PlayerDataTemplate.PlayerDataTemplateType
    local data =  LoadedData[playerName]
    assert(data,`No Data Found For Player: {playerName}`)

    return data
end


local PlayerDataAPI = {}

function PlayerDataAPI.Set(playerName: string, data: PlayerDataTemplate.PlayerDataTemplateType)
    if LoadedData[playerName] then 
        error(`Existing Data Found With Same Matching KeyName: {playerName} - {unpack(existingData)}`) 
    end
    LoadedData[playerName] = data
end

function PlayerDataAPI.Get(playerName: string): PlayerDataTemplate.PlayerDataTemplateType?
    local existingData = GetData(playerName)
    return existingData
end

function PlayerDataAPI.Clear(playerName: string)
    LoadedData[playerName] = nil
end

return PlayerDataAPI