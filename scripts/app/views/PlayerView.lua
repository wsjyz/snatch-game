--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-22 13:43:24
--
local PlayerView = class("PlayerView", function()
	return display.newNode()
end)

function PlayerView:ctor(player)
	assert(type(player) == "table" ,"player must be table")
	
	local seatNo = ( player.seatNo or 0 ) +1
	local thumbnail = (player.male == 1 and "#male.png") or "#female.png"
	local nickName = player.nickName

	self.thumbnail = display.newSprite(thumbnail):addTo(self,1)

	self.label = ui.newTTFLabel({
			text = nickName,
			color = ccc3(59, 17, 17)
			})
	:addTo(self,1)
end

function PlayerView:imgPos(x, y,withHolder)
	self.thumbnail:align(display.CENTER_BOTTOM, x, y)
	if withHolder then
		display.newSprite("#pad.png"):align(display.CENTER, x, y + 20):addTo(self)
	end
	return self
end

function PlayerView:labelPos(align, pos)
	self.label:align(align, pos.x, pos.y)
	return self
end

function PlayerView:labelColor(color)
	self.label:setColor(color)
	return self
end

return PlayerView