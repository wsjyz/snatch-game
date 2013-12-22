--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-09 21:23:44
--
local CommonBackground = import("..views.CommonBackground")
local HttpClient = import("..HttpClient")
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
	{align = display.CENTER_RIGHT , pos = CCPoint(display.cx - 55, display.cy - 80)},
	{align = display.CENTER_RIGHT , pos = CCPoint(display.cx - 205, display.cy + 100)},
	{align = display.CENTER_RIGHT , pos = CCPoint(display.cx - 205, display.cy + 200)}
}

function PlayerWaitingScene:ctor(players)
	self.players = players
	-- bg
	CommonBackground.new(false):addTo(self)
	--desk
	local desk = display.newSprite("#desk.png",display.cx,display.cy)
	self:addChild(desk)
	-- timer place holder
	self.timerPlaceHolder = display.newSprite("#countdown_ring.png",display.cx,display.cy):hide():addTo(self)
	-- animation
	self.initCountdown = display.newSprite(string.format("#timer_%d.png", 5), display.cx, display.cy):hide():addTo(self)
	local countdown = display.newSpriteFrame("#timer_%d.png",1,5,true)
	self.countdownAnimation = display.newAnimation(countdown, 1 / 5)
	--seats
	self.seats = {}

	--init seat placeholder
	for index,position in ipairs(seatPositons) do
		local x,y = position.x,position.y
		display.newSprite("#pad.png"):align(display.CENTER, x, y):addTo(self)
	end

	-- printf("players size %d , detail %s", #players , json.encode(players))
	--init player
	for index, player in ipairs(players) do
		local seatNo = ( player.seatNo or 0 ) +1
		local thumbnail = (player.male == 1 and "#male.png") or "#female.png"
		local playerName = player.playerName
		-- thumbnail
		local x,y = seatPositons[seatNo].x,seatPositons[seatNo].y
		local seat = display.newSprite(thumbnail)
		:align(display.CENTER_BOTTOM, x, y - 20)
		:addTo(self)

		seat.data = player
		self.seats[#self.seats + 1] = seat

		--user name
		ui.newTTFLabel({
			text = playerName,
			color = display.COLOR_BLACK
			})
		:align(playerNameSetting[seatNo].align, playerNameSetting[seatNo].pos.x, playerNameSetting[seatNo].pos.y)
		:addTo(self)

		self:checkGameStart()
	end

	--leizhu
	display.newSprite("#leizhu.png")
	:align(display.CENTER_RIGHT, display.cx - 60, display.cy + 230)
	:addTo(self)
	--socket event listener
	sockettcp:addEventListener("ON_OTHER_USER_COME_IN", handler(self, self.onOtherPlayerComeIn))
	sockettcp:addEventListener("ON_OTHER_USER_LEFT", handler(self, self.onOtherPlayerLeft))

end

function PlayerWaitingScene:onOtherPlayerComeIn(player)
	printf("onOtherPlayerComeIn called")
end

function PlayerWaitingScene:onOtherPlayerLeft(player)
	printf("onOtherPlayerLeft called")
end

function PlayerWaitingScene:checkGameStart()
	if #self.seats == 6 then 
		--player animation for start
		self.initCountdown:playAnimationOnce(self.countdownAnimation, false, function() 
			HttpClient.new(function(topicList) 
				printf("load topicList ,as follows : %s", json.json.encode(topicList))
				--todo save topicList on local
				app:enterGameScene()
			end ,SLS_SERVER_HOST .. "/topic/random/" .. app.currentRoomLevel)
		end)
	end
		
end


function PlayerWaitingScene:onEnter()

end

return PlayerWaitingScene