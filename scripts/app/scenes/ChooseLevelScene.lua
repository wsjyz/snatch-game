-- global variable sockettcp
import("..MessageCenter").new()

local CommonBackground = import("..views.CommonBackground")
local SettingMenu = import("..views.SettingMenu")

local ChooseLevelScene = class("ChooseLevelScene",function ()
	return display.newScene("ChooseLevelScene")
end)


function ChooseLevelScene:ctor()
	local LEVEL_OFFSET_X = 225
	local LEVEL_OFFSET_Y = 50
	local scale_rate = 1.1

	cc.EventProxy.new(sockettcp , self)
	:addEventListener("ON_ENTER_ROOM",self.onEnterRoom,self)


	CommonBackground.new():addTo(self)
	--乡试
	local easy = cc.ui.UIPushButton.new({
			normal = "#xiangshi.png",
    		pressed = "#xiangshi.png",
    		disabled = "#xiangshi.png"
		})
		:onButtonClicked(function(e) 
				app:enterChooseAward(1)
			end)
		:onButtonPressed(function (e) 
			 e.target:setScale(scale_rate)
		end)
		:onButtonRelease(function (e) 
			e.target:setScale(1.0)
		end)
		:align(display.CENTER, display.cx - LEVEL_OFFSET_X , display.cy - LEVEL_OFFSET_Y )
		:addTo(self)

	--会试
	local normal = cc.ui.UIPushButton.new({
			normal = "#huishi.png",
    		pressed = "#huishi.png",
    		disabled = "#huishi_lock.png"
		})
		:onButtonClicked(function(e) 
			app:enterChooseAward(2)
			end)
		:onButtonPressed(function (e) 
			 e.target:setScale(scale_rate)
		end)
		:onButtonRelease(function (e) 
			e.target:setScale(1.0)
		end)
		:setButtonEnabled(false)
		:align(display.CENTER, display.cx, display.cy - LEVEL_OFFSET_Y)
		:addTo(self)
	--殿试
	local hard = cc.ui.UIPushButton.new({
			normal = "#dianshi.png",
    		pressed = "#dianshi.png",
    		disabled = "#dianshi_lock.png"
		})
		:onButtonClicked(function(e) 
			app:enterChooseAward(3)
			end)
		:onButtonPressed(function (e) 
			 e.target:setScale(scale_rate)
		end)
		:onButtonRelease(function (e) 
			e.target:setScale(1.0)
		end)
		:setButtonEnabled(false)
		:align(display.CENTER, display.cx + LEVEL_OFFSET_X , display.cy - LEVEL_OFFSET_Y)
		:addTo(self)
	--SettingMenu	
	local menu = SettingMenu.new():addTo(self)
	menu:addEventListener("goBack", handler(self, self.goBack))

end

function ChooseLevelScene:goBack(event)
	printf("goBack called")
	app:enterScene("LoginScene")
end

return ChooseLevelScene