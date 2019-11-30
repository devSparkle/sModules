--// Initialization

local CollectionService = game:GetService("CollectionService")

local Module = {}

--// Functions

function Module.BindToTag(Tag, Callback)
	spawn(function()
		for _, TaggedItem in next, CollectionService:GetTagged(Tag) do
			spawn(function()
				Callback(TaggedItem)
			end)
		end
	end)
	
	return CollectionService:GetInstanceAddedSignal(Tag):Connect(Callback)
end

function Module.BindToTagRemoved(Tag, Callback)
	return CollectionService:GetInstanceRemovedSignal(Tag):Connect(Callback)
end

return Module