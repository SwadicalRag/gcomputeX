local self = {}
VFS.IFolder = VFS.MakeConstructor (self, VFS.INode)

--[[
	Events:
		NodeCreated (INode childNode)
			Fired when a new child file or folder has been created.
		NodeDeleted (INode deletedNode)
			Fired when a child file or folder has been deleted.
		NodePermissionsChanged (INode childNode)
			Fired when a child node's permissions have changed.
		NodeRenamed (INode childNode, string oldName, string newName)
			Fired when a child file or folder has been renamed.
]]

function self:ctor ()
end

--[[
	IFolder:CreateDirectFile (authId, name, function (returnCode, IFile file))
		
		Do not implement this, implement IFolder:CreateDirectNode instead
		Creates a file in this folder
]]
function self:CreateDirectFile (authId, name, callback)
	self:CreateDirectNode (authId, name, false, callback)
end

--[[
	IFolder:CreateDirectFolder (authId, name, function (returnCode, IFolder folder))
		
		Do not implement this, implement IFolder:CreateDirectNode instead
		Creates a folder in this folder
]]
function self:CreateDirectFolder (authId, name, callback)
	self:CreateDirectNode (authId, name, true, callback)
end

--[[
	IFolder:CreateDirectNode (authId, name, isFolder, function (returnCode, INode node))
		
		Create a node in this folder with the given name
]]
function self:CreateDirectNode (authId, name, isFolder, callback)
	VFS.Error ("IFolder:CreateDirectNode : Not implemented")
	
	callback = callback or VFS.NullCallback
	callback (VFS.ReturnCode.AccessDenied)
end

--[[
	IFolder:CreateFile (authId, path, function (returnCode, IFile file))
		
		Do not implement this, implement IFolder:CreateDirectNode instead
		Creates a file at the given path, relative to this folder
]]
function self:CreateFile (authId, path, callback)
	self:CreateNode (authId, path, false, callback)
end

--[[
	IFolder:CreateFolder (authId, path, function (returnCode, IFolder folder))
		
		Do not implement this, implement IFolder:CreateDirectNode instead
		Creates a folder at the given path, relative to this folder
]]
function self:CreateFolder (authId, path, callback)
	self:CreateNode (authId, path, true, callback)
end

--[[
	IFolder:CreateNode (authId, path, isFolder, function (returnCode, INode node))
		
		Do not implement this, implement IFolder:CreateDirectNode instead
		Creates a node at the given path, relative to this folder
]]
function self:CreateNode (authId, path, isFolder, callback)
	local path = VFS.Path (path)
	
	if path:IsEmpty () then
		callback (VFS.ReturnCode.Success, self)
		return
	end

	local segment = path:GetSegment (0)
	self:GetDirectChild (authId, segment,
		function (returnCode, node)
			path:RemoveFirstSegment ()
			if returnCode == VFS.ReturnCode.Success then
				if path:IsEmpty () then
					if node:IsFolder () == isFolder then callback (returnCode, node)
					elseif isFolder then callback (VFS.ReturnCode.NotAFolder)
					else
						callback (VFS.ReturnCode.NotAFile)
					end
				elseif node:IsFolder () then
					self:CreateNode (authId, path, isFolder, callback)
				else
					callback (VFS.ReturnCode.NotAFolder)
				end
			elseif returnCode == VFS.ReturnCode.NotFound then
				self:CreateDirectNode (authId, segment, isFolder,
					function (returnCode, node)
						if returnCode == VFS.ReturnCode.Success then
							if path:IsEmpty () then
								callback (returnCode, node)
							else
								self:CreateNode (authId, path, isFolder, callback)
							end
						else
							callback (returnCode)
						end
					end
				)
			else
				callback (returnCode)
			end
		end
	)
end

--[[
	IFolder:DeleteChild (authId, path, function (returnCode))
		
		Do not implement this, implement IFolder:DeleteDirectChild instead
		Delete this filesystem node at the given path, relative to this folder
]]
function self:DeleteChild (authId, path, callback)
	callback = callback or VFS.NullCallback

	self:GetChild (authId, path,
		function (returnCode, node)
			if returnCode == VFS.ReturnCode.Success then
				node:Delete (authId, callback)
			else
				callback (returnCode)
			end
		end
	)
end

--[[
	IFolder:DeleteDirectChild (authId, name, function (returnCode))
	
		Delete the node in this folder with the given name
]]
function self:DeleteDirectChild (authId, name, callback)
	VFS.Error ("IFolder:DeleteDirectChild : Not implemented")
	
	callback = callback or VFS.NullCallback
	callback (VFS.ReturnCode.AccessDenied)
end

--[[
	IFolder:EnumerateChildren (authId, function (returnCode, INode childNode))
]]
function self:EnumerateChildren (authId, callback)
	VFS.Error ("IFolder:EnumerateChildren : Not implemented")
	
	callback (VFS.ReturnCode.Finished)
end

--[[
	IFolder:GetChild (authId, path, function (returnCode, INode childNode))
		
		Do not implement this, implement IFolder:GetDirectChild instead
]]
function self:GetChild (authId, path, callback)
	callback = callback or VFS.NullCallback
	
	local path = VFS.Path (path)
	
	if path:IsEmpty () then
		callback (VFS.ReturnCode.Success, self)
		return
	end

	self:GetDirectChild (authId, path:GetSegment (0),
		function (returnCode, node)
			path:RemoveFirstSegment ()
			if path:IsEmpty () then
				callback (returnCode, node)
			elseif returnCode == VFS.ReturnCode.Success then
				if node:IsFolder () then
					node:GetChild (authId, path, callback)
				else
					callback (VFS.ReturnCode.NotAFolder)
				end
			else
				callback (returnCode)
			end
		end
	)
end

--[[
	IFolder:GetChildSynchronous (path)
		Returns: INode child
		
		Do not implement this, implement IFolder:GetDirectChildSynchronous instead
]]
function self:GetChildSynchronous (path)
	local path = VFS.Path (path)
	
	if path:IsEmpty () then return self end

	local folder = self
	for i = 0, path:GetSegmentCount () - 1 do
		if not folder or not folder:IsFolder () then return nil end
		folder = folder:GetDirectChildSynchronous (path:GetSegment (i))
	end
	return folder
end

--[[
	IFolder:GetDirectChild (authId, name, function (returnCode, INode childNode))
]]
function self:GetDirectChild (authId, name, callback)
	VFS.Error ("IFolder:GetDirectChild : Not implemented")
	
	callback = callback or VFS.NullCallback
	callback (VFS.ReturnCode.NotFound)
end

--[[
	IFolder:GetDirectChildSynchronous (name)
	
		Returns the child with the given name, if cached.
]]
function self:GetDirectChildSynchronous (name)
	VFS.Error ("IFolder:GetDirectChildSynchronous : Not implemented")
	
	return nil
end

function self:GetName ()
	VFS.Error ("IFolder:GetName : Not implemented")
    return "[Folder]"
end

function self:GetNodeType ()
	return VFS.NodeType.Folder
end