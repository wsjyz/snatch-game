--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-18 16:02:24
--
local RoomView = class("RoomView", function()
	return display.newNode()
end)

function RoomView:ctor(room,x,y)
	local x = x or display.cx
	local y = y or display.cy
	self.roomBg = display.newSprite("#house.png")
	:align(display.CENTER, x, y)
	:addTo(self)

	ui.newTTFLabel({
		text = room.awardName or "ROOM"
		})
	:align(display.CENTER, x, y + 72)
	:addTo(self)

end

function RoomView:getBoundingBox()
	return self.roomBg:getBoundingBox()
end

return RoomView