--// Initialization

local CollectionService = game:GetService("CollectionService")

local Module = {}

--// Functions

function Module.BindToTag(Tag, Callback)
	CollectionService:GetInstanceAddedSignal(Tag):Connect(Callback)
	
	for _, TaggedItem in next, CollectionService:GetTagged(Tag) do
		spawn(function()
			Callback(TaggedItem)
		end)
	end
end

function Module.BindToTagRemoved(Tag, Callback)
	CollectionService:GetInstanceRemovedSignal(Tag):Connect(Callback)
end

return Module
