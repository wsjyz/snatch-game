--
-- Author: Alex
-- Date: 2013-12-14 23:45:37
--
local AwardView = class("AwardView", function()
	return display.newLayer()
end)

function AwardView:ctor()
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()	
end

return AwardView