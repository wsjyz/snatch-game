--
-- 抽奖
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-27 17:08:31
--
local HttpClient = import("..HttpClient")
local Lottery = class("Lottery", function()
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
	return node
end)

function Lottery:ctor()
	self.modalLayer = app:createView("CommonModalView", false)

	--add content
	local chest1 = display.newSprite("#chest1.png")
	local chest_green = display.newSprite("#chest_green.png")
	local chest_red = display.newSprite("#chest_red")

	self.modalLayer:addContentChild(chest1, display.cx - 150, display.cy)
	self.modalLayer:addContentChild(chest_green, display.cx, display.cy)
	self.modalLayer:addContentChild(chest_red, display.cx, display.cy)

	self:addChild(self.modalLayer:getView())
end

function Lottery:onChestClick()
	HttpClient.new(function(result)
		self.modalLayer:close()
		printf("lottery result %s", result)
		if result then
			self:dispatchEvent({name = "onSuccess"})
		else
			self:dispatchEvent({name = "onFailed"})
		end
	 end, getUrl(LOTTERY_URL, app.currentRoomId,app.me.playerId))
end

return Lottery