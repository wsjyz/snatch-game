--
-- Author: Alex
-- Date: 2013-12-14 23:45:27
--
local ProfileView = class("ProfileView", function()
	return display.newLayer()
end)

ProfileView.Labels = {
	{ text = "姓名" },
	{ text = "QQ" },
	{ text = "手机" },
	{ text = "邮箱" },
	{ text = "地址" }
}

function ProfileView:ctor(userInfo)
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()	
	
	--TODO: need to use player info
	self.male = 1

	local bgWidth = self:getContentSize().width
	local bgHeight = self:getContentSize().height

	--avatar
	local avatarImage = ((self.male == 1 and "#male.png") or "#femail.png")
	local avatar = display.newSprite(avatarImage, display.cx - 100, display.cy + 120):addTo(self)

	local userName = ui.newTTFLabel({text = "奔跑的二哥", size = 24, color = ccc3(255, 255, 0)})
	:align(display.CENTER_LEFT, display.cx - 50, display.cy + 150) 
	:addTo(self)

	--level
	-- local level = ui.newTTFLabel({text = "中级", size = 24, color = ccc3(255, 255, 0)})
	-- :align(display.CENTER_LEFT, display.cx - 50, display.cy + 110) 
	-- :addTo(self)

	local rank = ui.newTTFLabel({text = "当前排名:第3名", size = 24, color = display.COLOR_WHITE})
	:align(display.CENTER_LEFT, display.cx + 80, display.cy + 150) 
	:addTo(self)

	-- --add editbox 
	-- local loadbtn = cc.ui.UIPushButton.new("#inputbox2.png", {scale9 = true})
 --        :setButtonSize(300, 40)
 --        :setButtonLabel(cc.ui.UILabel.new({text = "奔跑的二哥", color = ccc3(95, 41, 0),size = 18}))
 --        :align(display.LEFT_CENTER, display.cx - 50, display.cy + 20)
	-- 	:addTo(self)

	local locX,locY = display.cx - 120, display.cy + 80
	for i, label in ipairs(ProfileView.Labels) do
		
		-- add label
		ui.newTTFLabel({text = label.text, size = 24, color = ccc3(95, 41, 0)})
		:align(display.CENTER_LEFT, locX, locY - 45 * i) 
		:addTo(self)

		-- add label btn
		cc.ui.UIPushButton.new("#inputbox2.png", {scale9 = true})
        :setButtonSize(300, 40)
        :setButtonLabel(cc.ui.UILabel.new({text = "奔跑的二哥", color = ccc3(95, 41, 0),size = 22}))
        :align(display.LEFT_CENTER, locX + 70, locY - 45 * i)
		:addTo(self)
	end
end

return ProfileView