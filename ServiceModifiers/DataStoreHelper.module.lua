--// Initialization

local DataStoreService	= game:GetService("DataStoreService")

--// Wrappers

local DataStore = {
	__index = function(self, i)
		local DataStore = self.DataStore
		local Function = DataStore[i]
		local function f(self, ...)
			local Success, Value
			repeat Success, Value = pcall(Function, DataStore, ...)
			until Success
			return Value
		end
		self[i] = f
		return f
	end
}

return setmetatable({}, {
	__index = function(self, i) -- Wraps DataStoreService functions in a pcall
		local Function = DataStoreService[i]
		local function f(self, ...)
			local Success, Value
			repeat Success, Value = pcall(Function, DataStoreService, ...)
			until Success
			return setmetatable({DataStore = Value}, DataStore)
		end
		self[i] = f
		return f
	end
})
