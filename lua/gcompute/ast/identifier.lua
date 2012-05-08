local self = {}
self.__Type = "Identifier"
GCompute.AST.Identifier = GCompute.AST.MakeConstructor (self, GCompute.AST.Expression)

function self:ctor (name)
	self.Name = name
	self.NameTable = nil
	
	self.LookupType = GCompute.AST.NameLookupType.Reference
	self.NameResolutionResults = GCompute.NameResolutionResults ()
	self.ResultsPopulated = false
end

function self:Evaluate (executionContext)
	if not self.NameTable then
		self.NameTable = {self.Name}
	end
	if self.LookupType == GCompute.AST.NameLookupType.Value then
		return executionContext.ScopeLookup:Get (self.NameTable)
	else
		return executionContext.ScopeLookup:GetReference (self.NameTable)
	end
end

function self:GetLookupType ()
	return self.LookupType
end

function self:GetName ()
	return self.Name
end

function self:SetLookupType (lookupType)
	self.LookupType = lookupType
end

function self:SetName (name)
	self.Name = name
end

function self:ToString ()
	return self.Name or "[Identifier]"
end