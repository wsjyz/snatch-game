
local CommonBackground = import("..views.CommonBackground")
local SettingMenu = import("..views.SettingMenu")
local HttpClient = import("..HttpClient")
local MessageCenter = import("..MessageCenter")

local ChooseLevelScene = class("ChooseLevelScene",function ()
	return display.newScene("ChooseLevelScene")
end)


function ChooseLevelScene:ctor()
	local LEVEL_OFFSET_X = 225
	local LEVEL_OFFSET_Y = 50
	local scale_rate = 1.1
	local experience = app.me.experience or 0 

	CommonBackground.new():addTo(self)
	--乡试
	local easy = cc.ui.UIPushButton.new({
			normal = "#xiangshi.png",
    		pressed = "#xiangshi.png",
    		disabled = "#xiangshi.png"
		})
		:onButtonClicked(function(e)
			audio.playSound(GAME_SOUND["tapButton"]) 
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
			audio.playSound(GAME_SOUND["tapButton"])
			app:enterChooseAward(2)
		end)
		:onButtonPressed(function (e) 
			 e.target:setScale(scale_rate)
		end)
		:onButtonRelease(function (e) 
			e.target:setScale(1.0)
		end)
		:setButtonEnabled(experience >= 300)
		:align(display.CENTER, display.cx, display.cy - LEVEL_OFFSET_Y)
		:addTo(self)
	--殿试
	local hard = cc.ui.UIPushButton.new({
			normal = "#dianshi.png",
    		pressed = "#dianshi.png",
    		disabled = "#dianshi_lock.png"
		})
		:onButtonClicked(function(e) 
			audio.playSound(GAME_SOUND["tapButton"])
			app:enterChooseAward(3)
		end)
		:onButtonPressed(function (e) 
			 e.target:setScale(scale_rate)
		end)
		:onButtonRelease(function (e) 
			e.target:setScale(1.0)
		end)
		:setButtonEnabled(experience >= 700)
		:align(display.CENTER, display.cx + LEVEL_OFFSET_X , display.cy - LEVEL_OFFSET_Y)
		:addTo(self)
	--SettingMenu	
	local menu = SettingMenu.new():addTo(self)
	menu:addEventListener("goBack", handler(self, self.goBack))

end

function ChooseLevelScene:goBack(event)
	printf("goBack called")
	app:exit()
end

return ChooseLevelScene