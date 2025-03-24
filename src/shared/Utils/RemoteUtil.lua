--[[

	               (          )                           )   (         )  
	   (     (     )\ )    ( /(        *   )  (  (     ( /(   )\ )   ( /(  
	 ( )\    )\   (()/(    )\()) (   ` )  /(  )\))(   ')\()) (()/(   )\()) 
	 )((_)((((_)(  /(_))  ((_)\  )\   ( )(_))((_)()\ )((_)\   /(_))|((_)\  
	((_)_  )\ _ )\(_))_    _((_)((_) (_(_()) _(())\_)() ((_) (_))  |_ ((_) 
	 | _ ) (_)_\(_)|   \  | \| || __||_   _| \ \((_)/ // _ \ | _ \ | |/ /  
	 | _ \  / _ \  | |) | | .` || _|   | |    \ \/\/ /| (_) ||   /   ' <   
	 |___/ /_/ \_\ |___/  |_|\_||___|  |_|     \_/\_/  \___/ |_|_\  _|\_\ 

]]


export type ClientCallBack = (any: any?)->()
export type ServerCallBack = (player: Player,any: any?)->()

local RunService = game:GetService('RunService')

local FOLDER_NAME = 'NETWORK EVENTS'
local GENERAL_REMOTE_NAME = 'GENERAL'

local connections: { [ClientCallBack | ServerCallBack]: RBXScriptConnection } = {}

local function CreateFolder(name: string?, location: Instance?): Folder
	local folder = Instance.new('Folder')
	folder.Name = name or FOLDER_NAME
	folder.Parent = location or game.ReplicatedStorage
	return folder
end

local function CreateRemote(parent: Instance, name: string?): RemoteEvent
	local remote = Instance.new('RemoteEvent')
	remote.Name = name or GENERAL_REMOTE_NAME
	remote.Parent = parent
	return remote
end

if RunService:IsServer() then
	local folder = CreateFolder()
	CreateRemote(folder)
end

local Remotes: {[string]: RemoteEvent} = {}

local function FindRemote(folderName: string, remoteName: string): RemoteEvent?
	local folder: Folder?

	for _, instance: Instance in game.ReplicatedStorage:GetChildren() do
		if instance:IsA('Folder') and instance.Name == folderName then
			folder = instance
			break
		end
	end
	
	if not folder then return nil end
	
	local remote = folder:FindFirstChild(remoteName) 
	
	if not remote or not remote:IsA('RemoteEvent') then
		return nil
	else
		return remote
	end
end

local function GetRemote(folderName: string, remoteName: string?): RemoteEvent?
	local remoteName = remoteName or GENERAL_REMOTE_NAME
	local savedRemote = Remotes[folderName..remoteName] :: RemoteEvent?
	
	if savedRemote then
		return savedRemote
	else
		return FindRemote(folderName,remoteName)
	end
end

local function ConnectCallBack(eventName: string,remote: RemoteEvent, callback: (any)->())
	
	if connections[callback] then
		connections[callback]:Disconnect()
	end
	
	local function onConnect(_eventName: string,...)
		if _eventName == eventName then
			callback(...)
		end
	end
	local connection
	
	if RunService:IsServer() then
		connection = remote.OnServerEvent:Connect(function(player: Player,_eventName: string, ...)
			onConnect(_eventName,player,...)
		end)
	else
		connection = remote.OnClientEvent:Connect(onConnect)
	end

	if connections[callback] then
		connections[callback]:Disconnect()
	end

	connections[callback] = connection
end

local EventUtil = {}

EventUtil._FOLDER_NAME = FOLDER_NAME


--PRIVIT METHODS
function EventUtil._ConnectCallBack(remote: RemoteEvent, callback: (any)->(),eventName: string?)
	local eventName = eventName or ''
	ConnectCallBack(eventName,remote,callback)
end
function EventUtil._CreateRemote(parent: Instance, name: string): RemoteEvent
	local remoteAreadyExits = parent:FindFirstChild(name)
	assert(
		remoteAreadyExits and remoteAreadyExits:IsA('RemoteEvent'),
		`{name} Remote Aready Exists Inside {parent}`
	)

	return CreateRemote(parent,name)
end

function EventUtil._CreateFolder(folderName: string): Folder
	local folderLocation = game.ReplicatedStorage:FindFirstChild(FOLDER_NAME) :: Folder
	assert(folderLocation,`{folderName} not found in ReplicatedStorage`)
	
	local istanceAlreadyExists = folderLocation:FindFirstChild(folderName)
	assert(
		istanceAlreadyExists and istanceAlreadyExists:IsA('Folder'), 
		`{folderName} Folder Already Exists`
	)
	return CreateFolder(folderName,folderLocation)
end


--- SERVER METHODS ---

-- SERVER: Fires Event To A Player
function EventUtil.FireClient(eventName: string, player: Player,...)
	local remote = GetRemote(FOLDER_NAME)
	assert(remote,`Remote Not Found`)
	
	remote:FireClient(player,eventName,...)
end

-- SERVER: Receive Events Frome Player
function EventUtil.OnServer(eventName: string,severCallback: ServerCallBack)
	local remote = GetRemote(FOLDER_NAME)
	assert(remote,`Remote Not Found`)

	ConnectCallBack(eventName,remote,severCallback)
end


--- CLIENT METHODS ---

-- CLIENT: Recive Event From SERVER
function EventUtil.OnClient(eventName: string, clientCallback: ClientCallBack)
	local remote = GetRemote(FOLDER_NAME)
	
	if remote then
		ConnectCallBack(eventName,remote,clientCallback)
	else
		local connection: RBXScriptConnection
		connection = game.ReplicatedStorage.ChildAdded:Connect(function(child)
			if child:IsA("Folder") and child.Name == FOLDER_NAME then
				local foundRemote = GetRemote(FOLDER_NAME)
				if foundRemote then
					connection:Disconnect()
					ConnectCallBack(eventName, foundRemote, clientCallback)
				end
			end
		end)
	end
end

-- CLIENT: Recive Event From SERVER
function EventUtil.FireServer(eventName: string, ...)
	local remote = GetRemote(FOLDER_NAME)
	assert(remote,`Remote Not Found`)
	
	remote:FireServer(eventName,...)
end

function EventUtil.Destroy(callback: ClientCallBack | ServerCallBack)
	if connections[callback] then
		connections[callback]:Disconnect()
		connections[callback] = nil
		print('Removed Connection:',callback)
	end
end

return EventUtil