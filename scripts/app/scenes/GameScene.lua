--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-09 21:27:28
--
local GameScene = class("GameScene", function()
	return display.newScene("GameScene")
end)
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local imgOffsetX, imgOffsetY = 150,170
local labelOffsetX, labelOffsetY = 60,50

function GameScene:ctor(players)
	printf("GameScene,players as follows : %s", json.encode(players))

	app:createView("CommonBackground", false):addTo(self)
	self.players = players

	self.nextPlayerIndex = 3 --下一个挑战者的序号
	self.currentTopicIndex = 1 --下一题的序号
	self.isHostTurn = true 
	self.answerMarks = {} --答案标记
	self.score = 0 --本场自己的积分
	
	self.titleLabel = nil

	self:setHost(players[1])
	--host countdown
	self.hostCountdown = app:createView("Countdown", 20)
	:align(display.LEFT_CENTER, display.left + imgOffsetX + labelOffsetX, display.top - imgOffsetY + 10)
	:addTo(self)
	self.hostCountdown:addEventListener("onTimeBurndown", handler(self, self.onTimeBurndown))

	self:setGuest(players[2])
	--guest countdown
	self.guestCountdown = app:createView("Countdown", 20)
	:align(display.RIGHT_CENTER, display.right - imgOffsetX - labelOffsetX, display.top - imgOffsetY + 10 )
	:hide()
	:addTo(self)
	self.guestCountdown:addEventListener("onTimeBurndown", handler(self, self.onTimeBurndown))

	local vsContainer = display.newSprite("#vs_container.png", display.cx, display.top - 120):addTo(self)
	local vs = display.newSprite("#vs1.png", display.cx, display.top - 150):addTo(self)

	local leizhu = display.newSprite("#leizhu.png")
	:align(display.LEFT_CENTER, display.left + imgOffsetX + 50, display.top - imgOffsetY + 90)
	:addTo(self)

	--content
	self.titleContainer = display.newSprite("#titlebg.png", display.cx, display.cy + 40):addTo(self)
	-- printf("self.titleContainer width: %d ,height : %d", self.titleContainer:getContentSize().width,self.titleContainer:getContentSize().height)
	-- printf("self.titleContainer position x :%d , y : %d", self.titleContainer:getPositionX(),self.titleContainer:getPositionY())
	self.itemContainers = {}

	local itemOffsetX = 200
	for itemIndex = 1,4 do
		local x = display.cx + math.pow( -1, itemIndex) * itemOffsetX
		local y = (itemIndex > 2 and  display.cy - 200) or display.cy - 100
		-- local item =  display.newSprite("#answer.png", x, y):addTo(self)
		local item = cc.ui.UICheckBoxButton.new({
			off = "#answer.png",
			on = "#answer_active.png"
		})
		:onButtonClicked(function(e)
			self:answer(e.target)
		 end)
		:align(display.CENTER, x, y)
		:addTo(self)

		item.itemIndex = itemIndex
		self.itemContainers[itemIndex] = item
	end

	self:showTopic(self.currentTopicIndex)
	self.hostCountdown:start()

	--socket event listener
	sockettcp:addEventListener("ON_ANSWER_COMPLETE",handler(self, self.onAnswerComplete))

end

function GameScene:setHost(host)
	self.host = host
	if self.hostView then
		self.hostView:removeSelf()
	end
	self.hostView = app:createView("PlayerView", self.host)
	:imgPos(display.left + imgOffsetX, display.top - imgOffsetY, true)
	:labelPos(display.LEFT_CENTER, CCPoint(display.left + imgOffsetX + labelOffsetX, display.top - imgOffsetY + labelOffsetY))
	:addTo(self)
end

function GameScene:setGuest(guest)
	self.guest = guest
	if self.guestView then
		self.guestView:removeSelf()
	end
	self.guestView = app:createView("PlayerView", self.guest)
	:imgPos(display.right - imgOffsetX, display.top - imgOffsetY, true)
	:labelPos(display.RIGHT_CENTER, CCPoint(display.right - imgOffsetX - labelOffsetX,display.top - imgOffsetY + labelOffsetY))
	:addTo(self)
end

function GameScene:resetView()
	--clear
	self.rightAnswerIndex = -1
	if self.titleLabel then
		self.titleLabel:removeFromParent()
		self.titleLable = nil
	end
	--clear
	if self.answerMarks then
		for _,answerMark in ipairs(self.answerMarks) do
			answerMark:removeSelf(true)
		end
		self.answerMarks = {}
	end

	self:setItemSelected(false)
end

function GameScene:showTopic()
	if self.currentTopicIndex > table.nums(app.topicList) then
		throw("error", "no more topic")
	end
	local topic = app.topicList[self.currentTopicIndex]
	
	self:resetView()

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

	--setup item label and answer mark
	for _,item in ipairs(topic.options) do
		local index = item.index
		local container = self.itemContainers[index]
		local itemLabel = ui.newTTFLabel({	
			text = item.content
		})
		container.rightAnswer = item.right
		container:setButtonLabel("off", itemLabel)
		container:setButtonLabelAlignment(display.LEFT_CENTER)
		container:setButtonLabelOffset(-140, 0)
		container:setButtonEnabled(self:isMyTurn_())

		if item.right == 1 then self.rightAnswerIndex = index end

		local answerMarkImg = (item.right == 1 and "#correct.png") or "#error.png"
		local markX,markY = container:getPositionX() - 140,container:getPositionY() + 6
		--printf("answerMark position x : %d, y : %d", markX,markY)
		local answerMark = display.newSprite(answerMarkImg, markX, markY)
		:hide()
		:addTo(self)
		self.answerMarks[index] = answerMark
	end
end

function GameScene:isMyTurn_()
	local currentPlayer = (self.isHostTurn and self.host) or self.guest
	return currentPlayer.playerId == app.me.playerId
end

function GameScene:setItemEnabled(enabled)
	if self.itemContainers then
		printf("set item Enabled %s", enabled)
		for _,item in ipairs(self.itemContainers) do
			item:setButtonEnabled(enabled)
		end
	end
end

function GameScene:setItemSelected(selected)
	if self.itemContainers then
		for _,item in ipairs(self.itemContainers) do
			item:setButtonSelected(selected)
		end
	end
end

function GameScene:answer(item)
	--check can answer
	if self:isMyTurn_() then
		local timeCost = 0
		if self.isHostTurn == true then
			self.hostCountdown:pause()
			timeCost = self.hostCountdown:getTimeCost()
		else
			self.guestCountdown:pause()
			timeCost = self.guestCountdown:getTimeCost()
		end
		--forbiden all items , avoid twice commit
		self:setItemEnabled(false)	
		--update ui,mark selected answer and right answer
		self:markAnswer(item)

		local data = {
			playerId = app.me.playerId,
			roomId = app.currentRoomId,
			optionIndex = item.itemIndex
		}
		printf("%s selected answer : %d ,send data : \n %s", self.host.nickName, item.itemIndex, json.encode(data))
		
		--add score
		self.score = self.score + item.rightAnswer

		sockettcp:sendMessage(ANSWER_SERVICE,data)
	end
end

function GameScene:markAnswer(item)
	self.answerMarks[item.itemIndex]:show()
	item:setButtonSelected(true)
	if item.rightAnswer == 0 then
		self.answerMarks[self.rightAnswerIndex]:show()
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

--event listener
function GameScene:onAnswerComplete(event)
	local data = event.data
	printf("onAnswerComplete received data %s", json.encode(data))
	local selectedItem = self.itemContainers[data.optionIndex]
	if not self:isMyTurn_() then -- avoid duplicate render
		if self.isHostTurn == true then
			self.hostCountdown:pause()
		else
			self.guestCountdown:pause()
		end
		self:markAnswer(selectedItem)
	end

	local gameOver = function() 
		--no more players ,game over
		local winner = (self.isHostTurn and self.guest) or self.host
		local winnerView = app:createView("Winner", winner):addTo(self)
		winnerView:addEventListener("onClose", function() 
			local winnerIsMe = winner.playerId == app.me.playerId
			if winnerIsMe then
				local lottery = app:createView("Lottery"):addTo(self) -- 抽奖
				lottery:addEventListener("onSuccess",function()
					--抽奖成功
					local treasure = app:createView("Treasure"):addTo(self)
					treasure:addEventListener("onClose",function()
						-- todo
						local shareInfo = app:createView("ShareInfo", app.currentAward):addTo(self)
						shareInfo:addEventListener("onShare", function(e)
							app:createView("SharePanel")
						end)
					end)
				end)
				lottery:addEventListener("onFailed", function()
					--抽奖失败
					local lotteryFaild = app:createView("LotteryFailed"):addTo(self)
					lotteryFaild:addEventListener("onClose",function(e)
						app:enterChooseAward(app.currentLevel)		 
					end)
				end)
			else
				app:enterChooseAward(app.currentLevel)
			end
		end)
	end
		
	--delay for next topic
	scheduler.performWithDelayGlobal(function() 
		if selectedItem.rightAnswer == 0 then -- wrong
			--ChallengeOver view

			if self.nextPlayerIndex <= table.nums(self.players) then
				if self.isHostTurn then 
					self:setHost(self.players[self.nextPlayerIndex]) 
				else
					self:setGuest(self.players[self.nextPlayerIndex])
				end
				self.nextPlayerIndex = self.nextPlayerIndex + 1
			else
				gameOver()
			end
		end
		--next topic
		self.currentTopicIndex = self.currentTopicIndex + 1
		self:changeTurns()
		self:showTopic()
	end,3)
end

function GameScene:onTimeBurndown()
	local item = self.itemContainers[math.random(1,4)]
	self:answer(item)
end


function GameScene:onExit()
	if self.score > 0 then
		--todo submit my score to server.
	end
end

return GameScene