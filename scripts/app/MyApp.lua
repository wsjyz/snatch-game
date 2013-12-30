
require("config")
require("UrlConstants")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local MyApp = class("MyApp", cc.mvc.AppBase)
local HttpClient = import(".HttpClient")

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
    HttpClient.new(function(player) 
        if player then
            self.me = player
            self:enterChooseLevel()
        else
            self:enterLoginScene()
        end
    end,getUrl(PLAYER_INFO_URL, device.getOpenUDID()))
    :start()

end

function MyApp:loadTopicList(callback)
    HttpClient.new(function(topicList) 
        printf("load topicList ,as follows : %s", json.encode(topicList))
        self.topicList = topicList
        if callback then callback() end
    end ,getUrl(TOPIC_LIST_URL, self.currentLevel)):start()
end

-- scene transition
function MyApp:enterLoginScene()
   self:enterScene("LoginScene") 
end

function MyApp:enterChooseLevel()
    audio.playMusic(GAME_MUSIC.hall)
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
