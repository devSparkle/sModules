--// Initialization

local Module	= {}

--// Functions

function Module.RoundNumber(Number, Divider)
	--/ Rounds a number using round half up
	
	Divider = Divider or 1
	return math.floor(Number / Divider + 0.5) * Divider
end

function Module.PickRandom(Values)
	--/ Will return a random pick from a table; NOT DICTIONARY
	
	return Values[math.random(1, #Values)]
end

function Module.GenerateString(Length)
	--/ Will return a random string of the required length
	
	assert(Length ~= nil, "A string length must be specified")
	
	local GeneratedString = ""
	
	for Count = 1, Length do
		GeneratedString = GeneratedString .. string.char(math.random(65, 90))
	end
	
	return GeneratedString
end

function Module.GetIndexByValue(Values, DesiredValue)
	--/ Returns the index of a value in a table or dictionary
	
	for Index, Value in next, Values do
		if Value == DesiredValue then
			return Index
		end
	end
end

function Module.MergeTables(...)
	--/ Merges tables and dictionaries
	
	local MergedTable = {}
	
	for ArgumentIndex, Argument in ipairs({...}) do
		assert(type(Argument) == "table", "Argument " .. ArgumentIndex .. " is not a table")
		
		for Index, Value in ipairs(Argument) do
			if type(Index) == "number" then
				table.insert(MergedTable, Value)
			else
				table.insert(MergedTable, Index, Value)
			end
		end
	end
	
	return MergedTable
end

function Module.GetDescendants(ObjectInstance)
    --/ Returns descendants of an Instances

	assert(typeof(ObjectInstance) == "Instance", "ObjectInstance is not an Instance")
	local Descendants = ObjectInstance:GetChildren()
	local NumDescendants = #Descendants
	local Count = 0

	repeat
		Count = Count + 1
		local GrandChildren = Descendants[Count]:GetChildren()
		local NumGrandChildren = #GrandChildren
		for a = 1, NumGrandChildren do
			Descendants[NumDescendants + a] = GrandChildren[a]
		end
		NumDescendants = NumDescendants + NumGrandChildren
	until Count == NumDescendants

	return Descendants
end

for CallOnObjects, GetObjects in next, {CallOnChildren = game.GetChildren, CallOnDescendants = Module.GetDescendants} do
	Module[CallOnObjects] = function(ParentInstance, FunctionToCall)
		--/ Runs a function on all children and/or descendants of an Instance

		assert(typeof(ParentInstance) == "Instance", "ParentInstance is not an Instance")
		assert(type(FunctionToCall) == "function", "FunctionToCall is not a function")

		local Objects = GetObjects(ParentInstance)
		for a = 1, #Objects do
			FunctionToCall(Objects[a])
		end
	end
end

function Module.Modify(ObjectInstance, Values)
	--/ Modifies an Instance using a table of properties and values
	
	assert(typeof(ObjectInstance) == "Instance", "ObjectInstance is not an Instance")
	assert(type(Values) == "table", "Values is not a table")
	
	for Property, Value in next, Values do
		if type(Property) == "number" then
			Value.Parent = ObjectInstance
		else
			ObjectInstance[Property] = Value
		end
	end
	
	return ObjectInstance
end

function Module.Retrieve(InstanceName, InstanceClass, InstanceParent)
	--/ Finds an Instance by name and creates a new one if it doesen't exist
	
	local SearchInstance = nil
	local InstanceCreated = false
	
	if InstanceParent:FindFirstChild(InstanceName) then
		SearchInstance = InstanceParent[InstanceName]
	else
		InstanceCreated = true
		SearchInstance = Instance.new(InstanceClass)
		SearchInstance.Name = InstanceName
		SearchInstance.Parent = InstanceParent
	end
	
	return SearchInstance, InstanceCreated
end

return Module
