
local function CreateInstanceFromValue(index, data: any): Instance | nil
	-- Guard clause for unsupported data types
	if typeof(data) ~= "number" and typeof(data) ~= "string" and typeof(data) ~= "boolean" then
		warn("Unsupported data type for: ", index)
		return nil
	end

	local instance: ValueBase

	if typeof(data) == "number" then
		instance = Instance.new('NumberValue')
	elseif typeof(data) == "string" then
		instance = Instance.new('StringValue')
	elseif typeof(data) == "boolean" then
		instance = Instance.new('BoolValue')
	end

	instance.Name = index
	instance.Value = data

	return instance
end

local function CreateFolderFromTable(folderName: string, dataTable: {}, parent: Instance)
	-- Guard clause for invalid data types
	if typeof(dataTable) ~= "table" then
		warn(folderName, "is not a valid table")
		return
	end

	local folder = Instance.new('Folder')
	folder.Name = folderName
	folder.Parent = parent

	for index: string, value: any in pairs(dataTable) do
		if typeof(value) == 'table' then
			-- Recursive call for nested tables
			CreateFolderFromTable(index, value, folder)
		else
			-- Create value instance for non-table values
			local valueInstance = CreateInstanceFromValue(index, value)
			if valueInstance then
				valueInstance.Parent = folder
			end
		end
	end
end



local TransformData = {}

local TransformData = {}

function TransformData.ToInstance(ParentInstance: Instance, tableWithValues: {string: any})
    for index: string, value: any in pairs(tableWithValues) do
        if typeof(value) == 'table' then
            CreateFolderFromTable(index, value, ParentInstance)
        else
            local valueInstance = CreateInstanceFromValue(index, value)
            if valueInstance then
                valueInstance.Parent = ParentInstance
            end
        end
    end
end

--[[
    Returns a Table of the children into their datatype, their names will be used as keys.
    Only works with folders and ValueBase Objects.
]]
function TransformData.FromInstanceToDataType(instance: Instance): {}
    if not instance or not instance:IsA("Instance") then
        warn("Invalid instance provided.")
        return {}
    end

    local result = {}

    for _, child in ipairs(instance:GetChildren()) do
        if child:IsA("Folder") then
            result[child.Name] = TransformData.FromInstanceToDataType(child)
        elseif child:IsA("ValueBase") then
            if child:IsA("NumberValue") then
                result[child.Name] = child.Value
            elseif child:IsA("StringValue") then
                result[child.Name] = child.Value
            elseif child:IsA("BoolValue") then
                result[child.Name] = child.Value
            else
                print("Unsupported ValueBase type:", child.ClassName)
            end
        else
            print("Unsupported child type:", child.ClassName)
        end
    end

    return result
end

return TransformData