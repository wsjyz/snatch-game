--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-11 18:23:43
--
local HttpClient = import("..HttpClient")
local AlertView = import("..views.AlertView")
local RoomList = import("..views.RoomList")
local CommonModalView = import("..views.CommonModalView")
local RoomView = import("..views.RoomView")
local PlayerWaitingScene = import(".PlayerWaitingScene")

local RoomListScene = class("RoomListScene", function ()
	return display.newScene("RoomListScene")
end)

function RoomListScene:ctor(level)
	app:createView("CommonBackground", false):addTo(self)
	local settingMenu = app:createView("SettingMenu"):addTo(self)
	settingMenu:addEventListener("goBack", function() 
		app:enterChooseLevel()
	end)
	settingMenu:addEventListener("onPopup", function() 
		self.roomlistView:setTouchEnabled(false)
	end)
	settingMenu:addEventListener("onPopupClose", function() 
		self.roomlistView:setTouchEnabled(true)
	end)
		
	--quick start
	cc.ui.UIPushButton.new({
		normal = "#startbtn.png",
		pressed = "#startbtn_active.png",
		disabled = "#startbtn_active.png"
	})
	:onButtonClicked(function(e)
		audio.playSound(GAME_SOUND["tapButton"])
		self:quickStart()	
	end)
	:align(display.CENTER, display.cx, display.cy + 200)
	:addTo(self)

end

function RoomListScene:quickStart()
	if self.roomlist then
		local randomRoom = self.roomlist[math.random(1,table.nums(self.roomlist))]
		self:enterRoom(randomRoom)
	end	
end

function RoomListScene:enterRoom(award)
	local sendMsg = function()
		app.currentAward = award
		local data = clone(app.me)
		data.awardId = award.awardId

		sockettcp:addEventListener("ON_ENTER_ROOM", handler(self, self.onEnterRoom))

		printf("enterRoom send data %s", json.encode(data))
		sockettcp:sendMessage(ENTER_ROOM_SERVICE, data)
	end

	if not sockettcp then 
		app:initSocket(sendMsg) 
	else
		sendMsg()
	end

end

--event

function RoomListScene:onEnter()
	--http get award list
	HttpClient.new(function(data)
		if #data == 0 then
			AlertView.new("无任何房间列表",nil):addTo(self)
		else
			self.roomlist = data
			--new Roomlist
			local rect = CCRect(display.left + 140, display.bottom + 80, display.width - 120 , display.height - 120)
			self.roomlistView = RoomList.new(rect,data):addTo(self)
			self.roomlistView:setTouchEnabled(true)
			self.roomlistView:addEventListener("onTapRoomIcon", handler(self, self.onTapRoomIcon))
		end
	 end,getUrl(AWARD_LIST_URL,app.currentLevel))
	:onRequestFailed(function() 
		AlertView.new("连接失败",nil):addTo(self)
	end)
	:start()
end

function RoomListScene:onEnterRoom(event)
	local players = event.data
	printf("onEnterRoom response data %s", json.encode(players))
	
	app.currentRoomId = players[1].roomId
	local playerWaitingScene = PlayerWaitingScene.new(players)
	display.replaceScene(playerWaitingScene)
end


function RoomListScene:onTapRoomIcon(event)
	audio.playSound(GAME_SOUND["tapButton"])
	-- show modal 
	local award = event.data
	local modalLayer = CommonModalView.new()
	local roomView = RoomView.new(award)
	modalLayer:addContentChild(roomView,0,20)
	--add quick start button
	local quickStart = cc.ui.UIPushButton.new({
		normal = "#faststartbtn.png",
		pressed = "#faststartbtn_active.png",
		disabled = "#faststartbtn_active.png"
	})
	:onButtonClicked(function(e) 
		self:enterRoom(award)
	end)
	modalLayer:addContentChild(quickStart, display.cx - 5, display.cy - 120, display.CENTER_RIGHT)

	local detail = cc.ui.UIPushButton.new({
			normal = "#viewbtn.png",
    		pressed = "#viewbtn_active.png",
    		disabled = "#viewbtn_active.png"
		})
	:onButtonClicked(function(e) 
		if award.detailHref then 
			device.openURL(award.detailHref)	
		end
		
	end)
	modalLayer:addContentChild(detail, display.cx + 5, display.cy - 120, display.CENTER_LEFT)

	self:addChild(modalLayer:getView())

	self.roomlistView:setTouchEnabled(false)
	modalLayer:addEventListener("onClose", function() 
		self.roomlistView:setTouchEnabled(true)
	end)

end

function RoomListScene:onExit()
	sockettcp:removeAllEventListenersForEvent("ON_ENTER_ROOM")
end

return RoomListScene