--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-22 13:43:24
--
local PlayerView = class("PlayerView", function()
	return display.newNode()
end)

function PlayerView:ctor(player)
	local seatNo = ( player.seatNo or 0 ) +1
	local thumbnail = (player.male == 1 and "#male.png") or "#female.png"
	local playerName = player.playerName

	self.thumbnail = display.newSprite(thumbnail):addTo(self)

	self.label = ui.newTTFLabel({
			text = playerName,
			color = display.COLOR_BLACK
			})
	:addTo(self)

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

return PlayerView