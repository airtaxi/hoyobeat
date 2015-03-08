----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
function scene:create( event )
	composer.removeScene("play")
	-- local group = self.view
	lastonline = event.params.online2
	lastkey = event.params.key2;
	lastfolder = event.params.folder2
	lastdiff = event.params.diff2
	lastclap = event.params.clap2
	lastlevel = event.params.level2
	lastdir = event.params.dir2
	lastdelay = event.params.delay2
end
function scene:show( event) 
	if(event.phase == "did") then	
		local options = 
		{
			params=
			{
				scene = "play2",
				online = lastonline,
				key = lastkey,
				level = lastlevel,
				dir = lastdir,
				delay = lastdelay,
				folder = lastfolder,
				diff = lastdiff,
				clap = lastclap,
			}
		}
		print(lastlevel)
		print(lastdir)
		print("PLAY2")
		composer.gotoScene("play",options)
	end
end
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )
-- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "show", scene )
return scene