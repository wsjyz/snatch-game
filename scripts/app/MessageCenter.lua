--
-- use socket tcp to send or receive message
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-03 23:21:34
--

--3rd socket tool
local SocketTCP = import(".net.SocketTCP")

local MessageCenter = class("MessageCenter")
local ByteArray  = import(".utils.ByteArray")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

--定义Model需要监听此处定义的事件，然后再分发
--e.g addEventListener("ON_ENTER_ROOM_EVENT",handler)
MessageCenter.EVENTS = {
	ON_ENTER_ROOM = "onEnterRoom",
	ON_OTHER_USER_COME_IN = "onOtherUserComeIn",
	ON_OTHER_USER_LEFT = "onOtherUserLeft",
	ON_PLAYER_READY = "onPlayerReady",
	ON_GAME_START = "onGameStart",
	ON_ANSWER_COMPLETE = "onAnswerComplete",
	ON_GAME_OVER = "onGameOver"
}

--定义服务端的接口
ENTER_ROOM_SERVICE = 1
LEFT_ROOM_SERVICE = 2
ON_READY_SERVICE = 3
ANSWER_SERVICE = 4

--具体的服务接口，保持与上面定义的SERVICE的顺序一致
MessageCenter.SERVICES = {
	"playerService.enterRoom", --ENTER_ROOM_SERVICE 
	"playerService.leftRoom",	--LEFT_ROOM_SERVICE
	"playerService.playerReady", --ON_READY_SERVICE
	"playerService.answerQuestion"  --ANSWER_SERVICE
}


function MessageCenter:ctor()
	--support event
	cc.GameObject.extend(self)
    self:addComponent("components.behavior.EventProtocol"):exportMethods()
    --todo http way get host & port
    if not self.socket_ then
		self.socket_ = SocketTCP.new("127.0.0.1",9110,true)
		--add event
		self.socket_:addEventListener(SocketTCP.EVENT_CONNECTED, handler(self, self.onStatus))
		self.socket_:addEventListener(SocketTCP.EVENT_CLOSE, handler(self,self.onStatus))
		self.socket_:addEventListener(SocketTCP.EVENT_CLOSED, handler(self,self.onStatus))
		self.socket_:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
		self.socket_:addEventListener(SocketTCP.EVENT_DATA, handler(self,self.onData))
	end

	if not self.socket_.isConnected then
		self.socket_:connect()
	end
	--set global
	sockettcp = self
end

function MessageCenter:isConnected()
	return self.socket_.isConnected
end

function MessageCenter:onStatus(__event)
	echoInfo("socket status: %s", __event.name)
end

function MessageCenter:onData(__event)
	echoInfo("socket status: %s, partial:%s", __event.name, ByteArray.toString(__event.data))
	local __ba = ByteArray.new(ByteArray.ENDIAN_BIG)
	__ba:writeBuf(__event.data)
	__ba:setPos(1)
	local headLength = __ba:readInt()
	local eventName = string.trim(__ba:readStringBytes(30)) 
	local params = json.decode(__ba:readStringBytes(headLength - 30))

	local _event = table.keyOfItem(MessageCenter.EVENTS, eventName)
	if _event then 
		self:dispatchEvent({name = _event, data = params})
	else
		echoInfo("Can not find event for name %s" , eventName)
	end
end

--serviceCode  values must be one of MessageCenter.ENTER_ROOM_SERVICE,MessageCenter.LEFT_ROOM_SERVICE etc.
--data to be send to server
function MessageCenter:sendMessage(serviceCode,data)

	assert(type(serviceCode) == "number","Invalid type, must be number")
	assert(type(data) == "table","Invalid type,must be table")

	local serviceName = self:getServiceName_(serviceCode)
	local dataJson = json.encode(data)
	local messageLength = string.format("%04d", 30 + string.len(dataJson))

	echoInfo("\n messageLength : %s \n ServiceName : %s \n Data : %s ", messageLength,serviceName,dataJson)

	local _ba = ByteArray.new(ByteArray.ENDIAN_BIG)
	_ba:writeInt(messageLength)
	_ba:writeStringBytes(serviceName)
	_ba:writeStringBytes(dataJson)

	self.socket_:send(_ba:getPack())

end

function MessageCenter:getServiceName_(serviceCode)
	local name = MessageCenter.SERVICES[serviceCode]
	if not name then 
		echoError("Can not find corresponding service by code %d", serviceCode)
	end
	return string.format("%30s", name)
end


return MessageCenter