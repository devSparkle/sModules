--// Initialization

local CollectionService = game:GetService("CollectionService")

local Module = {}

--// Functions

function Module.BindToTag(Tag, Callback)
	task.spawn(function()
		for _, TaggedItem in next, CollectionService:GetTagged(Tag) do
			task.spawn(Callback, TaggedItem)
		end
	end)
	
	return CollectionService:GetInstanceAddedSignal(Tag):Connect(Callback)
end

function Module.BindToTagRemoved(Tag, Callback)
	return CollectionService:GetInstanceRemovedSignal(Tag):Connect(Callback)
end

return Module