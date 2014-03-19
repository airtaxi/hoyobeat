----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

system.activate( "multitouch" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local level
local pdir
local saucer_font
local basedir = system.DocumentsDirectory
if "Win" == system.getInfo( "platformName" ) then
	basedir = system.ResourceDirectory
	saucer_font = "Saucer"
elseif "Android" == system.getInfo( "platformName" ) then
	basedir = system.DocumentsDirectory
	saucer_font = "Saucer"
end

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
	storyboard.removeScene("select")
	local group = self.view
	local options =
	{
		channel=4,
		loops=0,
	}
	level = event.params.level
	if "Win" == system.getInfo( "platformName" ) then
		--audio.play(audio.loadSound("song/theoryofeternity/song.mp3",basedir), options)
		pdir = "C:\\Hoyobeat\\"..event.params.dir
		audio.play(audio.loadSound(pdir.."\\song.mp3"), options)
	elseif "Android" == system.getInfo( "platformName" ) then
		audio.play(audio.loadSound(event.params.dir.."/song.mp3"), options)
		pdir = event.params.dir
	end
	audio.pause(4)
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	local bg = display.newImage("background.png",360,510)
	bg.width = 720
	bg.height = 720+300
	local bg = display.newImage("play/bg_dark.png",360,720-60)
	bg.width,bg.height = 720,720
	timer.performWithDelay(1000,
	function()
		transition.to(bg,{time=70,xScale=1.5,yScale=1.5,onComplete=
		function()
			transition.to(bg,{time=150,xScale=1,yScale=1})
		end,1})
	end,-1)
	local i_upper = display.newImage("upper.png",360,150)
	i_upper.width,i_upper.height = 720,300
	print(saucer_font)
	local nCombo = 0
	local score = 0
	local count
	local combo = display.newText({text="",x=360,y=720-60-150,font=saucer_font,fontSize=350,align="center"})
	combo.alpha = 0.7
	local panel = display.newImage("panel_4x4.png",360,720-60)
	panel.width,panel.height = 720,720
	local data = ""
	-- local firstLoadedFile = io.open(system.pathForFile( "song/theoryofeternity/pt_adv.jmt", system.ResourceDirectory))
	-- data = firstLoadedFile:read("*a")
	-- firstLoadedFile:close()
	-- print(data)
	local coords = {}
	local coords_ = {}
	coords[1],coords_[1] = (720/4)*1-90,300+(720/4)*1-90
	coords[2],coords_[2] = (720/4)*2-90,300+(720/4)*1-90
	coords[3],coords_[3] = (720/4)*3-90,300+(720/4)*1-90
	coords[4],coords_[4] = (720/4)*4-90,300+(720/4)*1-90
	coords[5],coords_[5] = (720/4)*1-90,300+(720/4)*2-90
	coords[6],coords_[6] = (720/4)*2-90,300+(720/4)*2-90
	coords[7],coords_[7] = (720/4)*3-90,300+(720/4)*2-90
	coords[8],coords_[8] = (720/4)*4-90,300+(720/4)*2-90
	coords[9],coords_[9] = (720/4)*1-90,300+(720/4)*3-90
	coords[10],coords_[10] = (720/4)*2-90,300+(720/4)*3-90
	coords[11],coords_[11] = (720/4)*3-90,300+(720/4)*3-90
	coords[12],coords_[12] = (720/4)*4-90,300+(720/4)*3-90
	coords[13],coords_[13] = (720/4)*1-90,300+(720/4)*4-90
	coords[14],coords_[14] = (720/4)*2-90,300+(720/4)*4-90
	coords[15],coords_[15] = (720/4)*3-90,300+(720/4)*4-90
	coords[16],coords_[16] = (720/4)*4-90,300+(720/4)*4-90
	local entities = {}
	local thunder = graphics.newImageSheet("marker/base.png", { width=512/5, height=512/5, numFrames=25,sheetContentWidth = 512,sheetContentHeight = 512})
	local good = graphics.newImageSheet("marker/good.png", { width=512/4, height=512/4, numFrames=16,sheetContentWidth = 512,sheetContentHeight = 512})
	local notgood = graphics.newImageSheet("marker/notgood.png", { width=512/4, height=512/4, numFrames=16,sheetContentWidth = 512,sheetContentHeight = 512})
	local great = graphics.newImageSheet("marker/great.png", { width=512/4, height=512/4, numFrames=16,sheetContentWidth = 512,sheetContentHeight = 512})
	local perfect = graphics.newImageSheet("marker/perfect.png", { width=512/4, height=512/4, numFrames=16,sheetContentWidth = 512,sheetContentHeight = 512})
	for k,v in pairs(coords) do
		entities[k] = display.newSprite( thunder, {name="base",start=1,count=25,time=950,loopCount=1} )
		entities[k].x,entities[k].y = coords[k],coords_[k]
		entities[k].xScale,entities[k].yScale = 1.6,1.6
		entities[k]:setSequence( "base" )
	end
	local fp1,dummy1 = data:find("#2")
	local fp2,dummy1 = data:find("#3")
	local fp3,dummy1 = data:find("#4")
	local fp4,dummy1 = data:find("#5")
	local fp5,dummy1 = data:find("#6")
	local fp6,dummy1 = data:find("#7")
	local fp7,dummy1 = data:find("#8")
	local fp8,dummy1 = data:find("#9")
	local fp9,dummy1 = data:find("#10")
	local fp10,dummy1 = data:find("#11")
	local fp11,dummy1 = data:find("#12")
	local fp12,dummy1 = data:find("#13")
	local fp13,dummy1 = data:find("#14")
	local fp14,dummy1 = data:find("#15")
	local fp15,dummy1 = data:find("#16")
	local data1 = {}
	local indexes = {1,fp1,fp2,fp3,fp4,fp5,fp6,fp7,fp8,fp9,fp10,fp11,fp12,fp13,fp14,fp15}
	local timers = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	local function updateCombo()
		if(nCombo >= 5) then
			combo.text = "\n"..nCombo
		else
			combo.text = ""
		end
	end
	-- local function readLine1()
			-- if(indexes[1] ~= nil) then
				-- local currentIndex = indexes[1]
				-- if(currentIndex ~= nil) then
					-- currentIndex = currentIndex - 1
				-- end
				-- local nextIndex = data:find("#"..tostring(index),indexes[1] + 1)
				-- if(nextIndex ~= nil) then
					-- nextIndex = nextIndex - 1
				-- end
				-- local line = string.sub(data,currentIndex,nextIndex)
				-- print(line)
				-- indexes[index] = nextIndex + 1
			-- end
	-- end
	-- readLine1()
	
	-- entities[1] = p1_1
	-- entities[2] = p1_2
	-- entities[3] = p1_3
	-- entities[4] = p1_4
	-- entities[5] = p2_1
	-- entities[6] = p2_2
	-- entities[7] = p2_3
	-- entities[8] = p2_4
	-- entities[9] = p3_1
	-- entities[10] = p3_2
	-- entities[11] = p3_3
	-- entities[12] = p3_4
	-- entities[13] = p4_1
	-- entities[14] = p4_2
	-- entities[15] = p4_3
	-- entities[16] = p4_4
	--print(system.pathForFile( "", basedir))
	local function touch(index,event)
		if((event.phase == "began" or event.phase == "moved")) then
			local entity = entities[index]
			if(entity ~= nil and entity.frame ~= nil) then
				if(entity.frame <= 5 and entity.frame ~= 1) then
					nCombo = 0
					local s_notgood = display.newSprite( notgood, {name="pj",start=1,count=16,time=500,loopCount=1} )
					s_notgood.x,s_notgood.y = entities[index].x,entities[index].y
					s_notgood.xScale,s_notgood.yScale = 1.3,1.3
					s_notgood:setSequence( "pj" )
					s_notgood:play()
					timer.performWithDelay(500,
					function() 
						s_notgood:removeSelf()
					end,1)
					updateCombo()
				elseif(entity.frame <= 10 and entity.frame ~= 1) then
					nCombo = nCombo + 1
					local s_good = display.newSprite( good, {name="pj",start=1,count=16,time=500,loopCount=1} )
					s_good.x,s_good.y = entities[index].x,entities[index].y
					s_good.xScale,s_good.yScale = 1.3,1.3
					s_good:setSequence( "pj" )
					s_good:play()
					timer.performWithDelay(500,
					function() 
						s_good:removeSelf()
					end,1)
					updateCombo()
				elseif(entity.frame <= 15 and entity.frame ~= 1) then
					nCombo = nCombo + 1
					local s_great = display.newSprite( great, {name="pj",start=1,count=16,time=500,loopCount=1} )
					s_great.x,s_great.y = entities[index].x,entities[index].y
					s_great.xScale,s_great.yScale = 1.3,1.3
					s_great:setSequence( "pj" )
					s_great:play()
					timer.performWithDelay(500,
					function() 
						s_great:removeSelf()
					end,1)
					updateCombo()
				elseif(entity.frame <= 20 and entity.frame ~= 1) then
					nCombo = nCombo + 1
					local s_perfect = display.newSprite( perfect, {name="pj",start=1,count=16,time=500,loopCount=1} )
					s_perfect.x,s_perfect.y = entities[index].x,entities[index].y
					s_perfect.xScale,s_perfect.yScale = 1.3,1.3
					s_perfect:setSequence( "pj" )
					s_perfect:play()
					timer.performWithDelay(500,
					function() 
						s_perfect:removeSelf()
					end,1)
					updateCombo()
				elseif(entity.frame < 25 and entity.frame ~= 1) then
					nCombo = 0
					local s_notgood = display.newSprite( notgood, {name="pj",start=1,count=16,time=500,loopCount=1} )
					s_notgood.x,s_notgood.y = entities[index].x,entities[index].y
					s_notgood.xScale,s_notgood.yScale = 1.3,1.3
					s_notgood:setSequence( "pj" )
					s_notgood:play()
					timer.performWithDelay(500,
					function() 
						s_notgood:removeSelf()
					end,1)
					updateCombo()
				end	
				--print(entity.frame)
				entity:pause()
				entity:removeSelf()
				entities[index] = nil
			end
		end
	end
	local jmtdir = system.DocumentsDirectory
	if "Win" == system.getInfo( "platformName" ) then
		jmtdir = pdir.."\\pt_"..level..".jmt"
	elseif "Android" == system.getInfo( "platformName" ) then
		jmtdir = pdir.."/pt_"..level..".jmt"
	end
	
	for line in io.lines(jmtdir) do
		--table.insert(noteArray,line)
		--print(line)
		local first = line:find(".",1,true)
		local index = tonumber(line:sub(2,first-1))
		-- print(line:sub(2,first-1))
		local last = line:find(".",first+1,true)
		if(last == nil) then
			last = line:len()
		end
		-- print(last)
		local ltime = tonumber(line:sub(first+1,last))
		-- print(first.."/"..last..";"..line:sub(first+1,last))
		-- print(index..":"..ltime)
		timer.performWithDelay(ltime,function()
			--print(index.."!!!!!")
			entities[index] = display.newSprite( thunder, {name="base",start=1,count=25,time=950,loopCount=1} )
			entities[index].x,entities[index].y = coords[index],coords_[index]
			entities[index].xScale,entities[index].yScale = 1.6,1.6
			entities[index]:setSequence( "base" )
			entities[index]:addEventListener("touch",
			function(event)
				touch(index,event)
			end)
			entities[index]:play()
		end,1)
		timer.performWithDelay(ltime+1000,function()
			--print(index.."!!!!!")
			if(entities[index] ~= nil) then
				nCombo = 0
				entities[index]:pause()
				entities[index]:removeSelf()
				updateCombo()
			end
		end,1)
	end
	for k,v in pairs(entities) do
		v:addEventListener("touch",
		function(event)
			touch(k,event)
		end)
	end
	
	timer.performWithDelay(0,function() audio.resume(4) end)
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