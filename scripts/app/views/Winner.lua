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
	local startX = display.cx - modalOffsetX + 100
	--恭喜
	local gongxiLabel = ui.newTTFLabel({
			text = "恭喜"
		})
	self.modalLayer:addContentChild(gongxiLabel, startX, display.cy, display.LEFT_CENTER)

	startX = startX + gongxiLabel:getContentSize().width
	local winnerLabel = ui.newTTFLabel({
			text = winner.nickName,
			color = ccc3(255, 244, 110)
		})
	self.modalLayer:addContentChild(winnerLabel, startX, display.cy, display.LEFT_CENTER)
	
	startX = startX + gongxiLabel:winnerLabel().width
	-- other text
	local otherLabel =ui.newTTFLabel({
		text = "成为擂主"
	})
	self.modalLayer:addContentChild(otherLabel, startX, display.cy, display.LEFT_CENTER)

	self:addChild(self.modalLayer:getView())
	self.modalLayer:addEventListener("onBackgroudTap", handler(self,self.onClose))
end

function Winner:onClose()
	self.modalLayer:close()
	self:dispatchEvent({name = "onClose"})
end

return Winner