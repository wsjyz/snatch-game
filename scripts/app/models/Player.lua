--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-03 23:23:13
--
local Player = class("Player", cc.mvc.ModelBase)


--定义事件

--定义属性
Player.schema = clone(cc.mvc.ModelBase.schema)
Player.schema["playerId"] = {"string",device.getOpenUDID()} --default value is device id 
Player.schema["playerName"] = {"string"}
Player.schema["male"] = {"number" , 1}
Player.schema["experience"] = {"number" , 0} --经验值

function Player:ctor(properties)
	Player.super.ctor(properties)
end


return Player