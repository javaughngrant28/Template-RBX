local CollectionService = game:GetService("CollectionService")

--[[
	Returns a table of all *direct child* Instances of `parent` that have the given tag.
]]
local function GetAllChildInstanceWithTag(parent: Instance, tagName: string): {Instance}
	local results = {}

	for _, child in parent:GetChildren() do
		if CollectionService:HasTag(child, tagName) then
			table.insert(results, child)
		end
	end

	return results
end

--[[
	Returns a table of all *descendant* Instances of `parent` that have the given tag.
]]
local function GetAllDescendantsInstanceWithTag(parent: Instance, tagName: string): {Instance}
	local results = {}

	for _, descendant in parent:GetDescendants() do
		if CollectionService:HasTag(descendant, tagName) then
			table.insert(results, descendant)
		end
	end

	return results
end

--[[
	Returns the *first* descendant of `parent` that has the given tag, or nil if none exist.
]]
local function GetFirstInstanceWithTag(parent: Instance, tagName: string): Instance?
	for _, descendant in parent:GetDescendants() do
		if CollectionService:HasTag(descendant, tagName) then
			return descendant
		end
	end

	return nil
end


return {
	GetFirstInstance = GetFirstInstanceWithTag,
	GetChildren = GetAllChildInstanceWithTag,
	GetDescendants = GetAllDescendantsInstanceWithTag,
}

