--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-29 11:44:21
--
local LotteryFailed = class("LotteryFailed", function()
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
	return node
end)

function LotteryFailed:ctor()
	self.modalLayer = app:createView("CommonModalView", false,"#floatbg_gold.png")

	local bgOffsetX,bgOffsetY = self.modalLayer:getOffsetPoint().x,self.modalLayer:getOffsetPoint().y

	local title = ui.newTTFLabel({
		text = "诏曰",
		color = ccc3(187,67,23)
	})

	local content = ui.newTTFLabel({
		text = "卿天赋异禀，但资历尚浅，需再接再厉",
		color = ccc3(187,67,23)
	})

	local tail = ui.newTTFLabel({
		text = "钦此",
		color = ccc3(187,67,23)
	})

	--add to modalLayer
	self.modalLayer:addContentChild(title, display.cx - bgOffsetX + 30, display.cy + bgOffsetY, display.LEFT_CENTER)
	self.modalLayer:addContentChild(content, display.cx - bgOffsetX + 30, display.cy + 10, display.LEFT_CENTER)
	self.modalLayer:addContentChild(tail, display.cx + bgOffsetX - 30, display.cy - 10, display.RIGHT_CENTER)
	self.modalLayer:addEventListener("onBackgroudTap", handler(self, self.onClose))

	self:addChild(self.modalLayer:getView())
end

function LotteryFailed:onClose()
	self.modalLayer:close()
	self:dispatchEvent({name = "onClose"})
end

return LotteryFailed