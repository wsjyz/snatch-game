--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-09 21:23:44
--
local PlayerWaitingScene = class("PlayerWaitingScene", function()
	return display.newScene("PlayerWaitingScene")
end)


function PlayerWaitingScene:ctor()
	-- bg
	import("..views.CommonBackground").new():addTo(self)
	--desk
	local desk = display.newSprite("#desk"):center():addTo(self)

	--seats
	

end


return PlayerWaitingScene