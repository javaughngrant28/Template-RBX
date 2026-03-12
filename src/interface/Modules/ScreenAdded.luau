local Players = game:GetService("Players")

type CallbackFunction = (screen: ScreenGui) -> ()
type CallbackMap = {[number]: CallbackFunction}

local registeredCallbacks: {[string]: CallbackMap} = {}
local nextCallbackId = 0

local function generateId(): number
	nextCallbackId += 1
	return nextCallbackId
end

local function fireCallbacks(gui: ScreenGui, callbacks: CallbackMap)
	for _, callback in callbacks do
		task.spawn(callback, gui)
	end
end

local function findExistingGUI(guiName: string, callback: CallbackFunction)
	for _, child in Players.LocalPlayer.PlayerGui:GetChildren() do
		if not child:IsA("ScreenGui") then continue end
		if child.Name == guiName then
			task.spawn(callback, child :: ScreenGui)
		end
	end
end

local function registerCallback(guiName: string, callback: CallbackFunction): number
	local id = generateId()
	if not registeredCallbacks[guiName] then
		registeredCallbacks[guiName] = {}
	end
	registeredCallbacks[guiName][id] = callback
	return id
end

local function unregisterCallback(guiName: string, id: number)
	local callbacks = registeredCallbacks[guiName]
	if not callbacks then return end

	callbacks[id] = nil

	if next(callbacks) == nil then
		registeredCallbacks[guiName] = nil
	end
end

local function onChildAdded(child: Instance)
	if not child:IsA("ScreenGui") then return end
	local gui = child :: ScreenGui
	local callbacks = registeredCallbacks[gui.Name]
	if callbacks then
		fireCallbacks(gui, callbacks)
	end
end

Players.LocalPlayer.PlayerGui.ChildAdded:Connect(onChildAdded)

-- Class

local ScreenAdded = {}
ScreenAdded.__index = ScreenAdded

export type ScreenAdded = typeof(setmetatable(
	{} :: {
		_guiName: string,
		_callbackId: number,
		_destroyed: boolean,
	},
	ScreenAdded
))

function ScreenAdded.new(guiName: string, callback: CallbackFunction): ScreenAdded
	assert(type(guiName) == "string", "ScreenAdded.new: argument #1 must be a string")
	assert(type(callback) == "function", "ScreenAdded.new: argument #2 must be a function")

	local self = setmetatable({
		_guiName = guiName,
		_callbackId = registerCallback(guiName, callback),
		_destroyed = false,
	}, ScreenAdded)

	findExistingGUI(guiName, callback)

	return self
end

function ScreenAdded.Destroy(self: ScreenAdded)
	if self._destroyed then return end
	self._destroyed = true
	unregisterCallback(self._guiName, self._callbackId)
end

return ScreenAdded