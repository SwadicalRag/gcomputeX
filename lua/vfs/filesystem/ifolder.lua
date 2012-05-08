local self = {}
VFS.IFolder = VFS.MakeConstructor (self, VFS.INode)

function self:ctor ()
end

--[[
	IFolder:Delete (authId, function (ReturnCode))
		
		Do not implement this, implement IFolder:DeleteDirectChild instead
		Delete this filesystem node
]]
function self:Delete (authId, callback)
	if not self:GetParentFolder () then
		VFS.Error ("IFolder:Delete : " .. self:GetPath () .. " has no parent folder from which to delete.")
		PrintTable (self)
		PrintTable (debug.getinfo (self.ctor))
		return
	end
	self:GetParentFolder ():DeleteDirectChild (authId, self:GetName (), callback)
end

--[[
	IFolder:DeleteChild (authId, path, function (ReturnCode))
		
		Do not implement this, implement IFolder:DeleteDirectChild instead
		Delete this filesystem node at the given path, relative to this folder
]]
function self:DeleteChild (authId, path, callback)
	callback = callback or VFS.NullCallback

	self:GetChild (authId, path,
		function (returnCode, node)
			if returnCode == VFS.ReturnCode.None then
				node:Delete (authId, callback)
			else
				callback (returnCode)
			end
		end
	)
end

--[[
	IFolder:DeleteDirectChild (authId, name, function (ReturnCode))
	
		Delete the node in this folder with the given name
]]
function self:DeleteDirectChild (authId, name, callback)
	VFS.Error ("IFolder:DeleteDirectChild : Not implemented")
	
	callback = callback or VFS.NullCallback
	callback (VFS.ReturnCode.AccessDenied)
end

--[[
	IFolder:EnumerateChildren (authId, function (ReturnCode, INode))
]]
function self:EnumerateChildren (authId, callback)
	VFS.Error ("IFolder:EnumerateChildren : Not implemented")
	
	callback (VFS.ReturnCode.Finished)
end

--[[
	IFolder:GetChild (authId, path, function (ReturnCode, INode))
		
		Do not implement this, implement IFolder:GetDirectChild instead
]]
function self:GetChild (authId, path, callback)
	callback = callback or VFS.NullCallback
	
	local path = VFS.Path (path)
	
	if path:IsEmpty () then
		callback (VFS.ReturnCode.None, self)
		return
	end

	self:GetDirectChild (authId, path:GetSegment (0),
		function (returnCode, node)
			path:RemoveFirstSegment ()
			if path:IsEmpty () then
				callback (returnCode, node)
			else
				if returnCode == VFS.ReturnCode.None then
					if node:IsFolder () then
						node:GetChild (authId, path, callback)
					else
						callback (VFS.ReturnCode.NotAFolder)
					end
				else
					callback (returnCode)
				end
			end
		end
	)
end

--[[
	IFolder:GetDirectChild (authId, name, function (ReturnCode, INode))
]]
function self:GetDirectChild (authId, name, callback)
	VFS.Error ("IFolder:GetDirectChild : Not implemented")
	
	callback = callback or VFS.NullCallback
	callback (VFS.ReturnCode.NotFound)
end

function self:GetName ()
	VFS.Error ("IFolder:GetName : Not implemented")
    return "[Folder]"
end

function self:GetNodeType ()
	return VFS.NodeType.Folder
end