--
-- use socket tcp to send or receive message
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-03 23:21:34
--

--3rd socket tool
local socket = require(cc.PACKAGE_NAME .. ".net.SocketTCP")

local MessageCenter = class("MessageCenter", socket)

--定义Model需要监听此处定义的事件，然后再分发


--定义服务端的接口
MessageCenter.ENTER_ROOM_SERVICE = 1
MessageCenter.LEFT_ROOM_SERVICE = 2
MessageCenter.ON_READY_SERVICE = 3
MessageCenter.ANSWER_SERVICE = 4

--具体的服务接口，保持与上面定义的SERVICE的顺序一致
MessageCenter.SERVICES{
	"", --ENTER_ROOM_SERVICE 
	"",	--LEFT_ROOM_SERVICE
	"", --ON_READY_SERVICE
	""  --ANSWER_SERVICE
}


function MessageCenter:ctor(host,post,retryWhenConnnectFailed)
	MessageCenter.super.ctor(host,post,retryWhenConnnectFailed)
end

--serviceName  values must be one of MessageCenter.ENTER_ROOM_SERVICE,MessageCenter.LEFT_ROOM_SERVICE etc.
--data to be send to server
function MessageCenter:sendMessage(serviceName,data)
	assert(type(serviceName) == "number","Invalid type, must be number")
	assert(type(data) == "table","Invalid type,must be table")
	--todo pack data and call super.send
	

end




return MessageCenter