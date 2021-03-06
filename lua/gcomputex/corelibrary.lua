local Global        = GCompute.GlobalNamespace
local Object        = Global:AddClass ("Object")
local Type          = Global:AddClass ("Type")
local Namespace     = Global:AddClass ("Namespace")
local Function      = Global:AddClass ("Function")
local FunctionGroup = Global:AddClass ("FunctionGroup")

local Void          = Global:AddClass ("Void")
Void:GetClassType ():SetBottom (true)
GCompute.TypeSystem:SetBottom (Void)

local Boolean       = Global:AddClass ("Boolean")
local Number        = Global:AddClass ("Number")
local Integer       = Global:AddClass ("Integer")
local String        = Global:AddClass ("String")

Global:AddAlias ("object",  "Object")
Global:AddAlias ("type",    "Type")
Global:AddAlias ("void",    "Void")
Global:AddAlias ("bool",    "Boolean")
Global:AddAlias ("boolean", "Boolean")
Global:AddAlias ("number",  "Number")
Global:AddAlias ("double",  "Number")
Global:AddAlias ("int",     "Integer")
Global:AddAlias ("string",  "String")