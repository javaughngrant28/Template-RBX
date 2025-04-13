export type PlayerDataTemplateType = {
	Keybinds: {
		[string]: {
			PC: string,
			Xbox: string,
		}
	},
	leaderstats: {
		Wins: number
	},

	Currency: {
		Coins: number
	},
}

PlayerDataTemplate = {}

PlayerDataTemplate.Get = function() : PlayerDataTemplateType
	return {
		Keybinds = {
			Attack = {
				PC = 'M1',
				Xbox = 'B Button'
			},
		},
		leaderstats = {
			Wins = 0,
		},
		Currency = {
			Coins = 10,
		},
	}
end

return PlayerDataTemplate
