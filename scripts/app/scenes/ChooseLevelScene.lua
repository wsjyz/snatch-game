
local CommonBackground = import("..views.CommonBackground")
local MessageCenter = import("..MessageCenter").new("127.0.0.1",9110)
local SettingMenu = import("..views.SettingMenu")
local ChooseLevelScene = class("ChooseLevelScene",function ()
	return display.newScene("ChooseLevelScene")
end)


function ChooseLevelScene:ctor()
	local LEVEL_OFFSET_X = 225
	local LEVEL_OFFSET_Y = 50
	local scale_rate = 1.1

	CommonBackground.new():addTo(self)
	--乡试
	local easy = cc.ui.UIPushButton.new({
			normal = "#xiangshi.png",
    		pressed = "#xiangshi.png",
    		disabled = "#xiangshi.png"
		})
		:onButtonClicked(function(e) 
			MessageCenter:sendMessage(MessageCenter.ENTER_ROOM_SERVICE, {
					userId = "ivan",
					nickName = "蒋凌峰",
					awardId = "ROOM110",
					male = 1
				})
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
			print("enterNextScene")
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
			print("enterNextScene")
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
	SettingMenu.new(100,display.cy):addTo(self)

end



return ChooseLevelScene