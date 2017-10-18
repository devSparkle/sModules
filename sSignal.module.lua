--// Initialization

local Module	= {}

--// Functions

function Module.CreateSignal()
	local Signal = {}
	
	local BindableEvent = Instance.new("BindableEvent")
	local Connections = {}
	
	function Signal:Connect(Function)
	--	assert(self ~= Signal, "Connect must be called as a method with \":\" not \".\"")
	--	assert(typeof(Function) ~= "function", "Argument #1 of method \"Connect\" must be a function, got a " .. typeof(Function))
		
		local Connection = BindableEvent.Event:Connect(Function)
		local PublicConnection = {}
		
		Connections[Connection] = true
		
		function PublicConnection:Disconnect()
			Connection:Disconnect()
			Connections[Connection] = nil
		end
		
		return PublicConnection
	end
	
	function Signal:Disconnect()
		assert(self ~= Signal, "Connect must be called as a method with \":\" not \".\"")
		
		for Connection, _ in next, Connections do
			Connection:Disconnect()
			Connections[Connection] = nil
		end
	end
	
	function Signal:Wait()
		assert(self ~= Signal, "Connect must be called as a method with \":\" not \".\"")
		
		return BindableEvent.Event:Wait()
	end
	
	function Signal:Fire(...)
	--	assert(self ~= Signal, "Connect must be called as a method with \":\" not \".\"")
		
		BindableEvent:Fire(...)
	end
	
	return Signal
end

return Module
