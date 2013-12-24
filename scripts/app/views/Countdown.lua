--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-24 13:42:20
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local Countdown = class("Countdown", function()
	local button = cc.ui.UIPushButton.new("#timer_bg.png")
	button:setButtonEnabled(false)
	return button
end)

function Countdown:ctor(from,warning,step)
	self.from = from 
	self.warning = warning or 5
	self.step = step or 1
	self.currentNumber = from
	
	self:updateLabel()
end

function Countdown:start()
	self.scheduler = scheduler.scheduleGlobal(function() 
		self.currentNumber = self.currentNumber - self.step
		if self.currentNumber <= 0 then
			self:pause()
		end
		self:updateLabel()

	end, 1)
end

function Countdown:pause()
	if self.scheduler then
		scheduler.unscheduleGlobal(self.scheduler)
	end
end

function Countdown:reset()
	self:setButtonImage("disabled", "#timer_bg.png")
	self.currentNumber = self.from
	return self
end

function Countdown:getTimeCost()
	return self.from - self.currentNumber
end

function Countdown:updateLabel()
	if self.currentNumber < 0 then self.currentNumber =0 end
	local text = string.format("00 : %02d", self.currentNumber)
	local textLabel
	if self.currentNumber > self.warning then
		textLabel = ui.newTTFLabel({
			text = text,		
			color = ccc3(27,70,1)
		})
	else
		--set button image only once 
		if self.currentNumber == self.warning then
			self:setButtonImage("disabled", "#timer_bg_warning.png")
		end	
		textLabel = ui.newTTFLabel({
			text = text,		
			color = ccc3(69,0,0)
		})

	end

	self:setButtonLabel("normal", textLabel)
end


return Countdown