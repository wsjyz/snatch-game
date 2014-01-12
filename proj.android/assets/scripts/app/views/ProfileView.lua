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

-- level detail
-- 0 进士, 300 秀才, 700 举人, 1000 状元
-- function ProfileView:getLevelText(experience)
	
-- 	assert(type(experience) == "number","Invalid type, must be number")

-- 	if experience < 300 then
-- 		return "进士"
-- 	elseif experience >= 300 and experience < 700 then
-- 		return "秀才"
-- 	elseif experience >= 700 and experience < 1000 then
-- 		return "举人"
-- 	else
-- 		return "状元"
-- 	end
-- end

function ProfileView:getProfilePlayer()
	return { 
				playerName = "奔跑的小妞",
			 	male = 0,
			 	ranking = 2,
			 	experience = 500,
			 	currentExperience = 80,
			 	currentTitle = "秀才",
			 	peopleName = "谭校长",
			 	qq = "12345678",
			 	phone = "13800246789",
			 	email = "tanyonglin@163.com",
			 	address = "香港铜锣湾115号501"
			}
end

function ProfileView:setLabelValuesWithPlayer(player)
	ProfileView.Labels[1].value = player.peopleName or "";
	ProfileView.Labels[2].value = player.qq or "";
	ProfileView.Labels[3].value = player.phone or "";
	ProfileView.Labels[4].value = player.email or "";
	ProfileView.Labels[5].value = player.address or "";
end

function ProfileView:ctor()
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	local bgWidth = self:getContentSize().width
	local bgHeight = self:getContentSize().height

	local player = app.me

	if player == nil then
		player = self:getProfilePlayer()
	end

	--avatar
	local avatarImage = ((player.male == 1 and "#male.png") or "#female.png")
	local avatar = display.newSprite(avatarImage, display.cx - 110, display.cy + 120):addTo(self)

	local userName = ui.newTTFLabel({text = player.nickName, size = 24, color = ccc3(255, 255, 0)})
	:align(display.CENTER_LEFT, display.cx - 50, display.cy + 150) 
	:addTo(self)

	-- add rank
	local rank = ui.newTTFLabel({text = "当前排名:第" .. player.ranking .. "名", size = 24, color = display.COLOR_WHITE})
				:align(display.CENTER_LEFT, display.cx + 80, display.cy + 150) 
				:addTo(self)
			
	-- add level
	ui.newTTFLabel({text = player.currentTitle, size = 24, color = ccc3(255, 255, 0)})
		:align(display.CENTER_LEFT, display.cx - 50, display.cy + 100) 
		:addTo(self)

	-- level progress
	local progress_bg = display.newSprite("#progress_bg.png", display.cx + 150, display.cy + 100):addTo(self)
   	local progress = display.newProgressTimer("#progress_fg.png", display.PROGRESS_TIMER_BAR)
   	:pos(display.cx + 150, display.cy + 100)
   	:addTo(self)
    
   	progress:setMidpoint(ccp(0,0))
   	progress:setBarChangeRate(ccp(1,0))
   	progress:setPercentage(player.currentExpRate)

   	-- set player label value
   	self:setLabelValuesWithPlayer(player)

	local locX,locY = display.cx - 120, display.cy + 80
	for i, label in ipairs(ProfileView.Labels) do
		
		-- add label
		ui.newTTFLabel({text = label.text, size = 24, color = ccc3(47, 15, 0)})
		:align(display.CENTER_LEFT, locX, locY - 45 * i) 
		:addTo(self)

		-- add label btn
		cc.ui.UIPushButton.new("#inputbox2.png", {scale9 = true})
		:align(display.LEFT_CENTER, locX + 70, locY - 45 * i)
        :setButtonSize(300, 40)
        :setButtonLabelAlignment(display.LEFT_CENTER)
        :setButtonLabelOffset(-145,0)
        :setButtonLabel(cc.ui.UILabel.new({text = label.value, color = ccc3(95, 41, 0),size = 22}))
		:addTo(self)
	end
end

return ProfileView