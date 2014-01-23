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
	:align(display.CENTER, x, y + 75)
	:addTo(self)

	if room.bgHref then
		app:loadImageAsync(room.bgHref, function(event, texture) 
			local awardBg = CCSpriteExtend.extend(CCSprite:createWithTexture(texture))
			awardBg:pos(x, y - 18)
			:scale(0.7)
			:addTo(self)
		end)	
	end
end

function RoomView:getBoundingBox()
	return self.roomBg:getBoundingBox()
end

return RoomView