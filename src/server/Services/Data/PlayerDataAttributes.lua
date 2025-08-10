
local PlayerProfiles = require(script.Parent.PlayerProfiles)


export type Attribues = {
	Loaded: boolean,
	Coins: number,
}

local function CreateAttributes(player: Player)
	local Data = PlayerProfiles[player].Data
	player:SetAttribute('Loaded',true)
	player:SetAttribute('Coins', Data.Coins)
end

local function GetAttribues(player: Player): Attribues
	return player:GetAttributes()
end

return {
	Create = CreateAttributes,
	Update = CreateAttributes,
	Get = GetAttribues,
}