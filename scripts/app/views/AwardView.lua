--
-- Author: Alex
-- Date: 2013-12-14 23:45:37
--
local AwardView = class("AwardView", function()
	return display.newLayer()
end)

AwardView.AwardList = {
	{ bgHref = "http://f.hiphotos.baidu.com/image/w%3D2048/sign=fb49aca5087b02080cc938e156e1f3d3/bf096b63f6246b60997c3674e9f81a4c510fa244.jpg", description = "这个是第一个奖品" },
	{ bgHref = "http://a.hiphotos.baidu.com/image/w%3D2048/sign=a8b98a1dd62a283443a6310b6f8dc8ea/adaf2edda3cc7cd945f0aed93b01213fb90e91d5.jpg", description = "这个是第二个奖品" },
	{ bgHref = "http://b.hiphotos.baidu.com/image/w%3D2048/sign=348d33c8902397ddd6799f046dbab3b7/9c16fdfaaf51f3dee53ab34b95eef01f3a297910.jpg", description = "这个是最后一个奖品" }
}

function AwardView:ctor(awardList)
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	local bgWidth = self:getContentSize().width
	local bgHeight = self:getContentSize().height

	-- temp set locla vars
	awardList = AwardView.AwardList

	local startX = display.cx - 150
	local startY = display.cy + 200

	for i, award in ipairs(awardList) do
	
	--rank bg
	display.newSprite("#rank_".. i ..".png", startX, startY - i * 100):addTo(self)

	-- add label
	ui.newTTFLabel({text = "恭喜您获得", size = 24, color = display.COLOR_WHITE})
	:align(display.CENTER_LEFT, startX + 30, startY - i * 100) 
	:addTo(self)

	-- add award image TODO:
	-- ui.newTTFLabel({text = "恭喜您获得", size = 24, color = display.COLOR_WHITE})
	-- :align(display.CENTER_LEFT, startX + 50, startY - i * 100) 
	-- :addTo(self)

	-- add detail btn
	local cls = cc.ui.UIPushButton.new({
			normal = "#detailbtn.png",
    		pressed = "#detailbtn_active.png",
    		disabled = "#detailbtn.png"
		})
		:onButtonClicked(function(e)
			
		end)
		:align(display.CENTER, startX + 300, startY - i * 100)
		:addTo(self)

	end	
end

return AwardView