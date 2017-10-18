--// Initialization

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Resources = require(ReplicatedStorage:WaitForChild("Resources"))
local GetRemoteEvent = Resources.GetRemoteEvent
local GetRemoteFunction = Resources.GetRemoteFunction

local Module = {}

--// Functions

function Module.WrapInRemoteEvent(Name, Function)
	local RemoteEvent = GetRemoteEvent(Name)
	
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
	local RemoteFunction = GetRemoteFunction(Name)
	
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
