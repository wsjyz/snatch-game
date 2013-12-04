--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-01 13:38:51
--
local LoginForm = class("LoginForm", function()
	return display.newLayer()
end)

LOGIN_FORM_TAG = 2
LOGIN_FORM_ZORDER = 1

function LoginForm:ctor()
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()	
	--add bg
	local bg = display.newSprite("#loginbg.png", display.cx, display.cy - 50):addTo(self)
	local bgWidth = bg:getContentSize().width
	local bgHeight = bg:getContentSize().height
	print(bgWidth,bgHeight)
	--add radio

	--add editbox 
	local loginNameInput = ui.newEditBox({
		image = "#input.png",
		size = cc.size(700,110),
        listener = function(event, editbox)
            if event == "began" then
                self:onEditBoxBegan(editbox)
            elseif event == "ended" then
                self:onEditBoxEnded(editbox)
            elseif event == "return" then
                self:onEditBoxReturn(editbox)
            elseif event == "changed" then
                self:onEditBoxChanged(editbox)
            else
                printf("EditBox event %s", tostring(event))
            end
        end
		})
	:align(display.CENTER_RIGHT, display.cx + 180, display.cy)
	loginNameInput:setFontSize(100)
	loginNameInput:setFontColor(display.COLOR_BLACK)
	
	loginNameInput:setPlaceHolder("请输入用户名")
	loginNameInput:setPlaceholderFontSize(10)
	loginNameInput:setPlaceholderFontColor(ccc3(128, 128, 128))
	loginNameInput:setInputMode(kEditBoxInputModeSingleLine)

	self:addChild(loginNameInput)
	--add random button
	 cc.ui.UIPushButton.new({
			normal = "#randombtn.png",
    		pressed = "#randombtn_active.png",
    		disabled = "#randombtn_active.png"
		})
	 :onButtonClicked(function(event)
			--todo generate random name from server
			local button = event.target

		end)
	 :align(display.CENTER_LEFT, display.cx + 200, display.cy)
	 :addTo(self)

	--add login button
	cc.ui.UIPushButton.new({
			normal = "#loginbtn.png",
    		pressed = "#loginbtn_active.png",
    		disabled = "#loginbtn_active.png"
		})
	:onButtonClicked(function(event) 
		--todo : get device id from luaj or luaoc
		--todo : login with given name 
		local button = event.target
		local loginName = loginNameInput:getText()
		local http = network.createHTTPRequest(function (data) 
			print(data.status) 
			end , "http://www.baidu.com", "GET")
		end)
		:align(display.TOP_CENTER, display.cx, display.cy - 100)
		:addTo(self)

end


function LoginForm:onEditBoxBegan(editbox)
    printf("editBox1 event began : text = %s", editbox:getText())
end

function LoginForm:onEditBoxEnded(editbox)
    printf("editBox1 event ended : %s", editbox:getText())
end

function LoginForm:onEditBoxReturn(editbox)
    printf("editBox1 event return : %s", editbox:getText())
end

function LoginForm:onEditBoxChanged(editbox)
    printf("editBox1 event changed : %s", editbox:getText())
end

function LoginForm:onEnter()
	self:setTouchEnabled(true)
end

function LoginForm:onExit()
	self:removeAllEventListeners()
end

return LoginForm