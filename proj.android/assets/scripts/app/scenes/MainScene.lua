
local HttpClient = import("..HttpClient")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    app:createView("CommonBackground",false):addTo(self)
          
    display.newSprite("#desk1.png", display.cx, display.bottom + 140):addTo(self)
    display.newSprite("#people.png", display.right - 200, display.cy):addTo(self)
    
    self.startBtn = cc.ui.UIPushButton.new("#start.png"):onButtonClicked(function(e) 
            audio.playSound(GAME_SOUND["tapButton"])
            self:checkPlayer()
        end)
    self.startBtn:setPosition(display.cx,display.top - self.startBtn:getContentSize().height/2)
    self:addChild(self.startBtn)
    transition.moveTo(self.startBtn,{
        time = 0.6,
        y = display.cy + 30,
        easing = "BOUNCEOUT"
    })

end

function MainScene:checkPlayer()
    -- local playerId = "player" .. math.random(1,10)
    local playerId = device.getOpenUDID()
    HttpClient.new(function(player) 
        if type(player) == "table" then
            app.me = player
            app:enterChooseLevel()
        else
            self.startBtn:removeSelf(true)
            app:createView("LoginForm", playerId):addTo(self,1)
        end
    end,getUrl(PLAYER_INFO_URL, playerId))    
    :start()
   
end

function MainScene:onEnter()
    audio.playMusic(GAME_MUSIC.hall)
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
