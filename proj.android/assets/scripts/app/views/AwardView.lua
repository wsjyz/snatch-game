--
-- Author: Alex
-- Date: 2013-12-14 23:45:37
--
local AwardView = class("AwardView", function()
	return display.newLayer()
end)

function AwardView:getAwardList()
	return {
				{awardName = "熏肉大饼", detailHref = "http://www.baidu.com"},
				{awardName = "手抓饼", detailHref = "http://www.sina.com.cn"},
				{awardName = "老婆饼", detailHref = "http://www.163.com"}
			}
end

function AwardView:ctor(awardList)
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	local bgWidth = self:getContentSize().width
	local bgHeight = self:getContentSize().height

	--test data
	-- if awardList == nil then
		-- awardList = self:getAwardList()
	-- end

	local startX = display.cx - 150
	local startY = display.cy + 200

	for i, award in ipairs(awardList) do
	
	--rank bg
	display.newSprite("#rank_".. i ..".png", startX, startY - i * 100):addTo(self)

	-- add award title and name
	ui.newTTFLabel({text = "恭喜您获得", size = 22, color = display.COLOR_WHITE})
	:align(display.CENTER_LEFT, startX + 30, startY - i * 100) 
	:addTo(self)

	ui.newTTFLabel({text = award.awardName, size = 24, color = ccc3(255, 255, 0), dimensions = CCSize(120, 30)})
	:align(display.CENTER_LEFT, startX + 150, startY - i * 100) 
	:addTo(self)

	-- add detail btn
	local cls = cc.ui.UIPushButton.new({
			normal = "#detailbtn.png",
    		pressed = "#detailbtn_active.png",
    		disabled = "#detailbtn.png"
		})
		:onButtonClicked(function(e)
			-- TODO： show url with detailHref
			device.openURL(award.detailHref)
		end)
		:align(display.CENTER, startX + 320, startY - i * 100)
		:addTo(self)

	end	
end

return AwardView