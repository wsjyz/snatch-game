--
-- Author: ivan.vigoss@gmail.com
-- Date: 2014-01-02 18:52:45
--
local ChallengeOver = class("ChallengeOver", function()
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
	return node
end)

function ChallengeOver:ctor(winner,loser)
	self.modalLayer = app:createView("CommonModalView")

	local bgOffsetX,bgOffsetY = self.modalLayer:getOffsetPoint().x, self.modalLayer:getOffsetPoint().y
	echoInfo("bgOffsetX %d,bgOffsetY %d", bgOffsetX,bgOffsetY)

	local over = display.newSprite("#gameover.png")
	:align(display.TOP_CENTER, display.cx, display.cy + bgOffsetY - 65)
	self.modalLayer:addContentChild(over)

	local offsetX = 170

	local winnerView = self:newPlayerSprite(winner.male)
	local winnerProgress = app:createView("ProgressBar", 50, "150/300",display.cx - offsetX, display.cy - bgOffsetY + 70)
	local winnerTitle = ui.newTTFLabel({
			text = winner.currentTitle,
			color = ccc3(255, 245, 110)
		})
	local winnerName = ui.newTTFLabel({
			text = winner.nickName,
			color = ccc3(59, 17, 17)
		})

	self.modalLayer:addContentChild(winnerView, display.cx - offsetX, display.cy + 30)
	self.modalLayer:addContentChild(winnerProgress)
	local winnerLabelX = display.cx - bgOffsetX + 50
	self.modalLayer:addContentChild(winnerTitle, winnerLabelX , display.cy - bgOffsetY + 100, display.CENTER_LEFT)
	winnerLabelX = winnerLabelX + winnerTitle:getContentSize().width
	self.modalLayer:addContentChild(winnerName,winnerLabelX , display.cy - bgOffsetY + 100, display.CENTER_LEFT)

	local loserView = self:newPlayerSprite(loser.male)
	local loserProgress = app:createView("ProgressBar", 20,"60/300",display.cx + offsetX, display.cy - bgOffsetY + 70)

	self.modalLayer:addContentChild(loserView, display.cx + offsetX, display.cy + 30)
	self.modalLayer:addContentChild(loserProgress)
	local loserTitle = ui.newTTFLabel({
			text = loser.currentTitle,
			color = ccc3(255, 245, 110)
		})
	local loserName = ui.newTTFLabel({
			text = loser.nickName,
			color = ccc3(59, 17, 17)
		})

	local loserLabelX = display.cx + 100
	self.modalLayer:addContentChild(loserTitle, loserLabelX , display.cy - bgOffsetY + 100, display.CENTER_LEFT)
	loserLabelX = loserLabelX + loserTitle:getContentSize().width
	self.modalLayer:addContentChild(loserName,loserLabelX , display.cy - bgOffsetY + 100, display.CENTER_LEFT)

	--win
	local winLogo = display.newSprite("#win.png")
	self.modalLayer:addContentChild(winLogo, winnerView:getPositionX(), winnerView:getPositionY(), display.LEFT_CENTER)

	self:addChild(self.modalLayer:getView())
end

function ChallengeOver:newPlayerSprite(male)
	local img = (male == 1 and "#boy.png") or "#girl.png"
	return display.newSprite(img):scale(0.6)
end


function ChallengeOver:onClose()
	self:dispatchEvent({name = "onClose"})
end

return ChallengeOver