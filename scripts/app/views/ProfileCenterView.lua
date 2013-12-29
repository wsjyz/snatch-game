--
-- Author: Alex
-- Date: 2013-12-29 13:35:44
--
local CommonModalView = import(".CommonModalView")
local ProfileView = import(".ProfileView")
local AwardView = import(".AwardView")

local ProfileCenterView = class("ProfileCenterView", function()
    return display.newNode()
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

    local modalLayer = CommonModalView.new(true, "#floatbg_large.png")

    -- init profile and award view
    self.profileView = ProfileView.new() 
    self.awardView = AwardView.new()

    self.awardView:setVisible(false)
   
    modalLayer:addContentChild(self.profileView, 0, 0, display.CENTER)
    modalLayer:addContentChild(self.awardView, 0, 0, display.CENTER)

    local bgWidth = modalLayer:getContentSize().width
    local bgHeight = modalLayer:getContentSize().height

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
    
    modalLayer:addContentChild(btnGroup, display.cx - bgWidth/2 + 35, display.cy - 130, display.LEFT_TOP)

    self:addChild(modalLayer:getView())
end

return ProfileCenterView