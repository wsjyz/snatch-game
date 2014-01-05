--
-- Author: ivan.vigoss@gmail.com
-- Date: 2014-01-02 20:01:00
--
local ProgressBar = class("ProgressBar", function()
	return display.newNode()
end)

function ProgressBar:ctor(percent,text,x,y)
	local x = x or display.cx
	local y = y or display.cy
	self.progress_bg = display.newSprite("#progress_bg.png"):pos(x, y):addTo(self)
   	self.progress = display.newProgressTimer("#progress_fg.png", display.PROGRESS_TIMER_BAR)
   	:pos(x, y)
   	:addTo(self)
    
   	self.progress:setMidpoint(ccp(0,0))
   	self.progress:setBarChangeRate(ccp(1,0))
   	self.progress:setPercentage(percent)

   	if text and type(text) == "string" then
	   	self.label = ui.newTTFLabel({
	   			text = text,
	   			size = 22
		})
		:pos(x, y)
		:addTo(self)	
	end
end

function ProgressBar:setPercentage(fPercentage)
	self.progress:setPercentage(fPercentage)
	return self
end



return ProgressBar