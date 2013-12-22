
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    
    self:enterScene("LoginScene")
end

function MyApp:enterChooseLevel()
	self:enterScene("ChooseLevelScene")
end

function MyApp:enterPlayerWaiting()
	self:enterScene("PlayerWaitingScene")
end

function MyApp:enterGameScene()
	self:enterScene("GameScene")
end

function MyApp:enterProfileCenter()
	self:enterScene("ProfileCenterScene")
end

function MyApp:enterWinRankScene()
	self:enterScene("WinRankScene")
end

return MyApp
