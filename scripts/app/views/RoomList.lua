--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-17 14:00:34
--
local PageControl = import("..ui.PageControl")
local RoomListCell = import(".RoomListCell")

local RoomList = class("RoomList", PageControl)

RoomList.INDICATOR_MARGIN = 46

function RoomList:ctor(rect,roomlist)
	RoomList.super.ctor(self,rect,PageControl.DIRECTION_HORIZONTAL)
	local cols = 4
	local roomSize = table.nums(roomlist)

	local numPages = math.ceil(roomSize / cols)
    local levelIndex = 1

    for pageIndex = 1, numPages do
    	local cellRoomList = {}
    	for roomIndex = 1, cols do
    		local currentIndex = (pageIndex - 1) * cols + roomIndex
    		if currentIndex > roomSize then break end
    		cellRoomList[roomIndex] = roomlist[currentIndex]
    	end

    	if #cellRoomList > 0 then
    		--add room list cel
    		local cell = RoomListCell.new(rect.size,cellRoomList)

    		cell:addEventListener("onTapRoomIcon", handler(self, self.onTapRoomIcon))
    		self:addCell(cell)
    	end

    end

    -- add indicators
    local x = (self:getClippingRect().size.width - RoomList.INDICATOR_MARGIN * (numPages - 1)) / 2 + 20 
    local y = self:getClippingRect().origin.y + 80  

    printf("indicator x : %d , y : %d", x,y)
    self.indicator_ = display.newSprite("#cell_selected.png")
    self.indicator_:setPosition(x, y)
    self.indicator_.firstX_ = x

    for pageIndex = 1, numPages do
        local icon = display.newSprite("#cell_indicator.png")
        icon:setPosition(x, y)
        self:addChild(icon)
        x = x + RoomList.INDICATOR_MARGIN
    end

    self:addChild(self.indicator_)
	
end

function RoomList:scrollToCell(index, animated, time)
    RoomList.super.scrollToCell(self, index, animated, time)

    transition.stopTarget(self.indicator_)
    local x = self.indicator_.firstX_ + (self:getCurrentIndex() - 1) * RoomList.INDICATOR_MARGIN
    if animated then
        time = time or self.defaultAnimateTime
        transition.moveTo(self.indicator_, {x = x, time = time / 2})
    else
        self.indicator_:setPositionX(x)
    end
end

function RoomList:onTapRoomIcon(event)
	self:dispatchEvent({name = "onTapRoomIcon", data = event.data})
end

return RoomList