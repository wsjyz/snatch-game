--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-01 13:38:51
--
local LoginForm = class("LoginForm", function()
	return display.newLayer()
end)

local httpClient = import("..HttpClient")
local alert = import(".AlertView")

LOGIN_FORM_TAG = 2
LOGIN_FORM_ZORDER = 1

LoginForm.RADIO_BUTTON_IMAGES = {
    off = "#radio_off.png",
    off_pressed = "#radio_off.png", 
    off_disabled = "#radio_off.png",
    on = "#radio_on.png",
    on_pressed = "#radio_on.png",
    on_disabled = "#radio_on.png",
}

function LoginForm:ctor()
	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()	
	--add bg
	local bg = display.newSprite("#loginbg.png", display.cx, display.cy - 50):addTo(self)
	local bgWidth = bg:getContentSize().width
	local bgHeight = bg:getContentSize().height
	self.male = 1 -- set default male
	--add radio
	local sexGroup = cc.ui.UICheckBoxButtonGroup.new(display.LEFT_TO_RIGHT)
	:addButton(cc.ui.UICheckBoxButton.new(LoginForm.RADIO_BUTTON_IMAGES)
			:setButtonLabel(cc.ui.UILabel.new({text = "男", color = display.COLOR_WHITE}))
            :setButtonLabelOffset(20, 0)
            :setButtonSelected(true)
            :align(display.LEFT_CENTER))
	:addButton(cc.ui.UICheckBoxButton.new(LoginForm.RADIO_BUTTON_IMAGES)
			:setButtonLabel(cc.ui.UILabel.new({text = "女", color = display.COLOR_WHITE}))
            :setButtonLabelOffset(20, 0)
            :align(display.LEFT_CENTER))
	:setButtonsLayoutMargin(10, 10, 10, 10)
	:onButtonSelectChanged(function(event)
            printf("Option %d selected, Option %d unselected", event.selected, event.last)
            if event.selected ~= 1 then self.male = 0 else self.male = 1 end 
        end)
    :align(display.CENTER_LEFT, display.cx - bgWidth/2 + 150, display.cy + 20)
    :addTo(self)

	--add editbox 
	self.loginName = ui.newEditBox({
		image = "#input.png",
		size = cc.size(330,50),
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
	:align(display.CENTER_LEFT, display.cx - bgWidth/2 + 150, display.cy)
	:addTo(self)
	self.loginName:setFontColor(display.COLOR_BLACK)
	-- self.loginName:setPlaceHolder("请输入用户名")
	self.loginName:setPlaceholderFontColor(ccc3(128, 128, 128))
	self.loginName:setInputMode(kEditBoxInputModeSingleLine)

	--add random button
	cc.ui.UIPushButton.new({
			normal = "#randombtn.png",
    		pressed = "#randombtn_active.png",
    		disabled = "#randombtn_active.png"
		})
	 :onButtonClicked(function(e)
			--todo generate random name from server
			local button = e.target
			
			httpClient.new(function (data)
				self.loginName:setText(data)
			 end, getUrl(RANDOM_NAME_URL))
			:onRequestFailed(function(requestEvent)
					self.loginName:hide()
					alert.new("连接失败",nil,function(closeEvent)
							self.loginName:show()
					  end ):addTo(self)
				end)
			:start()

		end)
	 :align(display.CENTER_RIGHT, display.cx + bgWidth/2 - 150, display.cy)
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
			local loginName = self.loginName:getText()
			if loginName and string.trim(loginName) then
				httpClient.new(function(event)
					--todo 
					end,
					getUrl(RIGESTER_URL),
					{
						playerId = device.getOpenUDID(),
						playerName = loginName,
						male = self.male
					}):start()

			end	
			app:enterChooseLevel()
	end)
	:align(display.TOP_CENTER, display.cx, display.cy - 70)
	:addTo(self)
	
 	self:setZOrder(LOGIN_FORM_ZORDER)
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