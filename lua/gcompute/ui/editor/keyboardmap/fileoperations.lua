GCompute.Editor.EditorKeyboardMap:Register ({ KEY_N, KEY_T },
	function (self, key, ctrl, shift, alt)
		if not ctrl then return end
		self:CreateEmptyCodeTab ():Select ()
	end
)

GCompute.Editor.EditorKeyboardMap:Register (KEY_O,
	function (self, key, ctrl, shift, alt)
		if not ctrl then return end
		self.Toolbar:GetItemById ("Open"):DispatchEvent ("Click")
	end
)

GCompute.Editor.EditorKeyboardMap:Register (KEY_S,
	function (self, key, ctrl, shift, alt)
		if not ctrl then return end
		self:SaveTab (self:GetSelectedTab ())
	end
)

GCompute.Editor.EditorKeyboardMap:Register (KEY_W,
	function (self, key, ctrl, shift, alt)
		if not ctrl then return end
		self:CloseTab (self:GetSelectedTab ())
	end
)