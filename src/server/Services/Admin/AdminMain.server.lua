local Players = game:GetService('Players')

local Comands = require(game.ServerScriptService.Services.Admin.Comands)

local groupId = 35325652
local developerRank = 13
local prefix = '/'


local self = {}

function IsDeveloperOrHigher(player: Player)
	-- if not player:IsInGroup(groupId) then return false end
	-- if player:GetRankInGroup(groupId) < developerRank then return false end
	return true
end


Players.PlayerAdded:Connect(function(player: Player)
	print(`{player.Name} Use Commaneds Set To: {IsDeveloperOrHigher(player)} `)
	player.Chatted:Connect(function(text: string)
		local splitText = text:split(' ')
		local command = splitText[1]:split(prefix)

		if Comands[command[2]] == nil then return end
		if not IsDeveloperOrHigher(player) then return end

		table.remove(splitText, 1)
		Comands[command[2]](player, table.unpack(splitText))
	end)
end)




return self
