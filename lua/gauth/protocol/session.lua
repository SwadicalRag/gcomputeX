local self = {}
GAuth.Protocol.Session = GAuth.MakeConstructor (self, GAuth.Protocol.Session)

function self:ctor ()
end

function self:ShouldProcessNotification (groupTreeNode)
	local remoteId = self:GetRemoteEndPoint ():GetRemoteId ()
	local hostId = groupTreeNode:GetHost ()
	
	if hostId == GAuth.GetLocalId () then print (self:GetType () .. " from " .. remoteId .. ": Ignored") return false end
	if hostId == remoteId then print (self:GetType () .. " from " .. remoteId .. ": Accepted") return true end
	if remoteId == GAuth.GetServerId () then print (self:GetType () .. " from " .. remoteId .. ": Accepted") return true end

	print (self:GetType () .. " from " .. remoteId .. ": Ignored")
	return false
end