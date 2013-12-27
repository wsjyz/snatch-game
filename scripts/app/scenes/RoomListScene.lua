--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-11 18:23:43
--
local bgLayer = import("..views.CommonBackground").new(false)
local SettingMenu = import("..views.SettingMenu")
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
	self:addChild(bgLayer)
	self:addChild(SettingMenu.new())

	--http get award list
	HttpClient.new(function(data)
		if #data == 0 then 
			AlertView.new("无任何房间列表",nil):addTo(self)
		else
			--new Roomlist
			local rect = CCRect(display.left + 140, display.bottom + 80, display.width - 120 , display.height - 120)
			self.roomlist = RoomList.new(rect,data)
				:addTo(self)
			self.roomlist:setTouchEnabled(true)
			self.roomlist:addEventListener("onTapRoomIcon", handler(self, self.onTapRoomIcon))
		end
	 end,getUrl(AWARD_LIST_URL, level))
	:onRequestFailed(function() 
			AlertView.new("连接失败",nil):addTo(self)
		end)
	:start()
	
	--quick start
	cc.ui.UIPushButton.new({
			normal = "#startbtn.png",
    		pressed = "#startbtn_active.png",
    		disabled = "#startbtn_active.png"
		})
	:onButtonClicked(function(e)
		self:quickStart()	
		end)
	:align(display.CENTER, display.cx, display.cy + 200)
	:addTo(self)

	sockettcp:addEventListener("ON_ENTER_ROOM", handler(self, self.onEnterRoom))

end

function RoomListScene:onEnterRoom(event)
	print(event.name)
end


function RoomListScene:onTapRoomIcon(event)
	-- show modal 
	local modalLayer = CommonModalView.new()
	local roomView = RoomView.new(event.data)
	modalLayer:addContentChild(roomView,0,20)
	--add quick start button
	local quickStart = cc.ui.UIPushButton.new({
			normal = "#faststartbtn.png",
    		pressed = "#faststartbtn_active.png",
    		disabled = "#faststartbtn_active.png"
		})
	:onButtonClicked(function(e) 
		self:quickStart()
	end)
	modalLayer:addContentChild(quickStart, display.cx - 5, display.cy - 120, display.CENTER_RIGHT)

	local detail = cc.ui.UIPushButton.new({
			normal = "#viewbtn.png",
    		pressed = "#viewbtn_active.png",
    		disabled = "#viewbtn_active.png"
		})
	:onButtonClicked(function(e) 
		device.openURL("http://www.baidu.com")
	end)
	modalLayer:addContentChild(detail, display.cx + 5, display.cy - 120, display.CENTER_LEFT)

	self:addChild(modalLayer:getView())

	self.roomlist:setTouchEnabled(false)
	modalLayer:addEventListener("onClose", function() 
		self.roomlist:setTouchEnabled(true)
	end)

end

function RoomListScene:quickStart()
	--todo quick start
	-- sockettcp:sendMessage(ENTER_ROOM_SERVICE, {
	-- 		userId = "ivan2",
	-- 		nickName = "Ivan",
	-- 		awardId = "ROOM110",
	-- 		male = 1
	-- 	})
	local playerWaitingScene = PlayerWaitingScene.new({
		{
			userId = "ivan2",
			playerName = "Ivan1",
			awardId = "ROOM110",
			seatNo = 0,
			male = 1
		},
		{
			userId = "ivan3",
			playerName = "Ivan3",
			awardId = "ROOM110",
			seatNo = 1,
			male = 0
		},
		{
			userId = "ivan4",
			playerName = "Ivan4",
			awardId = "ROOM110",
			seatNo = 2,
			male = 0
		},
		{
			userId = "ivan5",
			playerName = "Ivan5",
			awardId = "ROOM110",
			seatNo = 3,
			male = 0
		},
		{
			userId = "ivan6",
			playerName = "Ivan6",
			awardId = "ROOM110",
			seatNo = 4,
			male = 1
		},
		{
			userId = "ivan7",
			playerName = "Ivan7",
			awardId = "ROOM110",
			seatNo = 5,
			male = 1
		}
	})

	display.replaceScene(playerWaitingScene)
	
end

return RoomListScene