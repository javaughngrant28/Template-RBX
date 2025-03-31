
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local InputEvent: NameSpaceEvent.Client = NameSpaceEvent.new('Input',{'Connect','Disconnect'})

local InputBase = require(script.Parent.InputBase)

local InputList: {[string]: InputBase.InputBaseType} = {
}

local CreateInputObjects: {[RemoteEvent]: InputBase.InputBaseType} = {}


local function onConnect(inputName: string,remote: RemoteEvent, props: {any})
    assert(inputName and typeof(inputName) =="string",`{inputName}: Invalid`)
    assert(remote and remote:IsA('RemoteEvent'),`{remote}: Invalid`)

    local InputObject = InputList[inputName]
    assert(InputObject,`{inputName}: Not found in input list`)
    assert(not CreateInputObjects[remote],`{inputName} and remote {remote} has object assigned`)

    CreateInputObjects[remote] = InputObject.new(remote,props)
end

local function onDisconnect(remote: RemoteEvent)
    assert(remote and remote:IsA('RemoteEvent'),`Invalid Remote Event: {remote}`)
    local InputObject = CreateInputObjects[remote]
    assert(InputObject,`{remote}: No Input object found`)

    InputObject:Destroy()
    CreateInputObjects[remote] = nil
end


InputEvent:OnClient('Connect',onConnect)
InputEvent:OnClient('Disconnect',onDisconnect)

