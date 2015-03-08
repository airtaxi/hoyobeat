-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
-- display.setDefault("magTextureFilter","nearest")
display.setDrawMode( "forceRender" )
-- display.setDefault("minTextureFilter","nearest")
_G.nimgr = _G.display.newImageRect
_G.nimg = _G.display.newImage
_G.nr = _G.display.newRect
_G.nt = _G.display.newText

platformName = system.getInfo("platformName")
if(platformName == "Mac OS X") then
	platformName = "Win"
end
-- function display.newImageRect(...)
	-- local args = {...}
	-- local returnImage = _G.nimgr(...)
	-- returnImage.xScale = returnImage.xScale*display.pixelWidth/720
	-- returnImage.yScale = returnImage.yScale*display.pixelHeight/1280
	-- returnImage.x = returnImage.x*(display.pixelWidth/720)
	-- returnImage.y = returnImage.y*(display.pixelHeight/1280)
	-- return returnImage
-- end
function display.newImage(...)
	local args = {...}
	local returnImage = _G.nimg(...)
	returnImage.xScale = returnImage.xScale*display.pixelWidth/720
	returnImage.yScale = returnImage.yScale*display.pixelHeight/1280
	returnImage.x = returnImage.x*(display.pixelWidth/720)
	returnImage.y = returnImage.y*(display.pixelHeight/1280)
	return returnImage
end
function display.recalculate(returnImage)
	returnImage.xScale = display.pixelWidth/720
	returnImage.yScale = display.pixelHeight/1280
	returnImage.x = returnImage.x*(display.pixelWidth/720)
	returnImage.y = returnImage.y*(display.pixelHeight/1280)
	return returnImage
end
function display.recalculateCS(returnImage)
	returnImage.x = returnImage.x*(display.pixelWidth/720)
	returnImage.y = returnImage.y*(display.pixelHeight/1280)
	returnImage.xScale = returnImage.xScale*display.pixelWidth/720
	returnImage.yScale = returnImage.yScale*display.pixelHeight/1280
	return returnImage
end
function display.recalculateS(returnImage)
	returnImage.xScale = display.pixelWidth/720
	returnImage.yScale = display.pixelHeight/1280
	return returnImage
end
function display.recalculateP(returnImage)
	returnImage.x = returnImage.x*(display.pixelWidth/720)
	returnImage.y = returnImage.y*(display.pixelHeight/1280)
	return returnImage
end
function display.newRect(...)
	local args = {...}
	local returnImage = _G.nr(...)
	returnImage.xScale = returnImage.xScale*display.pixelWidth/720
	returnImage.yScale = returnImage.yScale*display.pixelHeight/1280
	returnImage.x = returnImage.x*(display.pixelWidth/720)
	returnImage.y = returnImage.y*(display.pixelHeight/1280)
	return returnImage
end
function display.newText(...)
	local args = {...}
	local returnImage = _G.nt(...)
	returnImage.xScale = returnImage.xScale*display.pixelWidth/720
	returnImage.yScale = returnImage.yScale*display.pixelHeight/1280
	returnImage.x = returnImage.x*(display.pixelWidth/720)
	returnImage.y = returnImage.y*(display.pixelHeight/1280)
	return returnImage
end
local function myUnhandledErrorListener( event )

    local iHandledTheError = true

    if iHandledTheError then
		if "Win" ~= system.getInfo("platformName") then
			print( "Handling the unhandled error", event.errorMessage )
			native.showAlert( "ERROR!!!", event.errorMessage.."\n"..event.stackTrace)
		end
    else
        print( "Not handling the unhandled error", event.errorMessage )
    end
    
    return iHandledTheError
end

Runtime:addEventListener("unhandledError", myUnhandledErrorListener)
if "Android" == system.getInfo("platformName") then
	local gameNetwork = require "gameNetwork"
	local function systemEvents( event )
		print("systemEvent " .. event.type)
		if ( event.type == "applicationSuspend" ) then
			print( "suspending..........................." )
		elseif ( event.type == "applicationResume" ) then
			print( "resuming............................." )
		elseif ( event.type == "applicationExit" ) then
			print( "exiting.............................." )
		elseif ( event.type == "applicationStart" ) then
			print("start!")
				local function initCallback( event )
					if not event.isError then
						loggedIntoGC = true
					else
						print("Error Code: ", event.errorCode)
					end
				end
			gameNetwork.init( "google",initCallback)		
			gameNetwork.request( "login",
			{
				userInitiated = true,
				listener = function()	
					composer.gotoScene( "select")
				end
			})
		end
		return true
	end
	Runtime:addEventListener( "system", systemEvents )
end
local perf = require("perf")
perf:newPerformanceMeter()
if "Android" == system.getInfo("platformName") and setTouchSoundPath ~= nil then
	print("setTouchSoundPath")
	composer.clapable = true
	setTouchSoundPath()
else
	composer.clapable = false
end
if("Android" ~= system.getInfo("platformName")) then
	composer.gotoScene( "select" )
end