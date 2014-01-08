--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-17 17:33:14
--
local ScrollViewCell = import("..ui.ScrollViewCell")
local RoomView = import(".RoomView")
local RoomListCell = class("RoomListCell", ScrollViewCell)

function RoomListCell:ctor(size,roomList)	
	local colWidth = math.floor(size.width * 0.9 / 4)
    self.buttons = {}

    local startX = display.cx - colWidth * 3 /2 + 40 
    
    local y = display.cy - 20 

    local x = startX
    for i,room in ipairs(roomList) do
    	--add room
    	local icon = RoomView.new(room,x,y):addTo(self)
    	icon.data = room
    	self.buttons[#self.buttons + 1] = icon
    	x = x + colWidth
    end

end

function RoomListCell:onTap(x, y)
    local button = self:checkButton(x, y)
    if button then
        self:dispatchEvent({name = "onTapRoomIcon", data = button.data})
    end
end

function RoomListCell:checkButton(x, y)
    local pos = CCPoint(x, y)
    for i = 1, #self.buttons do
        local button = self.buttons[i]
        if button:getBoundingBox():containsPoint(pos) then
            return button
        end
    end
    return nil
end

return RoomListCell