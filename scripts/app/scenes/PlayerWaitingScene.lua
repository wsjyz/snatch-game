--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-09 21:23:44
--
local CommonBackground = import("..views.CommonBackground")
local HttpClient = import("..HttpClient")
local GameScene = import(".GameScene")

local PlayerWaitingScene = class("PlayerWaitingScene", function()
	return display.newScene("PlayerWaitingScene")
end)

local seatPositons = {
	CCPoint(display.cx, display.cy + 160),
	CCPoint(display.cx + 150, display.cy + 90),
	CCPoint(display.cx + 150, display.cy - 90),
	CCPoint(display.cx, display.cy - 200),
	CCPoint(display.cx - 150, display.cy - 90),
	CCPoint(display.cx - 150, display.cy + 90)
}

local playerNameSetting = {
	{align = display.CENTER_LEFT , pos = CCPoint(display.cx + 55, display.cy + 200)},
	{align = display.CENTER_LEFT , pos = CCPoint(display.cx + 205, display.cy + 100)},
	{align = display.CENTER_LEFT , pos = CCPoint(display.cx + 205, display.cy - 80)},
	{align = display.CENTER_RIGHT , pos = CCPoint(display.cx - 55, display.cy - 220)},
	{align = display.CENTER_RIGHT , pos = CCPoint(display.cx - 205, display.cy - 80)},
	{align = display.CENTER_RIGHT , pos = CCPoint(display.cx - 205, display.cy + 100)}
}

function PlayerWaitingScene:ctor(players)
	self.players = players
	-- bg
	CommonBackground.new(false):addTo(self)
	--desk
	local desk = display.newSprite("#desk.png",display.cx,display.cy)
	self:addChild(desk)
	-- timer place holder
	self.timerPlaceHolder = display.newSprite("#countdown_ring.png",display.cx,display.cy):hide():addTo(self,1)
	-- animation
	self.initCountdown = display.newSprite(string.format("#timer_%d.png", 5), display.cx, display.cy):hide():addTo(self,1)
	local countdownFrames = display.newFrames("timer_%0d.png",1,5,true)
	self.countdownAnimation = display.newAnimation(countdownFrames, 1.0)
	--seats
	self.seats = {}

	--init seat placeholder
	for index,position in ipairs(seatPositons) do
		local x,y = position.x,position.y
		display.newSprite("#pad.png"):align(display.CENTER, x, y):addTo(self)
	end



	--leizhu
	display.newSprite("#leizhu.png")
	:align(display.CENTER_RIGHT, display.cx - 60, display.cy + 230)
	:addTo(self)
	--socket event listener
	sockettcp:addEventListener("ON_OTHER_USER_COME_IN", handler(self, self.onOtherPlayerComeIn))
	sockettcp:addEventListener("ON_OTHER_USER_LEFT", handler(self, self.onOtherPlayerLeft))

		--init player
	for index, player in ipairs(players) do
		local canStart = self:onOtherPlayerComeIn(player)
		if canStart then break end
	end
end

function PlayerWaitingScene:onOtherPlayerComeIn(player)
	if not self.roomId then
		self.roomId = player.roomId
	end

	local seatNo = ( player.seatNo or 0 ) + 1
	local x,y = seatPositons[seatNo].x,seatPositons[seatNo].y
	
	local seat = app:createView("PlayerView", player)
	:imgPos(x, y - 20)
	:labelPos(playerNameSetting[seatNo].align, playerNameSetting[seatNo].pos)
	:addTo(self)

	self.seats["seat_" .. seatNo] = seat

	return self:checkGameStart()
	
end

function PlayerWaitingScene:onOtherPlayerLeft(player)
	printf("onOtherPlayerLeft called")
	local seatNo = ( player.seatNo or 0 ) + 1
	local seat = self.seats["seat_" .. seatNo]
	if seat then
		seat.removeFromParent()
		self.seats["seat_" .. seatNo] = nil
	end

end

function PlayerWaitingScene:checkGameStart()
	if table.nums(self.seats) == 6 then
		self.timerPlaceHolder:show() 
		self.initCountdown:show()
		--player animation for start
		self.initCountdown:playAnimationOnce(self.countdownAnimation, false, function() 
			HttpClient.new(function(topicList) 
				printf("load topicList ,as follows : %s", json.encode(topicList))
				--todo save topicList on local
				display.replaceScene(GameScene.new(self.players))
			end ,SLS_SERVER_HOST .. "/topic/random/" .. app.currentRoomLevel):start()
		end)
		return true
	end

	return false
end

return PlayerWaitingScene