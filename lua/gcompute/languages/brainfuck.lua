local LANGUAGE = GCompute.Languages.Create ("Brainfuck")

-- Tokenizer
LANGUAGE:AddCustomSymbols ({"\"", "'"}, GCompute.TokenType.String, function (Code)
	local i = 2
	local Escaped = false
	while true do
		local c = Code:sub (i, i)
		if c == "" then
			return Code:sub (1, i) .. Code:sub (1, 1), i
		else
			if Escaped then
				Escaped = false
			else
				if c == "\\" then
					Escaped = true
				elseif c == Code:sub (1, 1) then
					return Code:sub (1, i), i
				end
			end
		end
		i = i + 1
	end
end)
LANGUAGE:AddCustomSymbol ("/*", GCompute.TokenType.Comment, function (Code)
	local i = 3
	while true do
		local c = Code:sub (i, i + 1)
		if c == "" then
			return Code:sub (1, i), i
		elseif c == "*/" then
			return Code:sub (1, i + 1), i + 1
		end
		i = i + 1
	end
	return nil, 0
end)
LANGUAGE:AddSymbol ("//[^\n\r]*", GCompute.TokenType.Comment)
LANGUAGE:AddSymbol ("[<>+\\-]+", GCompute.TokenType.Operator)
LANGUAGE:AddSymbols ({"[", "]"}, GCompute.TokenType.Operator, false)

LANGUAGE:LoadParser ()