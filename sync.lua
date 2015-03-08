----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local tablesave = require( "tablesave" )
local scene = composer.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless composer.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
	local judgeEXC = 1
	local judgeGRT = 2
	local judgeSAV = 3
	local judgeBAD = 4
	local judgeMISS = 5
	local judges = {}
	local judgeTimes = {}
	local gss = {}
	local bing = audio.loadSound("play/clap.mp3")
	judges[judgeEXC] = "Sc_EXC"
	judges[judgeGRT] = "Sc_Great"
	judges[judgeSAV] = "Sc_save"
	judges[judgeBAD] = "Sc_Bad"
	judges[judgeMISS] = "Sc_Miss"
	judgeTimes[judgeEXC] = 75
	judgeTimes[judgeGRT] = 105
	judgeTimes[judgeSAV] = 135
	judgeTimes[judgeBAD] = 155
	judgeTimes[judgeMISS] = 185
	judgeTimes.judgeFunc = function(time)
		for i = 1,5,1 do
			if(time < judgeTimes[i]) then
				return i
			end
		end
		return -1
	end
	if(composer.getSceneName( "previous" ) ~= nil) then
		composer.removeScene(composer.getSceneName( "previous" ))
	end
	local loadedSettings
	local function saveSetting()
		--print("saved")
		tablesave.saveTable(loadedSettings == nil and {sync=0} or loadedSettings,"settings.json", system.DocumentsDirectory )
	end
	loadedSettings = tablesave.loadTable("settings.json", system.DocumentsDirectory ) or {sync=0}
	saveSetting()
	local judgeImg 
	local delayRText = _G.nt({text="보정값",x=display.pixelWidth/2,y=(display.pixelHeight/3)*2-50	,fontSize=40,align="center"})
	group:insert(delayRText)
	local delayRT = _G.nt({text=tostring(loadedSettings.sync),x=display.pixelWidth/2,y=(display.pixelHeight/3)*2-150,fontSize=100,align="center"})
	-- local delayT = _G.nt({text=tostring(0),x=display.pixelWidth/2,y=500,fontSize=75,align="center"})
	-- local delayText = _G.nt({text="평균값 (0 에 가까울수록 정확합니다)",x=640,y=560,fontSize=30,align="center"})
	-- local delayText2 = _G.nt({text="값을 바꾸면 평균값이 초기화됩니다.",x=640,y=600,fontSize=30,align="center"})
	
	scene.diffTime = 0
	scene.avrTime = 0
	scene.avrCount = 0
	scene.judge = function()
		if(scene.start ~= nil) then
			scene.avrCount = scene.avrCount + 1
			scene.diffTime = scene.diffTime + (system.getTimer() - scene.start - 1000 -tonumber(delayRT.text))
			scene.avrTime = scene.diffTime/scene.avrCount
			delayT.text = tostring(math.floor(scene.avrTime))
			local absDiff = math.abs(scene.avrTime)
			print(absDiff)
			local judgeidx = judgeTimes.judgeFunc(absDiff)
			print(judgeidx)
			transition.cancel("judgeImg")	
			display.remove(judgeImg)
			if(judgeidx > judgeSAV and judgeidx ~= -1) then
				judgeImg = _G.nimg("Play/"..judges[judgeidx]..".png",640,330)
				group:insert(judgeImg)
				judgeImg.xScale,judgeImg.yScale = 1,1
				transition.to(judgeImg,{time=500,xScale=1,yScale=1,y=display.pixelWidth/2,alpha=0.3,transition=easing.outCubic,tag="judgeImg"})
				transition.to(judgeImg,{time=500,alpha=0,tag="judgeImg"})
				-- scene.isDone = true
				-- local gs = gss[1]
				-- display.remove(gs)
				-- scene.loop()
			elseif(judgeidx ~= -1) then
				judgeImg = _G.nimg("Play/"..judges[judgeidx]..".png",640,330)
				group:insert(judgeImg)
				judgeImg.xScale,judgeImg.yScale = 1.2,1.2
				transition.to(judgeImg,{time=500,xScale=1,yScale=1,transition=easing.outCubic,tag="judgeImg"})
				transition.to(judgeImg,{time=500,alpha=0,tag="judgeImg"})
				-- scene.isDone = true
				-- local gs = gss[1]
				-- display.remove(gs)
				-- scene.loop()
			end
		end
	end
	local bg = _G.nimg("sync.png",display.pixelWidth/2,display.pixelHeight/2)
	bg.width,bg.height=display.pixelWidth,display.pixelHeight
	bg:setFillColor(1,1,1)
	bg.alpha = 0.01
	group:insert(bg)
	group:insert(delayRT)
	local tap = 0
	local averages = {}
	local average = 0
	-- local count = _G.nt({text="",fontSize=300,x=display.pixelWidth/2,y=640})
	-- group:insert(count)
	-- count.count = 3
	-- timer.performWithDelay(1000,function()
		-- count.count = count.count - 1
		-- count.text = tostring(count.count)
		-- if(count.count == 0) then
			
		-- end
	-- end,count.count)
	-- local vn = _G.nimg("vn.png",100,display.pixelWidth/2)
	-- group:insert(vn)
	local effect = graphics.newImageSheet("Play/effect.png", { width=400/4, height=400/4, numFrames=16,sheetContentWidth = 400,sheetContentHeight = 400})
	bg:addEventListener("touch",function(event)
		print(event.phase)
		if(event.phase == "began") then
			-- if(scene.isDone ~= true) then
				print("JUDGE")
				local gs = _G.nimg("gs.png",scene.gs.x,scene.gs.y)
				transition.to(gs,{time=6000,alpha=0,onComplete=function(sender)display.remove(sender)end})
				group:insert(gs)
				gs.xScale = 3
				-- scene.judge()
			-- end
			-- system.vibrate()
		end
	end)
	scene.gs2 = _G.nimg("gs.png",display.pixelWidth/2,display.pixelHeight/2+(display.pixelHeight/2000)*loadedSettings.sync)
	scene.gs2.xScale=5
	-- scene.gs2.yScale=3
	-- gs2.isVisible = false
	group:insert(scene.gs2)
	scene.loop = function()
		scene.isDone = false
		scene.start = system.getTimer()
		scene.loopTimer = timer.performWithDelay(1500,function()
			scene.loop()
		end)
		scene.gs = _G.nimg("gs.png",scene.gs2.x,0)
		gss[1] = scene.gs
		scene.gs.xScale=3
		-- scene.gs.yScale=3
		-- gs.isVisible =false
		group:insert(scene.gs)
		-- timer.performWithDelay(1500+tonumber(delayRT.text),function()
			-- local seffect = display.newSprite( effect, {name="judge",start=1,count=16,time=500,loopCount=1} )
			-- group:insert(seffect)
			-- seffect.x,seffect.y = 100,310
			-- seffect:play()
			-- timer.performWithDelay(500,function() display.remove(seffect) end)
			-- -- display.remove(gs)
		-- end)
		-- (display.pixelHeight/2000) -> 1ms
		transition.to(scene.gs,{time=2000,y=display.pixelHeight,onComplete=function(sender)
			-- transition.to(scene.gs,{time=1000,y=870,onComplete=function(sender)
				display.remove(sender)
			-- transition.to(gs,{time=300,y=display.pixelWidth})
			-- timer.performWithDelay(320, function()
				-- display.remove(sender)
				-- judgeImg = _G.nimg("Play/"..judges[judgeEXC]..".png",640,330)
				-- group:insert(judgeImg)
				-- judgeImg.xScale,judgeImg.yScale = 1,1
				-- transition.to(judgeImg,{time=500,xScale=1,yScale=1,y=display.pixelWidth/2,alpha=0.3,transition=easing.outCubic,tag="judgeImg"})
				-- transition.to(judgeImg,{time=50,alpha=1,tag="judgeImg",onComplete=function(sender)display.remove(sender)end})
				-- for i = #gss, 1 do
					-- if(gss[i] == gs) then
						-- print("REM",i)
						-- table.remove(gss,1)
					-- end
				-- end
				-- scene.loop()
			-- end)	
			-- end,delay=100})
		end})
		timer.performWithDelay(1000,function()
			audio.play(bing,{channel=14})
			-- media.playSound("play/clap.mp3")
			-- local seffect = display.newSprite( effect, {name="judge",start=1,count=16,time=500,loopCount=1} )
			-- group:insert(seffect)
			-- seffect.x,seffect.y = scene.gs2.x,scene.gs2.y
			-- seffect.xScale,seffect.yScale = 2,2
			-- seffect:play()
		end)
		scene.delayTimer = timer.performWithDelay(1000+tonumber(delayRT.text),function()
			-- scene.gs2:setFillColor(1,0,0)
			-- scene.gs:setFillColor(1,0,0)
			-- bg.alpha = 1
			-- system.vibrate()
			-- timer.performWithDelay(100,function()
				-- -- scene.gs2:setFillColor(1,1,1)
				-- -- bg.alpha = 0.01
			-- end)
			transition.to(bg,{time=30,alpha = 0.01})
		end)
	end
	local function onStepperPress(event) 
		if ( "increment" == event.phase ) then
			if(tonumber(delayRT.text) + 5 <= 900) then
				delayRT.text = tostring(tonumber(delayRT.text) + 5)
				scene.gs2.y = display.pixelHeight/2+tonumber(delayRT.text)*(display.pixelHeight/2000)
				loadedSettings.sync = tonumber(delayRT.text)
				saveSetting()
			end
		elseif ( "decrement" == event.phase ) then
			if(tonumber(delayRT.text) - 5 >= -900) then
				delayRT.text = tostring(tonumber(delayRT.text) - 5)
				scene.gs2.y = display.pixelHeight/2+tonumber(delayRT.text)*(display.pixelHeight/2000)
				loadedSettings.sync = tonumber(delayRT.text)
				saveSetting()
			end
		end
	end
	local options_ = 
	{
		x = display.pixelWidth/2,
		y = (display.pixelHeight/3)*2,
		minimumValue = -2000,
		maximumValue = 2000,
		onPress = onStepperPress,
		timerIncrementSpeed = 150,
	}
	local step = widget.newStepper( options_ )
	group:insert(step)
	scene.loop()
	scene.onKeyEvent = function( event )
		if(true) then
			local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
			print(message)
			if  "back" == event.keyName or "escape" == event.keyName  then
				if event.phase == "down" and scene.halt ~= true then
					scene.halt = true
					timer.cancel(scene.loopTimer)
					timer.cancel(scene.delayTimer)
					transition.cancel()
					Runtime:removeEventListener("key",scene.onKeyEvent)
					composer.gotoScene("select")
					return true
				end
			end
		end
	end
	Runtime:addEventListener( "key", scene.onKeyEvent )
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	local group = self.view
	display.remove(group)
	group = nil
	scene = nil
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )

-- "show" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "hide" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroy" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- composer.purgeScene() or composer.removeScene().
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene