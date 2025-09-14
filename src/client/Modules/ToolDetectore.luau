local Players = game:GetService("Players")
local MaidModule = require(game.ReplicatedStorage.Shared.Libraries.Maid)
local Signal = require(game.ReplicatedStorage.Shared.Libraries.Signal)

local Player = Players.LocalPlayer
local backpack = Player:WaitForChild('Backpack')

local Maid: MaidModule.Maid = MaidModule.new()


local Signals = {
    AddedSignal = Signal.new(),
    EquippedSignal = Signal.new(),
    UnequippedSignal = Signal.new(),
    DestroyedSignal = Signal.new(),
}

local toolTable: {Tool} = {}


local function NewToolCheck(tool: Tool)
    if table.find(toolTable,tool) then return end
    table.insert(tool)
    Signals.AddedSignal:Fire(tool)
end

local function ToolFoundInCharacter(tool: Tool)
    NewToolCheck(tool)
    Signals.EquippedSignal:Fire()
end

local function ToolFoundInBackPack(tool: Tool)
    NewToolCheck(tool)
    Signals.UnequippedSignal:Fire(tool)
end

local function ToolDestored(tool: Tool)
    Signals.DestroyedSignal:Fire(tool)
    local index = table.find(toolTable,tool)
    if index then
        table.remove(toolTable,index)
    end
end

local function DetectToolDestorying(tool: Tool)
    local connection: RBXScriptSignal
    connection = tool.AncestryChanged:Connect(function(_, parent: Instance?)
        if not parent or parent == nil then
            ToolDestored(tool)
            connection:Disconnect()
            connection = nil
        end
    end)
end

local function CheckForTool(parent: Instance, child: Tool?)
     if not child:IsA('Tool') then return end
    if parent.IsA('Model') then
        ToolFoundInCharacter(child)
    else
        ToolFoundInBackPack(child)
    end
    DetectToolDestorying(child)
end

local function CreateToolAddedConnection(instance: Instance)
    Maid[instance.Name..'Connection'] = instance.ChildAdded:Connect(function(child)
        CheckForTool(instance,child)
    end)
end

local function FindTool(instance: Instance)
     for _, child in instance:GetChildren() do
        CheckForTool(instance,child)
    end
end



FindTool(Player.Backpack)
CreateToolAddedConnection(Player.Backpack)

if Player.Character then
    CreateToolAddedConnection(Player.Character)
    FindTool(Player.Character)
end

Player.CharacterAdded:Connect(function(character)
    CreateToolAddedConnection(character)
end)


return Signals