local RunService = game:GetService('RunService')
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

type EventNames = {string}


export type Client = {
	new: (nameSpace: string,eventNames: EventNames)->Client,
	OnClient:(Client,methodName: string,callBack: RemoteUtil.ClientCallBack)->(),
	FireServer: (Client,methodName: string,...any?)->(),
}

export type Server = {
	new: (nameSpace: string,eventNames: EventNames)->Server,
	OnServer:(Server,methodName: string,callBack: RemoteUtil.ServerCallBack)->(),
	FireClient: (Server,methodName: string,player: Player,...any?)->(),
}


local NameSpaceEvent = {}
NameSpaceEvent.__index = NameSpaceEvent

NameSpaceEvent._MAID = nil
NameSpaceEvent._KEY = 'Open'
NameSpaceEvent._NAME_SPACE = nil
NameSpaceEvent._FOLDER = nil
NameSpaceEvent._EVENTS = {}
NameSpaceEvent._CALLBACKS = {}



function NameSpaceEvent.new(nameSpace: string,eventNames: EventNames)
	local self = setmetatable({}, NameSpaceEvent)
	self:__Constructor(nameSpace,eventNames)
	return self
end

function NameSpaceEvent:CreateFolder(): Folder
	local folder = Instance.new('Folder')
	folder.Name = self._NAME_SPACE
	folder.Parent = RemoteUtil._FOLDER
	self._MAID['Folder'] = folder
	return folder
end

function NameSpaceEvent:CreateRemote(methodName: string, folder: Folder): RemoteEvent
	local remote = Instance.new('RemoteEvent')
	remote.Name = methodName
	remote.Parent = folder
	self._MAID[methodName] = folder
	return remote
end

function NameSpaceEvent:__Constructor(nameSpace: string,eventNames: EventNames)
	self._MAID = MaidModule.new()
	self._NAME_SPACE = nameSpace
	
	if RunService:IsServer() then
		local folder = self:CreateFolder() :: Folder
		self._FOLDER = folder
		
		for _, eventName: string in eventNames do
			local remote = self:CreateRemote(eventName,folder) :: RemoteEvent
			self._EVENTS[eventName] = remote
		end
	end
end

function NameSpaceEvent:OnServer(methodName: string,callback: RemoteUtil.ServerCallBack)
	local CallbackFunction = function(player: Player,...)
		callback(player,...)
	end
	
	table.insert(self._CALLBACKS,CallbackFunction)
	
	local remote: RemoteEvent = self._EVENTS[methodName]
	assert(remote and remote:IsA('RemoteEvent'),`{methodName} RemoteEvent Not Found In {unpack(self._EVENTS)}`)
	RemoteUtil._ConnectCallBack(self._KEY,remote,CallbackFunction)
end

function NameSpaceEvent:OnClient(methodName: string,callback: RemoteUtil.ClientCallBack)
	local CallbackFunction = function(...)
		callback(...)
	end

	table.insert(self._CALLBACKS,CallbackFunction)
	
	local remoteAdded = nil

	local connection: RBXScriptConnection
	connection = RemoteUtil._FOLDER.DescendantAdded:Connect(function(child)
		if child:IsA("RemoteEvent") and child.Name == methodName then
			remoteAdded = child
			connection:Disconnect()
			self._EVENTS[methodName] = child
		
			RemoteUtil._ConnectCallBack(self._KEY,child,CallbackFunction)
		end
	end)

	local remote = self:_FindRemote(methodName)
	if remote and not remoteAdded then
		RemoteUtil._ConnectCallBack(self._KEY,remote,CallbackFunction)
		connection:Disconnect()
		connection = nil
	end
	
end

function NameSpaceEvent:FireServer(methodName: string,...)
	local remote: RemoteEvent? = self:_FindRemote(methodName)
	assert(remote,`{methodName} Remote Not Found`)
	remote:FireServer(...)
end

function NameSpaceEvent:FireClient(methodName: string,player: Player,...)
	local remote = self._EVENTS[methodName] :: RemoteEvent
	assert(remote,`{methodName} Remote Not Found`)
	remote:FireClient(player,self._KEY,...)
end

function NameSpaceEvent:_FindRemote(methodName: string): RemoteEvent?
	if self._EVENTS[methodName] then
		return self._EVENTS[methodName]
	else
		local folder = RemoteUtil._FOLDER:FindFirstChild(self._NAME_SPACE) :: Folder
		if not folder then return end

		local remote = folder:FindFirstChild(methodName) :: RemoteEvent
		if not remote then return end
		if not remote:IsA('RemoteEvent') then warn(`{remote} Is Not A Remote`) return end

		self._EVENTS[methodName] = remote
		return remote
	end
end

function NameSpaceEvent:Destroy()
	for _, callback in self._CALLBACKS do
		RemoteUtil.Destroy(callback)
	end
	
	self._MAID:Destroy()
	for index, _ in pairs(self) do
		self[index] = nil
	end
end

return NameSpaceEvent
