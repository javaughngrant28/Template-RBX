export type PlayerDataInstancesType = {
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


local PlayerDataInstances = {}

PlayerDataInstances.Get = function() : PlayerDataInstancesType
	return {
		FinishedLoading = false,
		Keybinds = {},
		leaderstats = {
			Wins = 0,
		},
		Currency = {
			Coins = 10,
		},
	}
end

return PlayerDataInstances

