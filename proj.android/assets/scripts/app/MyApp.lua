
require("config")
require("UrlConstants")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

lfs       = require("lfs")

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

function MyApp:initSocket(callback)
    HttpClient.new(function(hall) 
        echoInfo("hall info %s,type %s", json.encode(hall),type(hall))
        if hall then
            MessageCenter.new(hall.host,hall.port)
            if callback then callback() end
        else
            device.showAlert("提示", "服务器地址列表为空", {"确定"})
        end
        end,getUrl(HALL_INFO_URL)):start()
end

function MyApp:loadImageAsync(url,callback)
    local dirinfo = function (dirpath)
        local pos = string.len(dirpath)
        if string.byte(dirpath,pos) == 47 then
            dirpath = string.sub(dirpath, 1, pos - 1)
        end
        while pos > 0 do
            local b = string.byte(dirpath,pos)
            if b == 47 and pos ~= string.len(dirpath) then break end
            pos = pos - 1
        end
        local basedir_name = string.sub(dirpath, 1, pos)
        local dirname = string.sub(dirpath, pos + 1)
        echoInfo("========%s %s", basedir_name,dirname)
        return basedir_name,dirname
    end
    
    local mkdirs = function(path)
        local p = path
        local t = {}

        while lfs.chdir(p) == nil do
            local basedir_name,dirname = dirinfo(p)
            table.insert(t,dirname)
            p = basedir_name 
        end

        local i = table.nums(t)
        while i > 0  do
            echoInfo("====add %s to %s", t[i] , lfs.currentdir())
            lfs.mkdir(t[i])
            local r,m = lfs.chdir(lfs.currentdir() .. device.directorySeparator .. t[i])
            if r == nil then break end
            i = i -1
        end

    end

    local fileinfo = function(path)
        local filename = crypto.md5(path)
        local fileinfo = io.pathinfo(path)
        local basePath = device.writablePath .. "res/cache/"
        local realpath = basePath .. filename .. fileinfo.extname

        local r,m = lfs.chdir(basePath)
        if r == nil then
            mkdirs(basePath)
        end

        return io.exists(realpath),realpath,filename .. fileinfo.extname
    end

    local exists,filepath,filename = fileinfo(url)
    if exists then
        display.addImageAsync(filepath, callback)
    else
        HttpClient.new(function(content) 
            local saveResult = io.writefile(filepath, content)
            echoInfo("writefile to %s , result %s", filepath ,saveResult)
            if saveResult then
                display.addImageAsync(filepath, callback)
            end
        end,url,nil,"byte"):start() 
    end
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
