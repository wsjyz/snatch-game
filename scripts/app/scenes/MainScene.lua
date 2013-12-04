
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self.bg = display.newSprite("#bg.png", display.cx, display.cy)
    self:addChild(self.bg)

    self.startBtn = ui.newImageMenuItem({
            image = "#logobtn.png",
            imageSelected = "#logobtn.png",
            imageDisabled = "#logobtn.png"
        })   
    self.startBtn:setPosition(display.cx,display.top - self.startBtn:getContentSize().height/2)
    self:addChild(self.startBtn)
    transition.moveTo(self.startBtn,{
        time = 0.6,
        y = display.cy,
        easing = "BOUNCEOUT"
        })
    
end

function MainScene:onEnter()
    if device.platform == "android" then
        -- avoid unmeant back
        self:performWithDelay(function()
            -- keypad layer, for android
            local layer = display.newLayer()
            layer:addKeypadEventListener(function(event)
                if event == "back" then app.exit() end
            end)
            self:addChild(layer)

            layer:setKeypadEnabled(true)
        end, 0.5)
    end
end

function MainScene:onExit()
end

return MainScene
