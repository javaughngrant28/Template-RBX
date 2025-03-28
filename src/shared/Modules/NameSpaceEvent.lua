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
NameSpaceEvent._NAME_SPACE = nil
NameSpaceEvent._FOLDER = nil
NameSpaceEvent._EVENTS = {}
NameSpaceEvent._CALLBACKS = {}



function NameSpaceEvent.new(nameSpace: string,eventNames: EventNames)
	local self = setmetatable({}, NameSpaceEvent)
	self:__Constructor(nameSpace,eventNames)
	return self
end

function NameSpaceEvent:__Constructor(nameSpace: string,eventNames: EventNames)
	self._MAID = MaidModule.new()
	self._NAME_SPACE = nameSpace
	
	if RunService:IsServer() then
		local folder = RemoteUtil._CreateFolder(nameSpace) :: Folder
		self._FOLDER = folder
		
		for _, eventName: string in eventNames do
			local remote = RemoteUtil._CreateRemote(folder,eventName) :: RemoteEvent
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
	RemoteUtil._ConnectCallBack(remote,CallbackFunction)
end

function NameSpaceEvent:OnClient(methodName: string,callback: RemoteUtil.ClientCallBack)
	local CallbackFunction = function(...)
		callback(...)
	end

	table.insert(self._CALLBACKS,CallbackFunction)
	
	local remoteAdded = nil

	local connection: RBXScriptConnection
	connection = game.ReplicatedStorage.DescendantAdded:Connect(function(child)
		if child:IsA("RemoteEvent") and child.Name == methodName then
			remoteAdded = child
			connection:Disconnect()
			self._EVENTS[methodName] = child
		
			RemoteUtil._ConnectCallBack(child,CallbackFunction)
		end
	end)

	local remote = self:_FindRemote(methodName)
	if remote and not remoteAdded then
		RemoteUtil._ConnectCallBack(remote,CallbackFunction)
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
	assert(remote,`{methodName} Remote Not Found {unpack(self._EVENTS)}`)
	remote:FireClient(player,RemoteUtil._KEY,...)
end

function NameSpaceEvent:_FindRemote(methodName: string): RemoteEvent?
	if self._EVENTS[methodName] then
		return self._EVENTS[methodName]
	else
		local remoteEvent

		for _, instanceFound in game.ReplicatedStorage:GetChildren() do
			if not instanceFound:IsA('Folder') then continue end
			if instanceFound.Name ~= RemoteUtil._FOLDER_NAME then continue end
	
			local remoteFolder = instanceFound:FindFirstChild(self._NAME_SPACE)
			if not remoteFolder then return end
			
			local remote = remoteFolder:FindFirstChild(methodName) :: RemoteEvent
			if not remote:IsA('RemoteEvent') then warn(`{remote} Is Not A Remote`) return end

			remoteEvent = remote
		end

		self._EVENTS[methodName] = remoteEvent
		return remoteEvent
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
NameSpaceEvent._NAME_SPACE = nil
NameSpaceEvent._FOLDER = nil
NameSpaceEvent._EVENTS = {}
NameSpaceEvent._CALLBACKS = {}



function NameSpaceEvent.new(nameSpace: string,eventNames: EventNames)
	local self = setmetatable({}, NameSpaceEvent)
	self:__Constructor(nameSpace,eventNames)
	return self
end

function NameSpaceEvent:__Constructor(nameSpace: string,eventNames: EventNames)
	self._MAID = MaidModule.new()
	self._NAME_SPACE = nameSpace
	
	if RunService:IsServer() then
		local folder = RemoteUtil._CreateFolder(nameSpace) :: Folder
		self._FOLDER = folder
		
		for _, eventName: string in eventNames do
			local remote = RemoteUtil._CreateRemote(folder,eventName) :: RemoteEvent
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
	RemoteUtil._ConnectCallBack(remote,CallbackFunction)
end

function NameSpaceEvent:OnClient(methodName: string,callback: RemoteUtil.ClientCallBack)
	local CallbackFunction = function(...)
		callback(...)
	end

	table.insert(self._CALLBACKS,CallbackFunction)
	
	local remoteAdded = nil

	local connection: RBXScriptConnection
	connection = game.ReplicatedStorage.DescendantAdded:Connect(function(child)
		if child:IsA("RemoteEvent") and child.Name == methodName then
			remoteAdded = child
			connection:Disconnect()
			self._EVENTS[methodName] = child
		
			RemoteUtil._ConnectCallBack(child,CallbackFunction)
		end
	end)

	local remote = self:_FindRemote(methodName)
	if remote and not remoteAdded then
		RemoteUtil._ConnectCallBack(remote,CallbackFunction)
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
	assert(remote,`{methodName} Remote Not Found {unpack(self._EVENTS)}`)
	remote:FireClient(player,RemoteUtil._KEY,...)
end

function NameSpaceEvent:_FindRemote(methodName: string): RemoteEvent?
	if self._EVENTS[methodName] then
		return self._EVENTS[methodName]
	else
		local remoteEvent

		for _, instanceFound in game.ReplicatedStorage:GetChildren() do
			if not instanceFound:IsA('Folder') then continue end
			if instanceFound.Name ~= RemoteUtil._FOLDER_NAME then continue end
	
			local remoteFolder = instanceFound:FindFirstChild(self._NAME_SPACE)
			if not remoteFolder then return end
			
			local remote = remoteFolder:FindFirstChild(methodName) :: RemoteEvent
			if not remote:IsA('RemoteEvent') then warn(`{remote} Is Not A Remote`) return end

			remoteEvent = remote
		end

		self._EVENTS[methodName] = remoteEvent
		return remoteEvent
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
