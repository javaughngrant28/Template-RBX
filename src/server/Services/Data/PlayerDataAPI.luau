
local Signal = require(game.ReplicatedStorage.Shared.Libraries.Signal)
local PlayerProfiles = require(script.Parent.PlayerProfiles)
local PlayerDataTemplate = require(script.Parent.PlayerDataTemplate)

local UpdateAttributeSignal = Signal.new()

local function GetData(player: Player): PlayerDataTemplate.DataType
	assert(player:IsA('Player'),`{player} Invalid Type Player`)
	assert(PlayerProfiles[player],`{player} Profile Not Found`)

	return PlayerProfiles[player].Data
end


local API = {}

--- UPDATE ---
function API.SetCoins(player: Player, number: number)
	assert(typeof(number) == 'number',`{player} Invalid Type To Set Coins`)
	
	local data = GetData(player)
	data.Coins = tonumber(number)
	UpdateAttributeSignal:Fire(player)
end

function API.IncrementCoins(player: Player, number: number)
	local Data = GetData(player)
	Data.Coins += number
	UpdateAttributeSignal:Fire(player)
end


--- GET ---
function API._GetUpdateAttributeSignal()
	return UpdateAttributeSignal
end

return API