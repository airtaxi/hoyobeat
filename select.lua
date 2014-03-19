-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local bg = display.newImage("hobeat.png",360,510)
	bg.width = 720
	bg.height = 720+300
	local group = self.view
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	local idx_ = 1
	local saucer_font
	if "Win" == system.getInfo( "platformName" ) then
		basedir = system.ResourceDirectory
		saucer_font = "Saucer"
	elseif "Android" == system.getInfo( "platformName" ) then
		basedir = system.DocumentsDirectory
		saucer_font = "Saucer"
	end
	display.setStatusBar( display.HiddenStatusBar )
	local storyboard = require "storyboard"
	--display.setDefault( "background", 1, 1, 1 )
	-- local width = display.pixelWidth
	-- local height = display.pixelHeight
	-- local res = (height/1280)/(width/720)
	-- local options = 
	-- {
		-- text = "FPS: ",
		-- width = 1280,     --required for multi-line and alignment
		-- font = native.systemFontBold,   
		-- fontSize = 20
	-- }
	-- local fpsNow = display.newText(options)
	-- fpsNow:setFillColor(1,0.3,0.3)
	-- fpsNow.x,fpsNow.y =  640,10
	-- function updateFPS()
		-- fpsNow.text = tostring("FPS: "..display.fps.." Time: "..system.getTimer())	
	-- end
	-- --timer.performWithDelay( 10, updateFPS, -1)
	-- Runtime:addEventListener("enterFrame", updateFPS)
	-- display.newGroup():insert(fpsNow)
	local fps = require("fps")
	local performance = fps.PerformanceOutput.new();
	performance.group.x, performance.group.y = display.contentWidth/2, 30;
	performance.alpha = 0.6; -- So it doesn't get in the way of the rest of the scene
	-- local options =
	-- {
		-- channel=1,
		-- loops=-1,
		-- duration=75000,
	-- }
	-- audio.play(audio.loadSound("Music/Title.mp3"), options)
	-- audio.pause(1)-- Code to have Corona display the font names found
	--
	local fonts = native.getFontNames()

	count = 0

	-- Count the number of total fonts
	for i,fontname in ipairs(fonts) do
		count = count+1
	end

	print( "\rFont count = " .. count )

	local name = "saucer"     -- part of the Font name we are looking for

	name = string.lower( name )

	-- Display each font in the terminal console
	for i, fontname in ipairs(fonts) do
		j, k = string.find( string.lower( fontname ), name )

		if( j ~= nil ) then

			print( "fontname = " .. tostring( fontname ) )

		end
	end
	local lfs = require("lfs")

	local path = "/"
	local list = {}	
	local albumList = {}
	if "Win" == system.getInfo( "platformName" ) then
		path = system.pathForFile( "songs", system.ResourceDirectory)
		print(path)
		for dir in io.popen([[dir C:\Hoyobeat\songs /b /ad /b /ad]]):lines() do
			table.insert(list,"songs/"..dir)
		print(dir)
		end
	elseif "Android" == system.getInfo( "platformName" ) then
		path = "/sdcard/hoyobeat/song"
		for file in lfs.dir(path) do
		   --file is the current file or directory name
		   --print( "Found file: " .. file )
		   --TODO: check error -hoyo
			if(file ~= "." and file ~= "..") then
				table.insert(list,path.."/"..file)
			end
		end
		--print(path)
	end
	local album = {}
	local pathType = ""
	local idx = 0
	local right
	local left
	local level = display.newText({text="BASIC",x=360,y=720-40+300,font=saucer_font,fontSize=70,align="center"})
	level.level = "bsc"
	local rect = display.newImage("rect.png",level.x-5,level.y-10)
	rect.width = level.width+50
	rect.height = level.height+30
	
	local function touch(idx)
		local function file_exists(name)
		   local f=io.open(name,"r")
		   if f~=nil then io.close(f) return true else return false end
		end
		local base = ""
		if "Win" == system.getInfo( "platformName" ) then
			base = "C:\\Hoyobeat\\"
		end
		print(base..lfs.attributes(base..list[idx].."/pt_"..level.level..".jmt","mode"))
		if lfs.attributes(base..list[idx].."/pt_"..level.level..".jmt","mode") == "file" then
			local options =
			{
				params =
				{
					dir = list[idx],
					level = level.level
				}
			}
			print("changeScene")
			local albums = {}
			albums[1] = a1
			albums[2] = a2
			albums[3] = a3
			albums[4] = a4
			albums[5] = a5
			albums[6] = a6
			albums[7] = a7
			albums[8] = a8
			albums[9] = a9
			for k,v in pairs(albums) do
				if(v ~= nil) then
					v:removeSelf()
					albums[k] = nil
				end
			end
			right:removeSelf()
			left:removeSelf()
			level:removeSelf()
			storyboard.gotoScene( "play", options)
		end
	end
	local function draw(i)
		local albums = {}
		if(list[i] ~= nil) then
		a1 = display.newImage(list[i].."/".."pic.jpg",(720/3)*1 - 125,(1020/3)*1 - 200)
		end
		if(list[i+1] ~= nil) then
		a2 = display.newImage(list[i+1].."/".."pic.jpg",(720/3)*2 - 125,(1020/3)*1 - 200)
		end
		if(list[i+2] ~= nil) then
		a3 = display.newImage(list[i+2].."/".."pic.jpg",(720/3)*3 - 125,(1020/3)*1 - 200)
		end
		if(list[i+3] ~= nil) then
		a4 = display.newImage(list[i+3].."/".."pic.jpg",(720/3)*1 - 125,(1020/3)*2 - 200)
		end
		if(list[i+4] ~= nil) then
		a5 = display.newImage(list[i+4].."/".."pic.jpg",(720/3)*2 - 125,(1020/3)*2 - 200)
		end
		if(list[i+5] ~= nil) then
		a6 = display.newImage(list[i+5].."/".."pic.jpg",(720/3)*3 - 125,(1020/3)*2 - 200)
		end
		if(list[i+6] ~= nil) then
		a7 = display.newImage(list[i+6].."/".."pic.jpg",(720/3)*1 - 125,(1020/3)*3 - 200)
		end
		if(list[i+7] ~= nil) then
		a8 = display.newImage(list[i+7].."/".."pic.jpg",(720/3)*2 - 125,(1020/3)*3 - 200)
		end
		if(list[i+8] ~= nil) then
		a9 = display.newImage(list[i+8].."/".."pic.jpg",(720/3)*3 - 125,(1020/3)*3 - 200)
		end
		albums[1] = a1
		albums[2] = a2
		albums[3] = a3
		albums[4] = a4
		albums[5] = a5
		albums[6] = a6
		albums[7] = a7
		albums[8] = a8
		albums[9] = a9
		for k,v in pairs(albums) do
			if(v ~= nil) then
				v.width,v.height = 200,200
				v.alpha = 1
				print(i)
				print(k)
				v:addEventListener("touch",function() touch(i+(k-1)) end)
			end
		end
	end
	rect:addEventListener("touch",
	function(event)
		if(event.phase == "began") then
			if(level.text == "BASIC")  then
				level.text = "ADVENCED"
				level.level = "adv"
				rect.width = level.width+50
				rect.height = level.height+30
			elseif(level.text == "ADVENCED")  then
				level.text = "EXTREME"
				level.level = "ext"
				rect.width = level.width+50
				rect.height = level.height+30
			elseif(level.text == "EXTREME")  then
				level.text = "BASIC"
				level.level = "bsc"
				rect.width = level.width+50
				rect.height = level.height+30
			end
		end
	end)
	right = display.newImage("right.png",720-50,level.y)
	right.width , right.height = 100,100
	right:addEventListener("touch",
	function(event)
		if(event.phase == "began") then
			if(idx_ < #list) then
				local albums = {}
				albums[1] = a1
				albums[2] = a2
				albums[3] = a3
				albums[4] = a4
				albums[5] = a5
				albums[6] = a6
				albums[7] = a7
				albums[8] = a8
				albums[9] = a9
				for k,v in pairs(albums) do
					if(v ~= nil) then
						v:removeSelf()
						albums[k] = nil
					end
				end
				idx_ = idx_ + 9
				draw(idx_)
			end
		end
	end)
	left = display.newImage("left.png",50,level.y)
	left.width , left.height = 100,100
	left:addEventListener("touch",
	function(event)
		if(event.phase == "began") then
			if(idx_ - 9 > 0) then
				local albums = {}
				albums[1] = a1
				albums[2] = a2
				albums[3] = a3
				albums[4] = a4
				albums[5] = a5
				albums[6] = a6
				albums[7] = a7
				albums[8] = a8
				albums[9] = a9
				for k,v in pairs(albums) do
					if(v ~= nil) then
						v:removeSelf()
						albums[k] = nil
					end
				end
				idx_ = idx_ - 9
				draw(idx_)
			end
		end
	end)
	draw(idx_)

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene