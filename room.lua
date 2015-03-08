API_KEY = "de82d6402be62aaf0ac6cefd8e826c04cbe1a1d6d9b197789395eea60325b394"
SECRET_KEY = "70d87a19800a0982421d3507613f29cb299a24bc78eb28fdc377292aababc879"
STATIC_ROOM_ID = "1523973449"

appWarpClient = require "AppWarp.WarpClient"
appWarpClient.initialize(API_KEY, SECRET_KEY)
local function gameLoop(event)
  appWarpClient.Loop()
end
Runtime:addEventListener("enterFrame", gameLoop)
local composer = require( "composer" )
local scene = composer.newScene()
function scene:create( event )	
	appWarpClient.connectWithUserName(tostring(os.clock()))
end

function scene:show( event )
	
	local screenGroup = self.view
end
function scene:hide( event )

end


function scene:destroy( event )
	local group = self.view
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene