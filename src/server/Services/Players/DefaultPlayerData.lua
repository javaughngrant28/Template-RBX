
export type DataTemplate = {
	Keybinds: {
		Attack: {
			PC: string,
			Xbox: string
		}
	},
}

export type DataInstance = {
	LastBlockChoosen: string,
	DashAmount: number,
	DashEffect: string,
	IsDasing: boolean,
	Keybinds: {},
}

local DefaultPlayerData = {}

DefaultPlayerData.Instances = {
    FinishedLoading = false,
	DashAmount = 0,
	DashEffect = '',
	IsDashing = false,
	Keybinds = {},
}

DefaultPlayerData.Template = {
	Keybinds = {
		Attack = {
			PC = 'M1',
			Xbox = 'B Button'
		},
		Dash = {
			PC = 'Q',
			Xbox = 'Y Button'
		},
	},
	DashEffect = 'Trail',

}

function DefaultPlayerData.GetInstanceDataSyncedWithSavedData(dataStoreData: DataTemplate): DataInstance
	local dataInstance = DefaultPlayerData.Instances

	for index, value in pairs(dataStoreData) do
		if dataInstance[index] then
			dataInstance[index] = value
		end
	end

	return dataInstance
end

return DefaultPlayerData