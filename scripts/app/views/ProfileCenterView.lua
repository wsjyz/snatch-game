--
-- Author: Alex
-- Date: 2013-12-29 13:35:44
--
local ProfileView = import(".ProfileView")
local AwardView = import(".AwardView")

local ProfileCenterView = class("ProfileCenterView", function()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    require(cc.PACKAGE_NAME .. ".api.EventProtocol").extend(node)
    return node
end)

ProfileCenterView.PROFILE_BUTTON_IMAGES = {
    off = "#pers1.png",
    off_pressed = "#pers1.png",
    on = "#pers2.png",
    on_pressed = "#pers2.png",
}

ProfileCenterView.AWARD_BUTTON_IMAGES = {
    off = "#awa_normal.png",
    off_pressed = "#awa_normal.png",
    on = "#awa_pressed.png",
    on_pressed = "#awa_pressed.png",
}

function ProfileCenterView:ctor()
    self.modalLayer = app:createView("CommonModalView")
    -- init profile and award view
    self.profileView = ProfileView.new() 
    self.awardView = AwardView.new()

    self.awardView:setVisible(false)
   
    self.modalLayer:addContentChild(self.profileView, 0, 0, display.CENTER)
    self.modalLayer:addContentChild(self.awardView, 0, 0, display.CENTER)

    local bgWidth = self.modalLayer:getContentSize().width
    local bgHeight = self.modalLayer:getContentSize().height

    -- add btn group
    local btnGroup = cc.ui.UICheckBoxButtonGroup.new(display.TOP_TO_BOTTOM)
    :addButton(cc.ui.UICheckBoxButton.new(ProfileCenterView.PROFILE_BUTTON_IMAGES)
            :setButtonSelected(true)
            :align(display.LEFT_TOP))
    :addButton(cc.ui.UICheckBoxButton.new(ProfileCenterView.AWARD_BUTTON_IMAGES)
            :align(display.LEFT_TOP))
    :setButtonsLayoutMargin(10, 10, 10, 10)
    :onButtonSelectChanged(function(event)
            printf("Option %d selected, Option %d unselected", event.selected, event.last)
            if event.selected == 1 then
                self.profileView:setVisible(true)
                self.awardView:setVisible(false)
            else 
                self.profileView:setVisible(false)
                self.awardView:setVisible(true)
            end 
        end)
    
    self.modalLayer:addContentChild(btnGroup, display.cx - bgWidth/2 + 35, display.cy - 130, display.LEFT_TOP)

    --onclose
    self.modalLayer:addEventListener("onClose", handler(self, self.onClose))

    self:addChild(self.modalLayer:getView())
end

function ProfileCenterView:onClose()
    self:dispatchEvent({name = "onClose"})
end

return ProfileCenterView