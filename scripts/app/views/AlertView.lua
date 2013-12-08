--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-08 11:59:00
--
local ModalLayer = import("..ModalLayer")
local AlertView = class("AlertView", ModalLayer)

--content : string or TTFLabel
--title : string or TTFLabel
function AlertView:ctor(content,title,onCloseListener)
	self.super:ctor()
	local bg = display.newSprite("#floatbg_large.png",display.cx,display.cy,size)
	:align(display.CENTER, display.cx, display.cy)
	:addTo(self)
	bg:setTouchPriority(1)
	
	bg:setTouchEnabled(true)
	--avoid lower layer response
	bg:addTouchEventListener(function(event,x,y,preX,preY) return true end)

	local bgXOffSet = bg:getContentSize().width/2
	local bgYOffSet = bg:getContentSize().height/2

	local clsX = display.cx + bgXOffSet
	local clsY = display.cy + bgYOffSet

	--close button
	local cls = cc.ui.UIPushButton.new({
			normal = "#close.png",
    		pressed = "#close_active.png",
    		disabled = "#close_active.png"
		})
		:onButtonClicked(function(e) 
			self:removeFromParent()
			if onCloseListener then onCloseListener(e) end
		end)
		:align(display.CENTER, clsX - 10, clsY - 10)
		:addTo(self)

	--get type function
	local function getTargetType(target)
		local t = type(target)
		if t == "userdata" then t = tolua.type(filename) end
		return t
	end

	--title
	local titleType = getTargetType(title)
	printf("title type is %s", titleType)
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
		titleLabel:align(display.TOP_CENTER, display.cx, clsY - 18)
				:addTo(self)
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
		contentLabel:align(display.CENTER, display.cx, display.cy)
		:addTo(self)
	end

end

return AlertView