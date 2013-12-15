--
-- Author: Alex
-- Date: 2013-12-14 01:35:56
--

local ProfileView = import("..views.ProfileView").new()
local AwardView = import("..views.AwardView").new()

local ProfileCenterScene = class("ProfileCenterScene", function()
    return display.newScene("ProfileCenterScene")
end)

ProfileCenterScene.PROFILE_BUTTON_IMAGES = {
    off = "#pers1.png",
    off_pressed = "#pers1.png",
    on = "#pers2.png",
    on_pressed = "#pers2.png",
}

ProfileCenterScene.AWARD_BUTTON_IMAGES = {
    off = "#awa_normal.png",
    off_pressed = "#awa_normal.png",
    on = "#awa_pressed.png",
    on_pressed = "#awa_pressed.png",
}

function ProfileCenterScene:ctor()

    self.bg = display.newSprite("#bg.png", display.cx, display.cy)
    self:addChild(self.bg)

    self.bgInner = display.newSprite("#floatbg_large.png", display.cx, display.cy)
    self:addChild(self.bgInner)

    self:addChild(ProfileView) 

    local bgWidth = self.bgInner:getContentSize().width
    local bgHeight = self.bgInner:getContentSize().height

    local btnGroup = cc.ui.UICheckBoxButtonGroup.new(display.TOP_TO_BOTTOM)
    :addButton(cc.ui.UICheckBoxButton.new(ProfileCenterScene.PROFILE_BUTTON_IMAGES)
            :setButtonSelected(true)
            :align(display.LEFT_TOP))
    :addButton(cc.ui.UICheckBoxButton.new(ProfileCenterScene.AWARD_BUTTON_IMAGES)
            :align(display.LEFT_TOP))
    :setButtonsLayoutMargin(10, 10, 10, 10)
    :onButtonSelectChanged(function(event)
            printf("Option %d selected, Option %d unselected", event.selected, event.last)
            if event.selected == 1 then 
                -- print(ProfileView.getParent())
                self:addChild(ProfileView) 
                -- print(ProfileView.getParent())
            else 
                
            end 
        end)
    :align(display.LEFT_TOP, display.cx - bgWidth/2 + 35, display.cy - 130)
    :addTo(self)

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
end

return ProfileCenterScene