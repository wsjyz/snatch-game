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
	echoInfo("init PlayerWaitingScene with players %s", json.encode(players))
	self.players = {}
	-- bg
	CommonBackground.new(false):addTo(self)
	--desk
	local desk = display.newSprite("#desk.png",display.cx,display.cy)
	self:addChild(desk)
	-- timer place holder
	self.timerPlaceHolder = display.newSprite("#countdown_ring.png",display.cx,display.cy):hide():addTo(self,1)
	-- animation
	self.initCountdown = display.newSprite(string.format("#timer_%d.png", 5), display.cx, display.cy):hide():addTo(self,1)
	
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
	
	self.settingMenu = app:createView("SettingMenu"):addTo(self)
	self.settingMenu:addEventListener("goBack", handler(self, self.leftRoom))
	--init player
	self:refreshUIWithPlayers(players)

end

function PlayerWaitingScene:getCountdownAnimation()
	local animation = display.getAnimationCache("countdown")
	if not animation then
		local countdownFrames = display.newFrames("timer_%0d.png",1,5,true)
		animation = display.newAnimation(countdownFrames, 1.0)
		display.setAnimationCache("countdown", animation)
	end

	return animation
end

function PlayerWaitingScene:leftRoom()
	local data = clone(app.me)
	data.roomId = app.currentRoomId
	data.seatNo = self.mySeat

	printf("user left room ,send data %s", json.encode(data))
	sockettcp:sendMessage(LEFT_ROOM_SERVICE, data)
	app:enterChooseAward(app.currentLevel)
end

function PlayerWaitingScene:onOtherPlayerComeIn(event)
	local player = event.data
	echoInfo("onOtherPlayerComeIn called ,receive data : %s", json.encode(player))
	self:createSeat(player)
end

function PlayerWaitingScene:createSeat(player)
	echoInfo("create seat %s", json.encode(player))
	local seatNo = ( player.seatNo or 0 ) + 1
	local x,y = seatPositons[seatNo].x,seatPositons[seatNo].y
	local seat = app:createView("PlayerView", player):addTo(self)
	seat:imgPos(x, y - 20)
	seat:labelPos(playerNameSetting[seatNo].align, playerNameSetting[seatNo].pos)
	self.seats[seatNo] = seat
	self.players[seatNo] = player
	return seat
end

function PlayerWaitingScene:clearSeat()
	for seatNo,seat in pairs(self.seats) do
		if seat then 
			seat:removeSelf(true) 
		end
	end
	self.seats = {}
	self.players = {}
end

function PlayerWaitingScene:refreshUIWithPlayers(players)
	if type(players) ~= "table" then return end
	self:clearSeat()

	for _,player in pairs(players) do
		if app.me.playerId == player.playerId then self.mySeat = player.seatNo end
		self:createSeat(player)
	end
	echoInfo("after refresh,players :%s,myseat %d", json.encode(self.players),self.mySeat)
end


function PlayerWaitingScene:onOtherPlayerLeft(event)
	local players = event.data
	printf("onOtherPlayerLeft called,received data : %s",json.encode(players))
	self:refreshUIWithPlayers(players)
end

function PlayerWaitingScene:onGameStart()
	echoInfo("onGameStart called , game will be started soon.")
	self.timerPlaceHolder:show() 
	self.initCountdown:show()
	self.settingMenu:hide()
	--player animation for start
	local animation = self:getCountdownAnimation()
	self.initCountdown:playAnimationOnce(animation, false, function() 
			display.replaceScene(GameScene.new(self.players))
	end)
end

function PlayerWaitingScene:onEnter()
	--socket event listener
	sockettcp:addEventListener("ON_OTHER_USER_COME_IN", handler(self, self.onOtherPlayerComeIn))
	sockettcp:addEventListener("ON_OTHER_USER_LEFT", handler(self, self.onOtherPlayerLeft))
	sockettcp:addEventListener("ON_GAME_START", handler(self,self.onGameStart))

	app:loadTopicList(function()
		local data = {
			roomId = app.currentRoomId,
			playerId = app.me.playerId
		}
		echoInfo("I'am ready! send message, %s", json.encode(data))
		sockettcp:sendMessage(ON_READY_SERVICE, data)			
	end)	
	

end

function PlayerWaitingScene:onExit()
	sockettcp:removeAllEventListenersForEvent("ON_OTHER_USER_COME_IN")
	sockettcp:removeAllEventListenersForEvent("ON_OTHER_USER_LEFT")
	sockettcp:removeAllEventListenersForEvent("ON_GAME_START")
end

return PlayerWaitingScene