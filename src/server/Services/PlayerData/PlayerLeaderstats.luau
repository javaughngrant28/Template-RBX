
local PlayerDataTemplate = require(script.Parent.PlayerDataTemplate)

local function GetLeaderstats(player: Player): Folder
	local folder = player:FindFirstChild('leaderstats')
	assert(folder,`{player} Has No Leaderstats Folder`)
	return folder
end

local function CreateLeaderStats(player: Player, Data: PlayerDataTemplate.DataType)
    local folder = Instance.new('Folder')
    folder.Name = 'leaderstats'
    folder.Parent = player

	local Wins = Instance.new('NumberValue')
	Wins.Name = 'Wins'
	Wins.Value = Data.Wins
	Wins.Parent = folder
end

local function SetCoinValue(player: Player, value: number)
	local leaderstats = GetLeaderstats(player)
	local coins = leaderstats:FindFirstChild('Coins') :: NumberValue
	coins.Value = value
end


return {
	Create = CreateLeaderStats,
	SetCoins = SetCoinValue
}