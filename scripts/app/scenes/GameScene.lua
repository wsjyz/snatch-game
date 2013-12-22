--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-09 21:27:28
--
local GameScene = class("GameScene", function()
	return display.newScene("GameScene")
end)

function GameScene:ctor(players)
	printf("GameScene,players as follows : %s", json.json.encode(players))
	self.host = players[1]
	self.guest = playeres[2]

	self.answerCombo = 0 --连续回答正确数
	self.currentTopicIndex = 1
	--mock 
	self.topicList = {
		{

		}
	}
	self.titleLabel = nil
	self.itemLabels = {}

	local imgOffsetX, imgOffsetY = 150,150

	local hostView = app:createView("PlayerView", self.host)
	:imgPos(displa.left + imgOffsetX, display.top - imgOffsetY, true)
	:labelPos(display.LEFT_CENTER, CCPoint(display.left + imgOffsetX + 50, display.top - imgOffsetY + 20))
	:addTo(self)

	local guestView = app:createView("PlayerView", self.guest)
	:imgPos(displa.right - imgOffsetX, display.top - imgOffsetY, true)
	:labelPos(display.RIGHT_CENTER, CCPoint(displa.right - imgOffsetX - 50,display.top - imgOffsetY + 20))
	:addTo(self)

	local vsLogo = display.newSprite("#vs.png", display.cx, display.top - imgOffsetY):addTo(self)

	--content
	self.titleContainer = display.newSprite("#titlebg.png", display.cx, display.cy + 20):addTo(self)
	self.itemContainers = {}

	local itemOffsetX = 120
	for itemIndex = 1,4 do
		local x = display.cx + math.pow( -1, itemIndex) * 120
		local y = (itemIndex > 2 and  display.cy - 120) or display.cy - 160
		-- local item =  display.newSprite("#answer.png", x, y):addTo(self)
		local item = cc.ui.UIPushButton.new({
			normal = "#answer.png",
			pressed = "#answer_active.png",
			disabled = "#answer.png"
		})
		:onButtonClicked(function(e) end)
		:align(display.CENTER, x, y)
		:addTo(self)
		self.itemContainers[#self.itemContainers + 1] = item
	end

end

function GameScene:showTopic(index)
	local topic = self.topicList[index]
	--clear
	if self.titleLabel then
		self.titleLabel:removeFromParent()
		self.titleLable = nil
	end

	--setup title label
	self.titleLabel = cc.ui.UILabel.new({
		text = topic.title,
		dimensions = self.titleDimensions
		})
	:setLayoutSize(self.titleContainer:getContentSize().width - 20, self.titleContainer:getContentSize().height - 20)
	:addTo(self)
	--setup item label
	for index,item in ipairs(topic.options) do
		local container = self.itemContainers[index]
		self.itemLabels[index] = ui.newTTFLabel({
			text = item.content
		})
		:align(display.CENTER, container:getPositionX(), container:getPositionY())
		:addTo(self)
	end

end

function GameScene:answer()

end

function GameScene:checkGameCombo()

end

return GameScene