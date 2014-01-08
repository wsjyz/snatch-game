--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-18 16:37:54
--
local CommonModalView = class("CommonModalView")

local ZORDER = 3

function CommonModalView:ctor(needCloseBtn,bgPng)
	local bgPng =bgPng or "#floatbg_large.png"
	
	cc.GameObject.extend(self)
    self:addComponent("components.behavior.EventProtocol"):exportMethods()

    self.view = display.newScale9Sprite("#loginbg.png", display.cx, display.cy, CCSize(display.width,display.height))             

	self.view:setTouchEnabled(true)
	self.view:setTouchPriority(1)
	self.view:addTouchEventListener(function(event,x,y,preX,preY) 
		return true
	end)

	local bg = display.newSprite(bgPng,display.cx,display.cy):addTo(self.view,ZORDER)
	bg:setTouchEnabled(true)
	bg:setTouchPriority(1)
	bg:addTouchEventListener(function(event,x,y,preX,preY) 
		self:dispatchEvent({name = "onBackgroudTap"})
		return true
	end)
	self.bgSize_ = bg:getContentSize()

	local bgXOffSet = bg:getContentSize().width/2
	local bgYOffSet = bg:getContentSize().height/2

	self.bgXOffSet = bgXOffSet
	self.bgYOffSet = bgYOffSet

	local clsX = display.cx + bgXOffSet
	local clsY = display.cy + bgYOffSet

	if needCloseBtn == nil or not needCloseBtn == false then
	--close button
		local cls = cc.ui.UIPushButton.new({
				normal = "#close.png",
				pressed = "#close_active.png",
				disabled = "#close_active.png"
			})
			:onButtonClicked(function(e) 
				self:close()			
			end)
			:align(display.CENTER, clsX - 10, clsY - 10)
			:addTo(self.view,ZORDER)
	end
end

function CommonModalView:addContentChild(node,x,y,align)
	local x = x or node:getPositionX()
	local y = y or node:getPositionY()
	local align_ = align or display.CENTER
	node:align(align_, x, y):addTo(self.view,ZORDER)
end

function CommonModalView:close()
	self.view:removeFromParent()
	audio.playSound(GAME_SOUND["tapButton"])
	self:dispatchEvent({name = "onClose"})
end

function CommonModalView:getContentSize()
	return self.bgSize_
end

function CommonModalView:getView()
	return self.view
end

function CommonModalView:getOffsetPoint()
	return CCPoint(self.bgXOffSet, self.bgYOffSet)
end

return CommonModalView
