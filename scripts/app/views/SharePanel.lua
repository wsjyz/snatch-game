--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-29 11:15:33
--
local SharePanel = class("SharePanel", function()
	return display.newNode()
end)

function SharePanel:ctor()
	self.modalLayer = app:createView("CommonModalView", false)

	local padding = 60

	local wechat = cc.ui.UIPushButton.new("#weixin.png"):onButtonClicked(function(e) 
			printf("share from wechat")
		end)

	local sina = cc.ui.UIPushButton.new("#sina.png"):onButtonClicked(function(e) 
		printf("share from sina")
		end)

	local txweibo = cc.ui.UIPushButton.new("#tenxun.png"):onButtonClicked(function(e) 
		printf("share from tenxun")
		end)

	local pengyou = cc.ui.UIPushButton.new("#friend.png"):onButtonClicked(function(e) 
		printf("share from pengyou")
		end)

	self.modalLayer:addContentChild(wechat, display.cx - padding * 2 , display.cy)
	self.modalLayer:addContentChild(sina, display.cx - padding, display.cy)
	self.modalLayer:addContentChild(txweibo, display.cx + padding, display.cy)
	self:modalLayer:addContentChild(pengyou, display.cx + padding * 2, display.cy)

	self:addChild(self.modalLayer:getView())
end

return SharePanel