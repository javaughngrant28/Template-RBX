
local CollectionService = game:GetService("CollectionService")

type Callback = (instance: Instance)->()

local function tagRemovedConenction(tag: string, callback: (instance: Instance) -> ()): RBXScriptConnection
	return CollectionService:GetInstanceRemovedSignal(tag):Connect(callback)
end

local function tagAddedConenction(tag: string, callback: (instance: Instance) -> ()): RBXScriptConnection
	return CollectionService:GetInstanceAddedSignal(tag):Connect(callback)
end

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


local function OnTagAdded(tag: string, callback: (istance: Instance)->()): RBXScriptConnection
	local connection = tagAddedConenction(tag,callback)
	local taggedInstances = CollectionService:GetTagged(tag)
	for _, instance: Instance in taggedInstances do
		callback(instance)
	end
	return connection
end

local function FireCallbackForMatchingInstances(insatnce1: Instance, insatnce2: Instance, callback: Callback)
	if insatnce1 ~= insatnce2 then return end
	callback(insatnce1)
end

local function TagAddedToInsatnce(tag: string, instance: Instance, callback: Callback): RBXScriptConnection
	local connection = tagAddedConenction(tag,function(child: Instance)
		FireCallbackForMatchingInstances(instance,child,callback)
	end)

	for _, child: Instance in CollectionService:GetTagged(tag) do
		FireCallbackForMatchingInstances(instance,child,callback)
	end

	return connection
end

local function OnTagRemovingFromInstance(tag: string, instance: Instance, callback: Callback)
	return tagRemovedConenction(tag,function(child: Instance)
		FireCallbackForMatchingInstances(instance,child,callback)
	end)
end



return {
	GetFirstInstance = GetFirstInstanceWithTag,
	GetChildren = GetAllChildInstanceWithTag,
	GetDescendants = GetAllDescendantsInstanceWithTag,
	AddedConenction = tagAddedConenction,
	OnTagAdded = OnTagAdded,
	OnTagRemove = tagRemovedConenction,
	AddedToInstance = TagAddedToInsatnce,
	RemoveFromInstance = OnTagRemovingFromInstance,
}
