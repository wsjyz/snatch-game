
require("config")
require("UrlConstants")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local MyApp = class("MyApp", cc.mvc.AppBase)
local HttpClient = import(".HttpClient")
local MessageCenter = import(".MessageCenter")

function MyApp:ctor()
    MyApp.super.ctor(self)
    --global properties
    --these values will be update in special scene
    self.me = {} --me , update when login
    self.currentLevel = 1 -- room level , default is 1
    self.currentAward = nil -- udpate when enter award room or  quick start
    self.currentRoomId = nil -- room id 
    self.topicList = {} -- random topicList
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    

    -- preload all music
    for k, v in pairs(GAME_MUSIC) do
        audio.preloadMusic(v)
    end
    -- preload all sounds
    for k, v in pairs(GAME_SOUND) do
        audio.preloadSound(v)
    end

    --check weather exists in server
    self:enterScene("MainScene")
end

function MyApp:loadTopicList(callback)
    HttpClient.new(function(topicList) 
        self.topicList = topicList
        if callback and type(callback) == "function" then
            callback() 
         end
    end ,getUrl(TOPIC_LIST_URL, self.currentLevel)):start()
end

function MyApp:initSocket()
    -- HttpClient.new(function(hall) 

        -- if hall then
        --     MessageCenter.new(hall.host,hall.port)
        -- else
        --     device.showAlert("提示", "服务器地址列表为空", {"确定"})
        -- end
    -- end,getUrl(HALL_INFO_URL))
    MessageCenter.new("127.0.0.1",9110)
end

-- scene transition
function MyApp:enterLoginScene()
   self:enterScene("LoginScene") 
end

function MyApp:enterChooseLevel()
    self.currentLevel = 1  -- default
	self:enterScene("ChooseLevelScene")
end

function MyApp:enterChooseAward(level)
    audio.playMusic(GAME_MUSIC.game)
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
