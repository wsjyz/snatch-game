--
-- Author: Alex
-- Date: 2013-12-29 12:02:41
--
local CommonModalView = import(".CommonModalView")
local WinRankView = class("WinRankView", function()
    return display.newNode()
end)

function WinRankView:getRankList()
    return {
        { nickName = "张三", rmb = 550},
        { nickName = "赵四", rmb = 500},  
        { nickName = "王五", rmb = 220}
    }
end
function WinRankView:ctor(rankList)

	local modalLayer = CommonModalView.new()

	local bgInner = display.newSprite("#floatbg_gold.png")
    modalLayer:addContentChild(bgInner, display.cx, display.cy, display.CENTER)

    if rankList == nil then
        rankList = self:getRankList()
    end

    -- add rank detail
    local startX = display.cx - 130
	local startY = display.cy + 150

	for i, rank in ipairs(rankList) do

		--rank bg
		local rankBg = display.newSprite("#rank_".. i ..".png")
		modalLayer:addContentChild(rankBg, startX, startY - i * 80, display.CENTER_LEFT)

		--detail
		local rankLabel = ui.newTTFLabel({text = rank.nickName .. "  " .. rank.rmb, size = 28, color = ccc3(95, 41, 0)})
		modalLayer:addContentChild(rankLabel, startX + 60, startY - i * 80, display.CENTER_LEFT)
	end

	self:addChild(modalLayer:getView())
end

return WinRankView