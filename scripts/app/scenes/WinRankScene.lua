--
-- Author: Alex
-- Date: 2013-12-22 11:22:47
--
local WinRankScene = class("WinRankScene", function()
    return display.newScene("WinRankScene")
end)

WinRankScene.RankList = {
	{ nickName = "张三", rmb = 500},
	{ nickName = "赵四", rmb = 300},	
	{ nickName = "王五", rmb = 100}
}

function WinRankScene:ctor(rankList)

	self.bg = display.newSprite("#bg.png", display.cx, display.cy)
    self:addChild(self.bg)

    self.bgInner = display.newSprite("#floatbg_gold.png", display.cx, display.cy)
    self:addChild(self.bgInner)

    local bgWidth = self.bgInner:getContentSize().width
    local bgHeight = self.bgInner:getContentSize().height

    --add close button
    cc.ui.UIPushButton.new({
            normal = "#close.png",
            pressed = "#close_active.png"
        })
     :onButtonClicked(function(e)
            local button = e.target
            app:enterChooseLevel()
        end)
     :align(display.CENTER_RIGHT, display.cx + bgWidth/2 + 20, display.cy + bgHeight/2 - 10)
     :addTo(self)

    -- add rank detail

    -- temp set rank list
    rankList = WinRankScene.RankList 

    local startX = display.cx - 130
	local startY = display.cy + 150

	for i, rank in ipairs(rankList) do

		--rank bg
		display.newSprite("#rank_".. i ..".png", startX, startY - i * 80):addTo(self)

		--detail
		ui.newTTFLabel({text = rank.nickName .. "  " .. rank.rmb, size = 28, color = ccc3(95, 41, 0)})
		:align(display.CENTER_LEFT, startX + 60, startY - i * 80) 
		:addTo(self)
	end
end

return WinRankScene