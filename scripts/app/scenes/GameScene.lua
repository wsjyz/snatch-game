--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-09 21:27:28
--
local GameScene = class("GameScene", function()
	return display.newScene("GameScene")
end)

local imgOffsetX, imgOffsetY = 150,170
local labelOffsetX, labelOffsetY = 60,50

function GameScene:ctor(players)
	printf("GameScene,players as follows : %s", json.encode(players))

	app:createView("CommonBackground", false):addTo(self)

	self.host = players[1]
	self.guest = players[2]

	self.hostAnswerCombo = 0  --擂主连续回答正确数
	self.guestAnswerCombo = 0 --挑战者连续回答正确数
	self.nextPlayerIndex = 3 --下一个挑战者的序号
	self.currentTopicIndex = 1
	self.isHostTurn = true
	--mock 
	self.topicList = {
		{
			topicId = "t1",
			title = "地球公转一周是多久？地球公转一周是多久？地球公转一周是多久？地球公转一周是多久？地球公转一周是多久？",
			level = 1,
			options = {
				{
					itemId = "i1",
					topicId = "t1",
					content = "一周",
					right = 0
				},
				{
					itemId = "i2",
					topicId = "t1",
					content = "一天",
					right = 0
				},
				{
					itemId = "i3",
					topicId = "t1",
					content = "一月",
					right = 0
				},
				{
					itemId = "i4",
					topicId = "t1",
					content = "一年",
					right = 1
				}
			}

		},
		{
			topicId = "t1",
			title = "地球自转一周是多久？地球自转一周是多久？地球自转一周是多久？地球自转一周是多久？地球自转一周是多久？",
			level = 1,
			options = {
				{
					itemId = "i1",
					topicId = "t1",
					content = "一周",
					right = 0
				},
				{
					itemId = "i2",
					topicId = "t1",
					content = "一天",
					right = 1
				},
				{
					itemId = "i3",
					topicId = "t1",
					content = "一月",
					right = 0
				},
				{
					itemId = "i4",
					topicId = "t1",
					content = "一年",
					right = 0
				}
			}

		}
	}
	self.titleLabel = nil

	self:updateHostView()
	--host countdown
	self.hostCountdown = app:createView("Countdown", 20)
	:align(display.LEFT_CENTER, display.left + imgOffsetX + labelOffsetX, display.top - imgOffsetY + 10)
	:addTo(self)

	self:updateGuestView()
	--guest countdown
	self.guestCountdown = app:createView("Countdown", 20)
	:align(display.RIGHT_CENTER, display.right - imgOffsetX - labelOffsetX, display.top - imgOffsetY + 10 )
	:hide()
	:addTo(self)


	local vsContainer = display.newSprite("#vs_container.png", display.cx, display.top - 120):addTo(self)
	local vs = display.newSprite("#vs1.png", display.cx, display.top - 150):addTo(self,2)

	local leizhu = display.newSprite("#leizhu.png")
	:align(display.LEFT_CENTER, display.left + imgOffsetX + 50, display.top - imgOffsetY + 90)
	:addTo(self)

	--content
	self.titleContainer = display.newSprite("#titlebg.png", display.cx, display.cy + 40):addTo(self)
	printf("self.titleContainer width: %d ,height : %d", self.titleContainer:getContentSize().width,self.titleContainer:getContentSize().height)
	printf("self.titleContainer position x :%d , y : %d", self.titleContainer:getPositionX(),self.titleContainer:getPositionY())
	self.itemContainers = {}

	local itemOffsetX = 200
	for itemIndex = 1,4 do
		local x = display.cx + math.pow( -1, itemIndex) * itemOffsetX
		local y = (itemIndex > 2 and  display.cy - 200) or display.cy - 100
		-- local item =  display.newSprite("#answer.png", x, y):addTo(self)
		local item = cc.ui.UIPushButton.new({
			normal = "#answer.png",
			pressed = "#answer_active.png",
			disabled = "#answer.png"
		})
		:onButtonClicked(function(e)
			--todo answer
			self:answer(e.target)
		 end)
		:align(display.CENTER, x, y)
		:addTo(self)

		item.itemIndex = itemIndex
		self.itemContainers[#self.itemContainers + 1] = item
	end

	self:showTopic(self.currentTopicIndex)
	self.hostCountdown:start()

	--socket event listener
	sockettcp:addEventListener("ON_ANSWER_COMPLETE",handler(self, self.onAnswerComplete))

end

function GameScene:updateHostView()
	if self.hostView then
		self.hostView:removeSelf()
	end
	self.hostView = app:createView("PlayerView", self.host)
	:imgPos(display.left + imgOffsetX, display.top - imgOffsetY, true)
	:labelPos(display.LEFT_CENTER, CCPoint(display.left + imgOffsetX + labelOffsetX, display.top - imgOffsetY + labelOffsetY))
	:addTo(self)
end

function GameScene:updateGuestView()
	if self.guestView then
		self.guestView:removeSelf()
	end
	self.guestView = app:createView("PlayerView", self.guest)
	:imgPos(display.right - imgOffsetX, display.top - imgOffsetY, true)
	:labelPos(display.RIGHT_CENTER, CCPoint(display.right - imgOffsetX - labelOffsetX,display.top - imgOffsetY + labelOffsetY))
	:addTo(self)
end

function GameScene:showTopic()
	if self.currentTopicIndex > table.nums(self.topicList) then
		throw("error", "no more topic")
	end
	local topic = self.topicList[self.currentTopicIndex]
	--clear
	if self.titleLabel then
		self.titleLabel:removeFromParent()
		self.titleLable = nil
	end

	--setup title label
	local marginX , marginY = 25,10
	local titleLabelX = display.cx - math.round(self.titleContainer:getContentSize().width / 2 ) + marginX
	local titleLabelY = self.titleContainer:getPositionY() + math.round(self.titleContainer:getContentSize().height / 2 ) - marginY
	self.titleLabel = ui.newTTFLabel({
		text = topic.title,
		size = 29,
		dimensions = CCSize(self.titleContainer:getContentSize().width - marginX * 2, self.titleContainer:getContentSize().height - marginY * 2)
	})
	:align(display.TOP_LEFT, titleLabelX, titleLabelY)
	:addTo(self)

	printf("titleLabel position x : %d, y : %d", self.titleLabel:getPositionX(),self.titleLabel:getPositionY())
	--setup item label
	for index,item in ipairs(topic.options) do
		local container = self.itemContainers[index]
		local itemLabel = ui.newTTFLabel({	
			text = item.content
		})
		container.rightAnswer = item.right
		container:setButtonLabel("normal", itemLabel)
	end
end

function GameScene:answer(item)
	local timeCost = 0
	if self.isHostTurn == true then
		self.hostCountdown:stop()
		timeCost = self.hostCountdown:getTimeCost()
	else
		self.guestCountdown:stop()
		timeCost = self.guestCountdown:getTimeCost()
	end
	--check can answer
	local myturn = true -- todo 
	if myturn then
		local data = {
			userId = "nexus 4",
			topicIndex = self.currentTopicIndex,
			optionIndex = item.itemIndex,
			duration = timeCost, 
			right = item.rightAnswer
		}
		printf("%s selected answer : %d ,send data : \n %s", self.host.playerName ,item.itemIndex,json.encode(data))
		--todo send msg
		sockettcp.sendMessage(ANSWER_SERVICE, data)

		self:changeTurns()
		self.currentTopicIndex = self.currentTopicIndex + 1
		self:showTopic(self.currentTopicIndex)
	end
end

function GameScene:changeTurns()
	if self.isHostTurn == true then
		self.hostCountdown:hide()
		self.guestCountdown:reset():show():start()
	else
		self.hostCountdown:reset():show():start()
		self.guestCountdown:hide()
	end
	self.isHostTurn = not self.isHostTurn
end

function GameScene:checkGameCombo()

end

function GameScene:checkGameOver()

end

--socket event listener
function GameScene:onAnswerComplete(data)

end

return GameScene