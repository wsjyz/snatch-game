--
-- Author: Alex
-- Date: 2013-12-29 12:02:41
--
local CommonModalView = import(".CommonModalView")
local HttpClient = import("..HttpClient")

local WinRankView = class("WinRankView", function()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
    return node
end)

function WinRankView:getRankList()
    return {
        { nickName = "张三", rmb = 550},
        { nickName = "赵四", rmb = 500},  
        { nickName = "王五", rmb = 220}
    }
end
function WinRankView:ctor(rankList)
	self.modalLayer = app:createView("CommonModalView")

	-- temp test code
    -- if rankList == nil then
    --     rankList = self:getRankList()
    -- end

    -- add rank detail
    local startX = display.cx - 130
	local startY = display.cy + 150

	for i, rank in ipairs(rankList) do

		if i > 3 then
			break
		end

		--rank bg
		local rankBg = display.newSprite("#rank_".. i ..".png")
		self.modalLayer:addContentChild(rankBg, startX, startY - i * 80, display.CENTER_LEFT)

		--detail
		local rankLabel = ui.newTTFLabel({text = rank.nickName .. "  " .. rank.rmb, size = 28, color = ccc3(95, 41, 0)})
		self.modalLayer:addContentChild(rankLabel, startX + 60, startY - i * 80, display.CENTER_LEFT)
	end

	--onclose
    self.modalLayer:addEventListener("onClose", handler(self, self.onClose))

	self:addChild(self.modalLayer:getView())
end

function WinRankView:onClose()
    self:dispatchEvent({name = "onClose"})
end

function WinRankView:onEnter()
	
end

return WinRankView