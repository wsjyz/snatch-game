--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-27 13:40:36
--
local Winner = class("Winner", function()
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
	return node
end)

function Winner:ctor(winner)
	self.modalLayer = app:createView("CommonModalView",false)
	local modalOffsetX = self.modalLayer:getOffsetPoint().x
	--恭喜
	local gongxiLabel = ui.newTTFLabel({
			text = "恭喜"
		})
	self.modalLayer:addContentChild(gongxiLabel, display.cx - modalOffsetX + 50, display.cy, display.LEFT_CENTER)

	--winner placeholder
	local winnerView = app:createView("PlayerView", winner)
		:imgPos(display.cx - modalOffsetX + 100, display.cy, false)
		:labelPos(display.CENTER, CCPoint(display.cx - modalOffsetX + 100, display.cy - 100))
		:labelColor(ccc3(255, 244, 110))
	self.modalLayer:addContentChild(winnerView, display.cx - modalOffsetX + 100, display.cy)

	-- other text
	local otherLabel =ui.newTTFLabel({
			text = "成为擂主"
		})
	self.modalLayer:addContentChild(otherLabel, display.cx + modalOffsetX - 50, display.cy, display.RIGHT_CENTER)

	self:addChild(self.modalLayer:getView())
	self.modalLayer:addEventListener("onBackgroudTap", handler(self,self.onClose))
end

function Winner:onClose()
	self.modalLayer:close()
	self:dispatchEvent({name = "onClose"})
end

return Winner