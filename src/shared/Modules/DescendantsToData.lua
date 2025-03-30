

function ExtractTableFromFolder(folder: Folder): {}
	local data = {}

	for _, child in ipairs(folder:GetChildren()) do
		local value = ExtractValueFromInstance(child)
		if value ~= nil then
			data[child.Name] = value
		end
	end

	return data
end

function ExtractValueFromInstance(instance: Instance): any
	if instance:IsA("NumberValue") then
		return instance.Value
	elseif instance:IsA("StringValue") then
		return instance.Value
	elseif instance:IsA("BoolValue") then
		return instance.Value
	elseif instance:IsA("Folder") then
		return ExtractTableFromFolder(instance)
	end
	return nil
end


local DescendantsToData = {}

function DescendantsToData.Fire(parentInstance: Instance): { [string]: any }
	local extractedData = {}

	for _, child in ipairs(parentInstance:GetChildren()) do
		local value = ExtractValueFromInstance(child)
		if value ~= nil then
			extractedData[child.Name] = value
		end
	end

	return extractedData
end

return DescendantsToData
