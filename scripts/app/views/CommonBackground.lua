--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-01 13:29:01
--
local CommonBackground = class("CommonBackground", function()
	return display.newLayer()
end)

BACKGROUND_TAG = 1
NODE_ZORDER = 0

function CommonBackground:ctor(showLogo)
	local bg = display.newSprite("#bg.png", display.cx, display.cy):addTo(self, NODE_ZORDER, BACKGROUND_TAG)	
	local show_ = true
	if showLogo ~= nil and showLogo == false then 
		show_ = false
	end
	if show_ then
		display.newSprite("#logo.png", display.cx, display.cy + 200)
		:addTo(self)
	end
end

return CommonBackground