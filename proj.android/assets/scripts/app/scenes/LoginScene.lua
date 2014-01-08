--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-01 12:42:12
--

local LoginScene = class("LoginScene", function ()
	return display.newScene("LoginScene")
end)

function LoginScene:ctor()	
	-- add bg
	self:addChild(app:createView("CommonBackground"))
	-- add form
	self:addChild(app:createView("LoginForm"))

end

return LoginScene