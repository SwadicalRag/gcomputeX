local self = {}
self.__Type = "FunctionCall"
GCompute.AST.FunctionCall = GCompute.AST.MakeConstructor (self, GCompute.AST.Expression)

function self:ctor ()
	self.LeftExpression = nil
	
	self.Arguments = {}
	self.ArgumentCount = 0
end

function self:AddArgument (argument)
	self.ArgumentCount = self.ArgumentCount + 1
	self.Arguments [self.ArgumentCount] = argument
	if argument then argument:SetParent (self) end
end

function self:AddArguments (arguments)
	for _, argument in ipairs (arguments) do
		self:AddArgument (argument)
	end
end

function self:Evaluate (executionContext)
	local functionObject = nil
	if self.CachedFunction then
		functionObject = self.CachedFunction
	else
		functionObject = self.LeftExpression:Evaluate (executionContext)
	end

	if functionObject then
		local arguments = {}
		for i = 1, self.ArgumentCount do
			arguments [i] = self.Arguments [i]:Evaluate (executionContext)
		end
		if false then
			-- self:IsMemberFunctionCall ()
			local this = self.LeftExpression.Left:Evaluate (executionContext)
			return functionObject:Call (executionContext, self.ArgumentTypes, this, unpack (arguments))
		else
			return functionObject:Call (executionContext, self.ArgumentTypes, unpack (arguments))
		end
	else
		executionContext:Error ("Unresolved function " .. self.LeftExpression:ToString () .. " in " .. self:ToString () .. ".")
	end
end

function self:GetArgument (index)
	return self.Arguments [index]
end

function self:GetArgumentCount ()
	return self.ArgumentCount
end

function self:GetLeftExpression ()
	return self.LeftExpression
end

function self:SetArgument (index, expression)
	self.Arguments [index] = expression
	if expression then expression:SetParent (self) end
end

function self:SetLeftExpression (leftExpression)
	self.LeftExpression = leftExpression
	if self.LeftExpression then self.LeftExpression:SetParent (self) end
end

function self:ToString ()
	local leftExpression = self.LeftExpression and self.LeftExpression:ToString () or "[Unknown Expression]"
	local arguments = ""
	for i = 1, self.ArgumentCount do
		if arguments ~= "" then
			arguments = arguments .. ", "
		end
		local argument = self.Arguments [i] and self.Arguments [i]:ToString () or "[Unknown Expression]"
		arguments = arguments .. argument
	end
	return leftExpression .. " (" .. arguments .. ")"
end