local self = {}
GCompute.ProcessList = GCompute.MakeConstructor (self)

--[[
	Events:
		ProcessCreated (Process process)
			Fired when a new process is created.
		ProcessDestroyed (Process process)
			Fired when a process terminates.
]]

function self:ctor ()
	self.Processes = {}
	
	self.NextProcessId = math.random (0, 0xFFFF) * 0x00010000
	
	GCompute.EventProvider (self)
end

function self:CreateProcess ()
	local processId = self.NextProcessId
	local process = GCompute.Process (self, processId)
	self.NextProcessId = self.NextProcessId + 4
	
	self.Processes [processId] = process
	
	self:DispatchEvent ("ProcessCreated", process)
	
	return process
end

function self:GetEnumerator ()
	return pairs (self.Processes)
end