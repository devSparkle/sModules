--// Initialization

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Overture = require(ReplicatedStorage:WaitForChild("Overture"))

local Module = {}

--// Functions

function Module.WrapInRemoteEvent(Name, Function)
	local RemoteEvent = Overture:GetRemoteEvent(Name)
	
	if RunService:IsServer() then
		RemoteEvent.OnServerEvent:Connect(Function)
	end
	
	return function(...)
		if RunService:IsClient() then
			RemoteEvent:FireServer(...)
		else
			Function(...)
		end
	end
end

function Module.WrapInRemoteFunction(Name, Function)
	local RemoteFunction = Overture:GetRemoteFunction(Name)
	
	if RunService:IsServer() then
		RemoteFunction.OnServerInvoke = Function
	end
	
	return function(...)
		if RunService:IsClient() then
			return RemoteFunction:InvokeServer(...)
		else
			return Function(...)
		end
	end
end

return Module