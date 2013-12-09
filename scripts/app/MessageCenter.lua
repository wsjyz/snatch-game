--
-- use socket tcp to send or receive message
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-03 23:21:34
--

--3rd socket tool
local socket = import(".net.SocketTCP")

local MessageCenter = class("MessageCenter", socket)
local ByteArray  = import(".utils.ByteArray")

--定义Model需要监听此处定义的事件，然后再分发
--e.g addEventListener("ON_ENTER_ROOM_EVENT",handler)
MessageCenter.EVENTS = {
	ON_ENTER_ROOM_EVENT = "onEnterRoom"
}


--定义服务端的接口
MessageCenter.ENTER_ROOM_SERVICE = 1
MessageCenter.LEFT_ROOM_SERVICE = 2
MessageCenter.ON_READY_SERVICE = 3
MessageCenter.ANSWER_SERVICE = 4

--具体的服务接口，保持与上面定义的SERVICE的顺序一致
MessageCenter.SERVICES = {
	"playerService.enterRoom", --ENTER_ROOM_SERVICE 
	"",	--LEFT_ROOM_SERVICE
	"", --ON_READY_SERVICE
	""  --ANSWER_SERVICE
}


function MessageCenter:ctor(host,post,retryWhenConnnectFailed)
	MessageCenter.super:ctor(host,post,retryWhenConnnectFailed)
	self:addEventListener(socket.EVENT_CONNECTED, handler(self, self.onStatus))
	self:addEventListener(socket.EVENT_CLOSE, handler(self,self.onStatus))
	self:addEventListener(socket.EVENT_CLOSED, handler(self,self.onStatus))
	self:addEventListener(socket.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
	self:addEventListener(socket.EVENT_DATA, handler(self,self.onData))
	MessageCenter.super:connect()
end


function MessageCenter:onStatus(__event)
	echoInfo("socket status: %s", __event.name)
	echoInfo("isConnected: %s" , MessageCenter.super.isConnected)
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

function MessageCenter:sendMessage

--serviceCode  values must be one of MessageCenter.ENTER_ROOM_SERVICE,MessageCenter.LEFT_ROOM_SERVICE etc.
--data to be send to server
function MessageCenter:sendMessage_(serviceCode,data)
	assert(type(serviceCode) == "number","Invalid type, must be number")
	assert(type(data) == "table","Invalid type,must be table")

	local serviceName = self:getServiceName_(serviceCode)
	echoInfo("serviceName length = %d" , string.len(serviceName))
	local dataJson = json.encode(data)
	echoInfo("dataJson length = %d" , string.len(dataJson))
	local messageLength = string.format("%04d", 30 + string.len(dataJson))

	echoInfo("\n messageLength : %s \n ServiceName : %s \n Data : %s ", messageLength,serviceName,dataJson)

	local _ba = ByteArray.new(ByteArray.ENDIAN_BIG)
	_ba:writeInt(messageLength)
	_ba:writeStringBytes(serviceName)
	_ba:writeStringBytes(dataJson)

	MessageCenter.super:send(_ba:getPack())
	echoInfo("pack length : %d" , string.len(_ba:getPack()))
end

function MessageCenter:getServiceName_(serviceCode)
	local name = MessageCenter.SERVICES[serviceCode]
	if not name then 
		echoError("Can not find corresponding service by code %d", serviceCode)
	end
	return string.format("%30s", name)
end


return MessageCenter