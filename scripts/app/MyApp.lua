
require("config")
require("UrlConstants")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    --global properties
    --these values will be update in special scene
    self.me = {} --me , update when login
    self.currentLevel = 1 -- room level , default is 1
    self.currentRoomId = nil -- udpate when enter room or quick start
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    
    self:enterScene("LoginScene")
end

-- scene transition
function MyApp:enterChooseLevel()
	self:enterScene("ChooseLevelScene")
end

function MyApp:enterChooseAward(level)
    self.currentLevel = level
	local args = {level}
	self:enterScene("RoomListScene", args)
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

function MyApp:enterQuizScene()
	self:enterScene("QuizScene")
end

return MyApp
