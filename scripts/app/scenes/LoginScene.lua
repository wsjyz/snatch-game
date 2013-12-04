--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-01 12:42:12
--
local bgLayer = import("..views.CommonBackground").new()
local loginForm = import("..views.LoginForm").new()

local LoginScene = class("LoginScene", function ()
	return display.newScene("LoginScene")
end)

function LoginScene:ctor()	
	-- add bg
	self:addChild(bgLayer)
	-- add form
	self:addChild(loginForm)

end

return LoginScene