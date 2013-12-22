--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-08 11:59:00
--
local CommonModalView = import(".CommonModalView")
local AlertView = class("AlertView", function() 
	return display.newNode()
end)

--content : string or TTFLabel
--title : string or TTFLabel
function AlertView:ctor(content,title,onCloseListener)
	local modalLayer = CommonModalView.new()
	local bgYOffSet = modalLayer:getOffsetPoint().y
	--get type function
	local function getTargetType(target)
		local t = type(target)
		if t == "userdata" then t = tolua.type(filename) end
		return t
	end

	--title
	local titleType = getTargetType(title)
	
	local titleLabel
	if titleType == "string" or titleType == "nil" then
		titleLabel = ui.newTTFLabel({
			text = title or "提示",
			size = 36
			})
			
	elseif titleType == "CCLabelTTF" then
		titleLabel = title
	else
		echoError("error type title, use default title")
		titleLabel = ui.newTTFLabel({
			text = "提示",
			size = 36
		})
	end
	if titleLabel then
		modalLayer:addContentChild(titleLabel, display.cx, display.cy + bgYOffSet - 18,display.TOP_CENTER)
	end

	--content
	local contentType = getTargetType(content)
	printf("content type is %s", contentType)
	local contentLabel
	if contentType =="string" or contentType =="nil" then
		contentLabel = ui.newTTFLabel({
			text = content or "empty content"
			})
	elseif contentType == "CCLabelTTF" then
		contentLabel = content
	else
		echoError("error type content, use default content")
		contentLabel =  ui.newTTFLabel({
			text = "empty content"
		})
	end
	if contentLabel then
		modalLayer:addContentChild(contentLabel)
	end

	if onCloseListener then 
		modalLayer:addEventListener("onClose", function() 
			onCloseListener()
		end)
	end

	self:addChild(modalLayer:getView())
end

return AlertView