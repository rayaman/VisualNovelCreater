function gui:getParents()
	local c,me = {}, self.Parent
	while me.Parent~=nil do
		c[#c+1]=me
		me = me.Parent
	end
	return c
end
function gui:eventable()
	if self.important then
		return true
	end
	if _GuiPro.Hierarchy then
		if _GuiPro.TopHovered~=nil then
			return self:isDescendant(_GuiPro.TopHovered) or _GuiPro.TopHovered==self
		else
			return true
		end
	else
		return true
	end
end
function gui:parentVisible()
	local c = self:getParents()
	for i=#c,1,-1 do
		if not c[i].Visible then return false end
	end
	return true
end
function gui:isBeingCovering()
	return false
	-- if self.allowOverlapping then return false end
	-- local ref = self.FrameRef or gui
	-- local x,y = love.mouse.getX(),love.mouse.getY()
	-- for i = 1,#_GuiPro.Frames do
		-- if _GuiPro.Frames[i]~=ref then
			-- if (ref.depth or 0)<(_GuiPro.Frames[i].depth or math.huge) then
				-- local pos = (x > self.x and x < self.x+self.width and y > self.y and y < self.y+self.height) and (x > _GuiPro.Frames[i].x and x < _GuiPro.Frames[i].x+_GuiPro.Frames[i].width and y > _GuiPro.Frames[i].y and y < _GuiPro.Frames[i].y+_GuiPro.Frames[i].height) and (x > self.x and x < self.x+self.width and y > self.y and y < self.y+self.height )
				-- if not pos then return true end
			-- end
		-- end
	-- end
end
function gui:Clickable()
	local x,y,w,h=love.graphics.getScissor()
	local mx=love.mouse.getX()
	local my=love.mouse.getY()
	if _GuiPro.HasStencel then
		local obj=_GuiPro.StencelHolder
		if self:isDescendant(obj) then
			return math.sqrt((mx-obj.x)^2+(my-obj.y)^2)<=(obj.offset.size.x or 0)
		end
	end
	if not(x) then
		return true
	end
	if self.isclipped then
		return not(mx>x+w or mx<x or my>y+h or my<y)
	end
	return true
end
function gui:canPress()
	local ref = self
	if self.ClipReference then ref = self.ClipReference end
	if self.Active and self.Visible==true and self:parentVisible() and not(self:isBeingCovering()) then
		local x,y = love.mouse.getX(),love.mouse.getY()
		if (x > ref.x and x < ref.x+ref.width and y > ref.y and y < ref.y+ref.height) and (x > self.x and x < self.x+self.width and y > self.y and y < self.y+self.height and self:Clickable() and (self:eventable() or self:touchable())) then
			return true
		else
			return false
		end
	else
		return false
	end
end