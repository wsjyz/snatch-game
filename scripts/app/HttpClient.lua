--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-05 22:07:13
--
local HttpClient = class("HttpClient")


function HttpClient:ctor(callback,url,params)
	self.listener = callback
	local method = "GET"
	if params and type(params) == "table" then 
		method = "POST" 
	end

	self.request = network.createHTTPRequest(function (event)
			self:onResponse(event)
		end, url, method)
	if method == "POST" then
		-- not support table array
		for key,value in pairs(params) do
			self.request:addPOSTValue(key, value)
		end
	end
	
end

function HttpClient:onResponse(event)
	local request = event.request
	echoInfo("quest state onResponse() %d" ,request:getState())
    if self.onRequestFailedListener__ and request:getState() == kCCHTTPRequestStateFailed then
    	self.onRequestFailedListener__(event)
    end

    if event.name == "completed" then
    	echoInfo("REQUEST getResponseStatusCode() %d",request:getResponseStatusCode())
        if request:getResponseStatusCode() ~= 200 then
        else
            echoInfo("REQUEST   getResponseDataLength() = %d", request:getResponseDataLength())
            echoInfo("REQUEST  getResponseData() =\n%s",  request:getResponseData())
            local result = json.decode(request:getResponseString())
            
            self.listener(result)
        end
    else
        echoInfo("REQUEST getErrorCode() = %d, getErrorMessage() = %s", request:getErrorCode(), request:getErrorMessage())
    end

end

function HttpClient:onRequestInProgress(callback)
	assert(type(callback) == "function","callback must be function")

	self.onRequestInProgressListener__ = callback
	return self
end

function HttpClient:onRequestFailed( callback )
	assert(type(callback) == "function","callback must be function")
	self.onRequestFailedListener__ = callback
	return self
end

function HttpClient:setTimeout(timeout)
	if	type(timeout) ~= "number" then timeout = 3000 end
	self.request:setTimeout(timeout)
	return self
end

function HttpClient:start()
	self.request:start()
	if self.onRequestInProgressListener__ and self.request:getState() == kCCHTTPRequestStateInProgress then
		self.onRequestInProgressListener__({request = self.request})
	end
end

return HttpClient