

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

local function GetRootPartFromModel(characterModel: Model): BasePart
    assert(characterModel and characterModel:IsA('Model'),`Character Model: Invalid: {characterModel}`)
    local rootPart = characterModel:FindFirstChild('HumanoidRootPart') or characterModel.PrimaryPart
    assert(rootPart,`{characterModel} Has No HumanoidRootPart or PrimaryPart`)
    return rootPart
end

local Position = {}

function Position.InsatnceInPart(instance: Instance, part: BasePart)
    local instance = not Instance:IsA('Model') and instance or GetRootPartFromModel(instance)
    local spawnCFrame = GetCFrameFromPart(part)
    
    if instance:IsA("Model") then
        task.defer(workspace.PivotTo, instance, spawnCFrame)
    else
        instance.CFrame = spawnCFrame
    end
end


function Position.InstanceAtPart(instance: Instance, part: BasePart)
    local instance = not instance:IsA('Model') and instance or GetRootPartFromModel(instance)

    if instance:IsA("Model") then
        task.defer(workspace.PivotTo, instance, part.CFrame)
    else
        instance.CFrame = part.CFrame
    end
end

function Position.AtRandomPartInFolder(instance: Instance, folder: Folder)
    assert(folder and folder:IsA('Folder'), "Invalid folder")
    local part = GetRandomPartFromFolder(folder)
    Position.InsatnceInPart(instance, part)
end

return Position
