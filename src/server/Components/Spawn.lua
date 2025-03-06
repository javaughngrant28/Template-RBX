local FunctionUtil = require(game.ReplicatedStorage.Shared.Utils.FunctionUtil)

local function setCollisions(character: Model)
    if character then
        FunctionUtil.SetCollisionGroup(character, 'Char')
    end
end

local function RemoveCharacter(player: Player)
    local character = player.Character
    if character then
        character:Destroy()
        player.Character = nil
        task.wait()
    end
end

local function LoadCharacter(player: Player): Model
    player.CharacterAppearanceLoaded:Once(setCollisions)
    player:LoadCharacter()
    
    local character = player.Character or player.CharacterAdded:Wait()
    setCollisions(character)
    
    return character
end

local function GetCFrameFromPart(part: BasePart): CFrame
    local size, position = part.Size, part.Position

    local randomOffset = Vector3.new(
        math.random() * size.X - size.X / 2,
        math.random() * size.Y - size.Y / 2,
        math.random() * size.Z - size.Z / 2
    )

    return CFrame.new(position + randomOffset)
end

local function GetRandomPartFromFolder(folder: Folder): BasePart
    local parts = folder:GetChildren()
    local part = parts[math.random(1, #parts)]

    assert(part:IsA("BasePart"), "Invalid instance found in part folder")
    return part
end

local Spawn = {}

function Spawn.InPart(instance: Model | BasePart, part: BasePart)
    local spawnCFrame = GetCFrameFromPart(part)
    
    if instance:IsA("Model") then
        task.defer(workspace.PivotTo, instance, spawnCFrame)
    else
        instance.CFrame = spawnCFrame
    end
end

function Spawn.AtRandomPartInFolder(instance: Model | BasePart, folder: Folder)
    assert(folder and folder:IsA('Folder'), "Invalid folder")
    
    local part = GetRandomPartFromFolder(folder)
    Spawn.InPart(instance, part)
end

function Spawn.CharacterInPart(player: Player, part: BasePart): Model
    RemoveCharacter(player)
    
    local character = LoadCharacter(player)
    Spawn.InPart(character, part)

    return character
end

function Spawn.CharacterAtRandomPartInFolder(player: Player, folder: Folder): Model
    assert(folder and folder:IsA('Folder'), "Invalid folder")

    RemoveCharacter(player)
    
    local character = LoadCharacter(player)
    Spawn.AtRandomPartInFolder(character, folder)

    return character
end

return Spawn
