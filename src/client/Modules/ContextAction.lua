local ContextActionService = game:GetService("ContextActionService")
local player = game.Players.LocalPlayer
local keyMapper = require(game.ReplicatedStorage.Shared.Modules.KeyMapper)

type keyType = 'Xbox' | 'PC'

type CallBack = (actionName: string, inputState: Enum.UserInputState) -> ()

type keyTableType = {
    [keyType]: string
}

local Actions: { [string]: { { Priority: number, Callback: CallBack } } } = {}

local function HandleAction(actionName: string, inputState: Enum.UserInputState)
    local actionList = Actions[actionName]
    if not actionList or #actionList == 0 then return end

    table.sort(actionList, function(a, b)
        return a.Priority > b.Priority
    end)

    for i, action in ipairs(actionList) do
        local result = action.Callback(actionName, inputState)
        if result == Enum.ContextActionResult.Sink then
            return
        elseif result ~= Enum.ContextActionResult.Pass then
            break
        end
    end
end


local function BindKeybind(index: string, keybindTable: keyTableType, priority: number, callback: CallBack)
    local inputTable = {
         keyMapper.GetEnumFromString(keybindTable['Xbox']),
         keyMapper.GetEnumFromString(keybindTable['PC'])
    }

    Actions[index] = Actions[index] or {}
    table.insert(Actions[index], { Priority = priority or 0, Callback = callback })

    if #Actions[index] == 1 then
        ContextActionService:BindActionAtPriority(index, HandleAction, false, priority or 0, table.unpack(inputTable))
    end
end

local function UnbindKeybind(keybindName: string, callback: CallBack?)
    if not Actions[keybindName] then return end

    if callback then
        for i, action in ipairs(Actions[keybindName]) do
            if action.Callback == callback then
                table.remove(Actions[keybindName], i)
                break
            end
        end
    else
        Actions[keybindName] = nil
    end

    if not Actions[keybindName] or #Actions[keybindName] == 0 then
        ContextActionService:UnbindAction(keybindName)
    end
end

return {
    BindKeybind = BindKeybind,
    UnbindKeybind = UnbindKeybind,
}
