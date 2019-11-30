--// Initialization

local RandomObject = Random.new()

local Module = {}

--// Functions

function Module.RoundNumber(Number, Divider)
	--/ Rounds a number using round half up
	
	Divider = Divider or 1
	return math.floor(Number / Divider + 0.5) * Divider
end

function Module.PickRandom(Haystack)
	--/ Returns a random pick from a table; NOT DICTIONARY
	
	return Haystack[RandomObject:NextInteger(1, #Haystack)]
end

function Module.GenerateString(Length)
	--/ Returns a random string of the required length
	
	assert(Length ~= nil, "A string length must be specified")
	
	local GeneratedString = ""
	
	for Count = 1, Length do
		GeneratedString = GeneratedString .. string.char(math.random(65, 90))
	end
	
	return GeneratedString
end

function Module.SplitString(String, Delimiter)
	--/ Returns a table of string `String` split by pattern `Delimiter`

	local StringParts = {}
	local Pattern = ("([^%s]+)"):format(Delimiter)

	String:gsub(Pattern, function (Part)
		table.insert(StringParts, Part)
	end)

	return StringParts
end;

function Module.FindTableOccurrences(Haystack, Needle)
	--/ Returns the positions of any occurrences of "Needle" in table or dictionary "Haystack"
	
	local Positions = {}
	
	for Index, Value in next, Haystack do
		if Value == Needle then
			table.insert(Positions, Index)
		end
	end
	
	return Positions
end

function Module.FindTableOccurrence(Haystack, Needle)
	--/ Returns the position of the first occurrence of "Needle" in table or dictionary "Haystack"
	
	for Index, Value in next, Haystack do
		if Value == Needle then
			return Index
		end
	end
	
	return nil
end

function Module.IsInTable(Haystack, Needle)
	--/ Returns whether the given "Needle" is in table or dictionary "Haystack"
	
	for Index, Value in next, Haystack do
		if Value == Needle then
			return true
		end
	end
	
	return false
end

function Module.GetDescendants(ObjectInstance)
	--/ Returns descendants of an Instances
	
	local Descendants = ObjectInstance:GetChildren()
	local Count = 0
	
	repeat
		Count = Count + 1
		Descendants = Module.MergeTables(
			Descendants,
			Descendants[Count]:GetChildren()
		)
	until Count == #Descendants
	
	return Descendants
end

function Module.CallOnChildren(ParentInstance, FunctionToCall, Recursive)
	--/ Runs a function on all children of an Instance
	--/ If Recursive is true, will run on all descendants
	
	assert(typeof(ParentInstance) == "Instance", "ParentInstance is not an Instance")
	assert(type(FunctionToCall) == "function", "FunctionToCall is not a function")
	
	if #ParentInstance:GetChildren() == 0 then return end
	
	local Children = Recursive and Module.GetDescendants(ParentInstance) or ParentInstance:GetChildren()
	
	for _, Child in next, Children do
		FunctionToCall(Child)
	end
end

function Module.CallOnValues(Table, FunctionToCall)
	--/ Run a function on all values of a table or dictionary
	
	if #Table == 0 then return end
	
	for _, Value in next, Table do
		FunctionToCall(Value)
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

function Module.IteratePages(Pages)
	return coroutine.wrap(function()
		local PageNumber = 1

		while true do
			for _, Item in ipairs(Pages:GetCurrentPage()) do
				coroutine.yield(PageNumber, Item)
			end

			if Pages.IsFinished then
				break
			end

			Pages:AdvanceToNextPageAsync()
			PageNumber = PageNumber + 1
		end
	end)
end

function Module.WeldModel(PrimaryPart, Model, WeldType)
	local Targets = typeof(Model) == "Instance" and Model:GetDescendants() or Model
	local WeldType = WeldType or "Weld"
	
	for _, Part in next, Targets do
		if Part:IsA("BasePart") then
			if Part ~= PrimaryPart then
				local Weld = Instance.new(WeldType)
				
				if WeldType ~= "WeldConstraint" then
					Weld.C0 = Part.CFrame:toObjectSpace(PrimaryPart.CFrame)
				end
				
				Weld.Part0 = Part
				Weld.Part1 = PrimaryPart
				
				Weld.Parent = Part
				Part.Anchored = false
			end
		end
	end
end

return Module
