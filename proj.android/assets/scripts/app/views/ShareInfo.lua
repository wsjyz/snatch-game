--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-29 10:33:32
--
local ShareInfo = class("ShareInfo", function()
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
	return node
end)

function ShareInfo:ctor(award)
	self.modalLayer = app:createView("CommonModalView", false,"#floatbg_gold.png")

	local bgOffsetX,bgOffsetY = self.modalLayer:getOffsetPoint().x,self.modalLayer:getOffsetPoint().y

	local title = ui.newTTFLabel({
		text = "诏曰",
		color = ccc3(187,67,23)
	})

	local content = ui.newTTFLabel({
		text = "卿才高八斗，特赐" .. award.awardName,
		color = ccc3(187,67,23)
	})

	local tail = ui.newTTFLabel({
		text = "钦此",
		color = ccc3(187,67,23)
	})

	local shareBtn = cc.ui.UIPushButton.new({
		normal = "#sharetbn.png",
		pressed = "#sharetbn_active.png",
		disabled = "#sharetbn.png"
	})
	:onButtonClicked(function(e)
		self.modalLayer:close()
		self:dispatchEvent({name = "onShare",award = award})
	end)

	--add to modalLayer
	self.modalLayer:addContentChild(title, display.cx - bgOffsetX + 100, display.cy + 60, display.LEFT_CENTER)
	self.modalLayer:addContentChild(content, display.cx - bgOffsetX + 100, display.cy + 10, display.LEFT_CENTER)
	self.modalLayer:addContentChild(tail, display.cx + bgOffsetX - 100, display.cy - 50, display.RIGHT_CENTER)

	self.modalLayer:addContentChild(shareBtn, display.cx, display.cy - 100)

	self:addChild(self.modalLayer:getView())
	
end

return ShareInfo