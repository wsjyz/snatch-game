--
-- 抽奖
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-27 17:08:31
--
local HttpClient = import("..HttpClient")
local Lottery = class("Lottery", function()
	return display.newNode()
end)

function Lottery:ctor()
	self.modalLayer = app:createView("CommonModalView", false)

	--add content


	self:addChild(self.modalLayer:getView())
end

function Lottery:onChestClick()
	HttpClient.new(function(result)
		self.modalLayer:close()
		printf("lottery result %s", result)
		if result then
			self:onSuccess()
		else
			self:onFailed()
		end
	 end, getUrl(LOTTERY_URL, app.currentRoomId,app.me.playerId))
end

function Lottery:onSuccess()

end

function Lottery:onFailed()
end

return Lottery