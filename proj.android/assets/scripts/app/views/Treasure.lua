--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-29 10:26:22
--
local Treasure = class("Treasure", function()
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
	return node
end)

function Treasure:ctor()
	self.modalLayer = app:createView("CommonModalView",false)

	local treasure = display.newSprite("#chest.png")
	self.modalLayer:addContentChild(treasure,display.cx,display.cy)

	self.modalLayer:addEventListener("onBackgroudTap", handler(self, self.onClose))

	self:addChild(self.modalLayer:getView())

end

function Treasure:onClose()
	self:dispatchEvent({name = "onClose"})
	self:removeSelf(true)
end

return Treasure