
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local maidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local InputEvent: NameSpaceEvent.Server = NameSpaceEvent.new('Input',{'Connect','Disconnect'})

local errorText1 = 'Missing Parameter'
local FOLDER_NAME = 'InputEvents'
local FOLDER_LOCATION = game.ReplicatedStorage

export type InputDetectorType = {
    Peramiters: {[string]: any},
    Cooldown: number,

    new: (player: Player, keybindName: string, moduleName: string) -> InputDetectorType,
    Connect: (self: InputDetectorType, callbackFunction: (...any?) -> ()) -> (),
    Destroy: (self: InputDetectorType) -> (),
}


local function GetEventFolder(): Folder
	local folder = FOLDER_LOCATION:FindFirstChild(FOLDER_NAME)

	if not folder then
		folder = Instance.new('Folder')
		folder.Name = FOLDER_NAME
		folder.Parent = FOLDER_LOCATION
	end

	return folder
end


local InputDetector = {}
InputDetector.__index = InputDetector

InputDetector._PLAYER = nil

InputDetector._MAID = nil
InputDetector._NETWORK = nil
InputDetector._LastTimeActivated = nil

InputDetector.Peramiters = {}
InputDetector._KeybindName = ''
InputDetector._ModuleName = ''

InputDetector.Cooldown = 0.2


function InputDetector.new(player: Player, keybindName: string, moduleName: string): InputDetectorType
	assert(player,errorText1)
	assert(keybindName,errorText1)
	assert(moduleName,errorText1)

	local self = setmetatable({},InputDetector)

	self._MAID = maidModule.new()
	self._PLAYER = player
	self._ModuleName = moduleName
	self._KeybindName = keybindName

	return self
end

function InputDetector:_GetPeramiters(): {[string]: any}
	local valueTable = self.Peramiters
	valueTable['Cooldown'] = self.Cooldown
	valueTable['KeybindName'] = self._KeybindName
	return valueTable
end

function InputDetector:Connect(callbackFunction: (...any?)-> ())
	local remote = Instance.new('RemoteEvent')
	remote.Name = self._ModuleName
	remote.Parent = GetEventFolder()
	self._MAID['Remote'] = remote

	self._MAID['Remote Connection'] = remote.OnServerEvent:Connect(function(player: Player,...)
		if player ~= self._PLAYER then return end
		callbackFunction(...)
	end)

	local inputPeramiters = self:_GetPeramiters()
	InputEvent:FireClient('Connect',self._PLAYER,self._ModuleName,remote,inputPeramiters)
end


function InputDetector:Destroy()
	InputEvent:FireClient('Disconnect',self._PLAYER,self._MAID['Remote'])

	self._MAID:DoCleaning()
	for index, _ in pairs(self) do
        self[index] = nil
    end
end

return InputDetector
