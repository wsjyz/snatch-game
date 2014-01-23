--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-08 17:07:33
--
local httpClient = import("..HttpClient")
local sharedDirector = CCDirector:sharedDirector()
local SettingMenu = class("SettingMenu",function()
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
	return node
end)

function SettingMenu:ctor(x,y)
	local MENU_DATA = {
		{ label = "结束", callback = handler(self, self.goBack_), offsetTimes = 2},
		{ label = "排行", callback = handler(self, self.showRank_),offsetTimes = 1},
		{ label = "中心", callback = handler(self, self.userInfo_),offsetTimes = 0},
		{ label = "音量", callback = handler(self, self.volumeControl_),offsetTimes = -1}
	}

	self.item_visible = false

	local itemPadding = 90
	self.x = x or 100
	self.y = y or display.cy
	local menuBar = display.newSprite("#menubar.png",self.x,self.y)
	self:addChild(menuBar)
	menuBar:setVisible(false)

	local function createMenuItem(label,callback)
		local button = cc.ui.UIPushButton.new({
			normal = "#menubtn.png",
    		pressed = "#menubtn_active.png",
    		disabled = "#menubtn_active.png"
		})
		:setButtonLabel("normal", ui.newTTFLabel({
            text = label,
            size = 24
        }))
		:onButtonClicked(function(event) 
			callback(event)
		end)

		return button
	end

	for _,v in ipairs(MENU_DATA) do
		local btn = createMenuItem(v.label,v.callback)
		btn:align(display.CENTER, self.x, self.y + itemPadding * v.offsetTimes)
		:hide()
		:addTo(self)
	end

	--toggle Btn
	cc.ui.UIPushButton.new({
			normal = "#setbtn.png",
    		pressed = "#setbtn_activ.png",
    		disabled = "#setbtn_activ.png"
		})
	:onButtonClicked(function(event) 
		audio.playSound(GAME_SOUND["tapButton"])
		local children = self:getChildren()
		for i=0,children:count() - 1 do
			local child = children:objectAtIndex(i)
			if child ~= event.target then
				child:setVisible(not self.item_visible)
			end 
		end
		self.item_visible = not self.item_visible
	end)
	:align(display.CENTER, self.x, self.y - itemPadding * 2)
	:addTo(self)


end

function SettingMenu:goBack_(event)
	audio.playSound(GAME_SOUND["tapBack"])
	self:dispatchEvent({name = "goBack"})
end

function SettingMenu:showRank_(event)

	httpClient.new(function(rankList)

        if rankList ~= nil then        	
        	-- enter profile center
        	audio.playSound(GAME_SOUND["popup"])	
			local rankview = app:createView("WinRankView", rankList)
			rankview:addEventListener("onClose", handler(self, self.onPopupClose))
			if display.getRunningScene() then
				rankview:addTo(display.getRunningScene(),3)
			else
				rankview:addTo(self,3)
			end
			self:dispatchEvent({name = "onPopup"})

        end
    end,getUrl(RANKING_LIST_URL))    
    :start()
	
end

function SettingMenu:userInfo_(event)

	httpClient.new(function(awardList)

        if awardList ~= nil then        	
        	-- enter profile center
        	audio.playSound(GAME_SOUND["popup"])
			local profileview = app:createView("ProfileCenterView", awardList)
			profileview:addEventListener("onClose", handler(self, self.onPopupClose))
			if display.getRunningScene() then
				profileview:addTo(display.getRunningScene(),3)
			else
				profileview:addTo(self,3)
			end
			self:dispatchEvent({name = "onPopup"})

        end
    end,getUrl(PRIZE_LIST_URL, app.me.playerId))    
    :start()	
end

function SettingMenu:onPopupClose()
	self:dispatchEvent({name = "onPopupClose"})
end

function SettingMenu:volumeControl_(event)
	
	if audio.getMusicVolume() == 0.0 then
		audio.setMusicVolume(1.0)
		audio.setSoundsVolume(1.0)
	else
		audio.setMusicVolume(0.0)
		audio.setSoundsVolume(0.0)
	end

	-- TEST SHARE CODE
	-- if device.platform == "ios" then
	-- 	luaoc.callStaticMethod("SnsShareCenter", "share", { player = app.me })
	-- elseif device.platform == "android" then
	-- 	-- TODO
	-- end
end


return SettingMenu