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


export type ClientCallBack = (...any?)->()
export type ServerCallBack = (player: Player,...any?)->()

local RunService = game:GetService('RunService')

local FOLDER_NAME = 'Events'
local REMOTE_FOLDER = game.ReplicatedStorage:WaitForChild('Events',10) :: Folder
assert(REMOTE_FOLDER,`{FOLDER_NAME} Folder Not Found In Replecated Storage`)

local GENERAL_REMOTE_NAME = 'GENERAL'
local GENERAL_REMOTE = REMOTE_FOLDER:WaitForChild('GENERAL',10) :: RemoteEvent
assert(GENERAL_REMOTE,`{GENERAL_REMOTE_NAME} Remote Not Found In {REMOTE_FOLDER}`)


local connections: { [ClientCallBack | ServerCallBack]: RBXScriptConnection } = {}



local EventUtil = {}

EventUtil._FOLDER = REMOTE_FOLDER
EventUtil._KEY = 'Open'

--PROTECTED METHIDS
function EventUtil._ConnectCallBack(eventName: string,remote: RemoteEvent, callback: (any)->())
	assert(eventName,`No event name given`)
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


--- SERVER METHODS ---

-- SERVER: Fires Event To A Player
function EventUtil.FireClient(eventName: string, player: Player,...)
	GENERAL_REMOTE:FireClient(player,eventName,...)
end

-- SERVER: Receive Events Frome Player
function EventUtil.OnServer(eventName: string,severCallback: ServerCallBack)
	EventUtil._ConnectCallBack(eventName,GENERAL_REMOTE,severCallback)
end


--- CLIENT METHODS ---

-- CLIENT: Recive Event From SERVER
function EventUtil.OnClient(eventName: string, clientCallback: ClientCallBack)
	EventUtil._ConnectCallBack(eventName,GENERAL_REMOTE,clientCallback)
end

-- CLIENT: Recive Event From SERVER
function EventUtil.FireServer(eventName: string, ...)
	GENERAL_REMOTE:FireServer(eventName,...)
end

function EventUtil.Destroy(callback: ClientCallBack | ServerCallBack)
	if connections[callback] then
		connections[callback]:Disconnect()
		connections[callback] = nil
	end
end

return EventUtil