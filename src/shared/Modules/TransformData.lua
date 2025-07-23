
local function CreatValueInstance(name: string, dataType: any): ValueBase
	local valueInstance: ValueBase

	if typeof(dataType) == 'Instance' then
		valueInstance = Instance.new('ObjectValue')
	end

	if typeof(dataType) == "number" then
		valueInstance = Instance.new('NumberValue')
	end

	if typeof(dataType) == 'string' then
		valueInstance = Instance.new('StringValue')
	end

	if typeof(dataType) == 'boolean' then
		valueInstance = Instance.new('BoolValue')
	end

	if typeof(dataType) == 'CFrame' then
		valueInstance = Instance.new('CFrameValue')
	end

	if typeof(dataType) == 'Vector3' then
		valueInstance = Instance.new('Vector3Value')
	end

	if typeof(dataType) == 'BrickColor' then
		valueInstance = Instance.new('BrickColorValue')
	end

	if typeof(dataType) == 'Color3' then
		valueInstance = Instance.new('Color3Value')
	end

	if typeof(dataType) == 'Ray' then
		valueInstance = Instance.new('RayValue')
	end

	assert(dataType,`{dataType} Does Not Have A ValueBase`)

	valueInstance.Name = name
	valueInstance.Value = dataType

	return valueInstance
end

-- Creates 
local function DataToInsatnce(parentInstance: Instance, data: {[string]: any})
	for index: string, value: any  in pairs(data) do
		if typeof(value) == 'table' then
			local folder = Instance.new('Folder')
			folder.Name = index
			folder.Parent = parentInstance
			DataToInsatnce(folder,value)
		else
			local valueInstance = CreatValueInstance(index,value)
			valueInstance.Parent = parentInstance
		end
	end 
end


return {
	ToInstance = DataToInsatnce
}
