local lfs = require("lfs")
require("kconv")
local crypto = require "crypto"
local widget = require( "widget" )
-- appWarpClient = require "AppWarp.WarpClient"
local gameNetwork
local globals = require( "mod_globals" )
if "Android" == platformName then
	gameNetwork = require "gameNetwork"
end
function isNetworkOn()
	local status = network.getConnectionStatus()
	return status.isConnected
end
function gameLoop(event)
	-- appWarpClient.Loop()
end
Runtime:addEventListener("enterFrame", gameLoop)

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if(idx_ == nil) then
	idx_ = 1
end
local composer = require( "composer" )
local tablesave = require( "tablesave" )
local scene = composer.newScene()
local function scoreExists(fn)
	local path_ = system.pathForFile( fn, system.DocumentsDirectory )
	local f=io.open(path_,"r")
	if f~=nil then io.close(f) return true else return false end
end
local function scoreWrite(fn,sn, lastScore,maxScore,delay,lastLV,lastScore2,lastScore3,maxScore2,maxScore3)
	local path_ = system.pathForFile( fn, system.DocumentsDirectory )
	local file = io.open(path_,"w")
	if(file) then
		local toWrite
		if(lastScore == nil) then lastScore = 0 end
		if(lastScore2 == nil) then lastScore2 = 0 end
		if(lastScore3 == nil) then lastScore3 = 0 end
		if(maxScore == nil) then maxScore = 0 end
		if(maxScore2 == nil) then maxScore2 = 0 end
		if(maxScore3 == nil) then maxScore3 = 0 end
		if(delay == nil) then delay = 0 end
		if(lastLV == nil) then lastLV = "bsc" end
		if(fn == nil) then fn = "unknown.txt" end
		if(sn == nil) then sn = "unknown" end
		toWrite = string.gsub(tostring(sn)," ","").." "..tostring(lastScore).." "..tostring(maxScore).." "..tostring(delay).." "..tostring(lastLV).." "..tostring(lastScore2).." "..tostring(lastScore3).." "..tostring(maxScore2).." "..tostring(maxScore3)
		-- --print(toWrite.." / "..fn)
		file:write(toWrite)
		io.close(file)
	else
		--print("FATAL:: cannot open file : "..fn)
	end
end
local function settingsExists()
	local path_ = system.pathForFile( "settings.setting", system.DocumentsDirectory )
	local f=io.open(path_,"r")
	if f~=nil then io.close(f) return true else return false end
end
local function settingsWrite(isDownside)
	local path_ = system.pathForFile( "settings.setting", system.DocumentsDirectory )
	local file = io.open(path_,"w")
	if(file) then
		local toWrite
		toWrite = "0"
		if(isDownside) then
			toWrite = "1"
		end
		-- --print(toWrite.." / "..fn)
		file:write(toWrite)
		io.close(file)
	else
		--print("FATAL:: cannot open file : "..fn)
	end
end

local function markersExists()
	local path_ = system.pathForFile( "markers.setting", system.DocumentsDirectory )
	local f=io.open(path_,"r")
	if f~=nil then io.close(f) return true else return false end
end
local function markersWrite(data)
	local path_ = system.pathForFile( "markers.setting", system.DocumentsDirectory )
	local file = io.open(path_,"w")
	if(file) then
		local toWrite = data
		file:write(toWrite)
		io.close(file)
	else
		--print("FATAL:: cannot open file : "..fn)
	end
end
local function scoreRead(fn)
	local path_ = system.pathForFile( fn, system.DocumentsDirectory )
	local file = io.open(path_,"r")
	if(file) then
		local toRead
		local indata = file:read("*a")
		-- --print(indata)
		local indataSp = {}
		local index_ = 0
		for value in string.gmatch(indata,"[^%s]+") do
			-- --print(value)
			indataSp[index_] = value
			index_ = index_ + 1
		end
		io.close(file)
		return indataSp
	else
		--print("FATAL:: cannot open file : "..fn)
		return nil
	end
end


local function delayWrite(fn,delay_)
	local path_ = system.pathForFile( fn.."_settings.delay", system.DocumentsDirectory )
	local file = io.open(path_,"w")
	if(file) then
		local toWrite
		toWrite = tostring(delay_)
		-- --print(toWrite.." / "..fn)
		file:write(toWrite)
		io.close(file)
	else
		--print("FATAL:: cannot open file : "..fn)
	end
end
local function delayRead(fn)
	local path_ = system.pathForFile( fn.."_settings.delay", system.DocumentsDirectory )
	local file = io.open(path_,"r")
	if(file) then
		local toRead
		local indata = file:read("*a")
		io.close(file)
		return indata
	else
		delayWrite(fn,0)
		return 0
	end
end

local function markerSpeedWrite(speed)
	local path_ = system.pathForFile("settings.marker", system.DocumentsDirectory )
	local file = io.open(path_,"w")
	if(file) then
		local toWrite
		toWrite = tostring(speed)
		-- --print(toWrite.." / "..fn)
		file:write(toWrite)
		io.close(file)
	else
		--print("FATAL:: cannot open file : "..fn)
	end
end
local function markerSpeedRead()
	local path_ = system.pathForFile( "settings.marker", system.DocumentsDirectory )
	local file = io.open(path_,"r")
	if(file) then
		local toRead
		local indata = file:read("*a")
		io.close(file)
		return indata
	else
		markerSpeedWrite(833)
		return 833
	end
end
local function delayRead(fn)
	local path_ = system.pathForFile( fn.."_settings.delay", system.DocumentsDirectory )
	local file = io.open(path_,"r")
	if(file) then
		local toRead
		local indata = file:read("*a")
		io.close(file)
		return indata
	else
		delayWrite(fn,0)
		return 0
	end
end

local function settingsRead()
	local path_ = system.pathForFile( "settings.setting", system.DocumentsDirectory )
	local file = io.open(path_,"r")
	if(file) then
		local toRead
		local indata = file:read("*a")
		io.close(file)
		return indata
	else
		--print("FATAL:: cannot open file : "..fn)
		return nil
	end
end

local function markersRead()
	local path_ = system.pathForFile( "markers.setting", system.DocumentsDirectory )
	local file = io.open(path_,"r")
	if(file) then
		local toRead
		local indata = file:read("*a")
		io.close(file)
		return indata
	else
		--print("FATAL:: cannot open file : "..fn)
		return nil
	end
end

local function onKeyEvent( event )

	if  "back" == event.keyName  then
		-- return true
	end
	-- --print(event.keyName)
end
Runtime:addEventListener( "key", onKeyEvent )
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
--checking if file exist
function isDir(name)
    if type(name)~="string" then return false end
    local cd = lfs.currentdir()
    local is = lfs.chdir(name) and true or false
    lfs.chdir(cd)
    return is
end
function doesFileExist( fname, path )

    local results = false

    local filePath = fname

    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "r" )
    end

    if ( filePath ) then
        --print( "File found: " .. fname )
        --clean up file handles
        filePath:close()
        results = true
    else
        --print( "File does not exist: " .. fname )
    end

    return results
end

local function decode(t)
-- local toutf = ""
-- for code in t:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
	-- if(string.byte(code) ~= 0) then
		-- toutf = toutf..code
	-- end
-- end
	local succeed = pcall(function() toutf = kconv.kconvert(t, "utf-16-le", "utf-8") end)
	return succeed and toutf or t
end

local function decode2(t)
	local toutf = ""
	for code in t:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		if(string.byte(code) ~= 0) then
			toutf = toutf..code
		end
	end
	-- local succeed = pcall(function() toutf = kconv.kconvert(t, "utf-16-le", "utf-8") end)
	return toutf
end
--copy 'readme.txt' from the 'system.ResourceDirectory' to 'system.DocumentsDirectory'.
function scene:create( event )
	local screenGroup = self.view
	-- local group_ = display.newGroup()
	
	if "Android" == platformName then
		local dest = "/sdcard/hoyobeat/"
		scene.pathtb = "/sdcard/touchbeat_j3/songs"
		scene.pathtb2 = "/sdcard/touchbeat_j2/songs"
		globals.markerPath = "/sdcard/marker/"
		
		if(isDir("/mnt/sdcard0/marker/")) then
			globals.markerPath = "/mnt/sdcard0/marker/"
		elseif(isDir("/mnt/sdcard1/marker/")) then
			globals.markerPath = "/mnt/sdcard1/marker/"
		elseif(isDir("/storage/extSdCard/marker/")) then
			globals.markerPath = "/storage/extSdCard/marker/"
		elseif(isDir("/storage/sdcard0/marker/")) then
			globals.markerPath = "/storage/sdcard0/marker/"
		elseif(isDir("/storage/sdcard1/marker/")) then
			globals.markerPath = "/storage/sdcard1/marker/"
		elseif(isDir("/mnt/extSdCard/marker/")) then
			globals.markerPath = "/mnt/extSdCard/marker/"
		elseif(isDir("/mnt/sdcard/marker/")) then
			globals.markerPath = "/mnt/sdcard/marker/"
		elseif(isDir("/sdcard/marker/")) then
			globals.markerPath = "/sdcard/marker/"
		end
		if(isDir("/mnt/sdcard0/touchbeat_j3/songs")) then
			scene.pathtb = "/mnt/sdcard0/touchbeat_j3/songs"
		elseif(isDir("/mnt/sdcard1/touchbeat_j3/songs")) then
			scene.pathtb = "/mnt/sdcard1/touchbeat_j3/songs"
		elseif(isDir("/storage/extSdCard/touchbeat_j3/songs")) then
			scene.pathtb = "/storage/extSdCard/touchbeat_j3/songs"
		elseif(isDir("/storage/sdcard0/touchbeat_j3/songs")) then
			scene.pathtb = "/storage/sdcard0/touchbeat_j3/songs"
		elseif(isDir("/storage/sdcard1/touchbeat_j3/songs")) then
			scene.pathtb = "/storage/sdcard1/touchbeat_j3/songs"
		elseif(isDir("/mnt/extSdCard/touchbeat_j3/songs")) then
			scene.pathtb = "/mnt/extSdCard/touchbeat_j3/songs"
		elseif(isDir("/mnt/sdcard/touchbeat_j3/songs")) then
			scene.pathtb = "/mnt/sdcard/touchbeat_j3/songs"
		elseif(isDir("/sdcard/touchbeat_j3/songs")) then
			scene.pathtb = "/sdcard/touchbeat_j3/songs"
		end
		
		if(isDir("/mnt/sdcard0/touchbeat_j2/songs")) then
			scene.pathtb2 = "/mnt/sdcard0/touchbeat_j2/songs"
		elseif(isDir("/mnt/sdcard1/touchbeat_j2/songs")) then
			scene.pathtb2 = "/mnt/sdcard1/touchbeat_j2/songs"
		elseif(isDir("/storage/extSdCard/touchbeat_j2/songs")) then
			scene.pathtb2 = "/storage/extSdCard/touchbeat_j2/songs"
		elseif(isDir("/storage/sdcard0/touchbeat_j2/songs")) then
			scene.pathtb2 = "/storage/sdcard0/touchbeat_j2/songs"
		elseif(isDir("/storage/sdcard1/touchbeat_j2/songs")) then
			scene.pathtb2 = "/storage/sdcard1/touchbeat_j2/songs"
		elseif(isDir("/mnt/extSdCard/touchbeat_j2/songs")) then
			scene.pathtb2 = "/mnt/extSdCard/touchbeat_j2/songs"
		elseif(isDir("/mnt/sdcard/touchbeat_j2/songs")) then
			scene.pathtb2 = "/mnt/sdcard/touchbeat_j2/songs"
		elseif(isDir("/sdcard/touchbeat_j2/songs")) then
			scene.pathtb2 = "/sdcard/touchbeat_j2/songs"
		end
		
		if(isDir("/mnt/sdcard0/hoyobeat")) then
			scene.isSDcard = "/mnt/sdcard0/hoyobeat"
		elseif(isDir("/mnt/sdcard1/hoyobeat")) then
			scene.isSDcard = "/mnt/sdcard1/hoyobeat"
		elseif(isDir("/storage/extSdCard/hoyobeat")) then
			scene.isSDcard = "/storage/extSdCard/hoyobeat"
		elseif(isDir("/storage/sdcard0/hoyobeat")) then
			scene.isSDcard = "/storage/sdcard0/hoyobeat"
		elseif(isDir("/storage/sdcard1/hoyobeat")) then
			scene.isSDcard = "/storage/sdcard1/hoyobeat"
		elseif(isDir("/mnt/extSdCard/hoyobeat")) then
			scene.isSDcard = "/mnt/extSdCard/hoyobeat"
		elseif(isDir("/mnt/sdcard/hoyobeat")) then
			scene.isSDcard = "/mnt/sdcard/hoyobeat"
		elseif(isDir("/sdcard/hoyobeat")) then
			scene.isSDcard = "/sdcard/hoyobeat"
		elseif(isDir("/storage/extSdCard/Android/data/com.dmelody.andjuist2/files/songs")) then
			scene.isSDcard = "/storage/extSdCard/Android/data/com.dmelody.andjuist2/files/songs"	
		elseif(isDir("/mnt/extSdCard/Android/data/com.dmelody.andjuist2/files/songs")) then
			scene.isSDcard = "/mnt/extSdCard/Android/data/com.dmelody.andjuist2/files/songs"	
		elseif(isDir("/storage/sdcard0/Android/data/com.dmelody.andjuist2/files/songs")) then
			scene.isSDcard = "/storage/sdcard0/Android/data/com.dmelody.andjuist2/files/songs"
		elseif(isDir("/storage/sdcard1/Android/data/com.dmelody.andjuist2/files/songs")) then
			scene.isSDcard = "/storage/sdcard1/Android/data/com.dmelody.andjuist2/files/songs"
		else
			scene.isSDcard = "/sdcard/Android/data/com.dmelody.andjuist2/files/songs"
		end
		print("SD:",scene.isSDcard)
		-- if(doesFileExist("/sdcard/hbuser.txt",nil)) then
			-- USER_NAME = io.open("/sdcard/hbuser.txt"):read("*l"):sub(1,12)
		-- end
		-- if(doesFileExist("/sdcard/hbchan.txt",nil)) then
			-- SV_CHANNEL = io.open("/sdcard/hbchan.txt"):read("*l"):sub(1,12)
		-- end
	end
		
	if(USER_NAME == nil) then
		USER_NAME = "GUEST-01"
	end
	if(SV_CHANNEL == nil) then
		SV_CHANNEL = "result3"
	end
	API_KEY = "de82d6402be62aaf0ac6cefd8e826c04cbe1a1d6d9b197789395eea60325b394"
	SECRET_KEY = "70d87a19800a0982421d3507613f29cb299a24bc78eb28fdc377292aababc879"
	-- appWarpClient.initialize(API_KEY, SECRET_KEY)
	-- appWarpClient.connectWithUserName(USER_NAME)
	local bg = display.newImageRect("background.png",720,1280)
	bg.x,bg.y = 360,640
	display.recalculate(bg)
	screenGroup:insert(bg)
end


-- Called immediately after scene has moved onscreen:
function scene:show( event)
	if(event.phase == "did") then
		local function trim1(s)
			return (s:gsub("^%s*(.-)%s*$", "%1"))
		end
		
		if(setGlobalTouch ~= nil) then
			setGlobalTouch(false)
		end
		local areaGroup
		local screenGroup = self.view
		-- local pHeight = 580/4*((16/9)/(display.pixelHeight/display.pixelWidth))
		local pHeight = 720/4
		local list
		local tbjList
		local delayRT
		local matching = {}
		local album = {}
		local freeChan = audio.findFreeChannel()
		local bgm
		local isDown
		local bgmPlay
		local tc
		local maxSC
		local LVL
		local lastSC
		local selectedAlbum = 1
		local selected
		local key = true
		local clap = false
		local isOnline = false
		local levels
		local levelT
		local lvlidx
		local lastSCT
		local maxSCT
		local LVT
		local i_hard
		local albumPath = {}
		local easy = false
		local auto = false
		local halt = false
		local overlay = false
		local panel
		local sep
		-- local group_ = display.newGroup()
		-- screenGroup:insert(group_)
		if(composer.getSceneName( "previous" ) ~= nil) then
			composer.removeScene(composer.getSceneName( "previous" ))
		end
		local coords = {}
		local coords_ = {}
		coords[1],coords_[1] = (720/4)*1-90,(1280-pHeight*4-pHeight/2)+(pHeight)*1
		coords[2],coords_[2] = (720/4)*2-90,(1280-pHeight*4-pHeight/2)+(pHeight)*1
		coords[4],coords_[4] = (720/4)*4-90,(1280-pHeight*4-pHeight/2)+(pHeight)*1
		coords[3],coords_[3] = (720/4)*3-90,(1280-pHeight*4-pHeight/2)+(pHeight)*1
		coords[5],coords_[5] = (720/4)*1-90,(1280-pHeight*4-pHeight/2)+(pHeight)*2
		coords[6],coords_[6] = (720/4)*2-90,(1280-pHeight*4-pHeight/2)+(pHeight)*2
		coords[7],coords_[7] = (720/4)*3-90,(1280-pHeight*4-pHeight/2)+(pHeight)*2
		coords[8],coords_[8] = (720/4)*4-90,(1280-pHeight*4-pHeight/2)+(pHeight)*2
		coords[9],coords_[9] = (720/4)*1-90,(1280-pHeight*4-pHeight/2)+(pHeight)*3
		coords[10],coords_[10] = (720/4)*2-90,(1280-pHeight*4-pHeight/2)+(pHeight)*3
		coords[11],coords_[11] = (720/4)*3-90,(1280-pHeight*4-pHeight/2)+(pHeight)*3
		coords[12],coords_[12] = (720/4)*4-90,(1280-pHeight*4-pHeight/2)+(pHeight)*3
		coords[13],coords_[13] = (720/4)*1-90,(1280-pHeight*4-pHeight/2)+(pHeight)*4
		coords[14],coords_[14] = (720/4)*2-90,(1280-pHeight*4-pHeight/2)+(pHeight)*4
		coords[15],coords_[15] = (720/4)*3-90,(1280-pHeight*4-pHeight/2)+(pHeight)*4
		coords[16],coords_[16] = (720/4)*4-90,(1280-pHeight*4-pHeight/2)+(pHeight)*4
		panel = display.newImageRect(screenGroup,"play/panel_4x4.png",720,pHeight*4)
		panel.x,panel.y = 360,(1280-pHeight*2)
		display.recalculate(panel)
		screenGroup:insert(panel)
		local sync_bg = _G.nimgr("syncBtn.png",display.pixelWidth/4,display.pixelWidth/4)
		sync_bg:addEventListener("tap",function()
			audio.stop(bgmPlay)
			audio.dispose(bgm)
			bgm = nil
			composer.gotoScene( "sync" )
			halt = true
		end)
		screenGroup:insert(sync_bg)
		sync_bg.x,sync_bg.y = display.pixelWidth - display.pixelWidth/8,display.pixelHeight - display.pixelWidth/8
		local saucer_font
		local mainAlbum
		local mainAlbumName
		if "Win" == platformName then
			sep = "\\"
			basedir = system.ResourceDirectory
			saucer_font = "NanumBarunGothic"
		elseif "Android" == platformName then
			sep = "/"
			basedir = system.DocumentsDirectory
			saucer_font = "NanumBarunGothic"
		elseif "iPhone OS" == platformName then
			sep = "/"
			basedir = system.DocumentsDirectory
			saucer_font = "NanumBarunGothic"
		end
		display.setStatusBar( display.HiddenStatusBar )
		-- local syncT = display.newText({text="SYNC",x=coords[16],y=coords_[16],fontSize=50,font=saucer_font})
		-- syncT:setFillColor(0,0,0)
		-- screenGroup:insert(syncT)
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
		-- if "Win" == platformName then
			-- local fps = require("fps")
			-- local performance = fps.PerformanceOutput.new();
			-- performance.group.x, performance.group.y = display.contentWidth/2, 30;
			-- performance.alpha = 0.6; -- So it doesn't get in the way of the rest of the scene
		-- end
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

		-- for ik = 1,12,1 do
			-- table.insert(matching, display.newImageRect("matchicon.png",720/4,pHeight))
			-- matching[#matching].isVisible = false
			-- matching[#matching].x,matching[#matching].y = coords[ik],coords_[ik]
			-- screenGroup:insert(matching[#matching])
		-- end
		
		local name = "saucer"     -- part of the Font name we are looking for

		name = string.lower( name )

		-- Display each font in the terminal console
		for i, fontname in ipairs(fonts) do
			j, k = string.find( string.lower( fontname ), name )

			if( j ~= nil ) then

				-- --print( "fontname = " .. tostring( fontname ) )

			end
		end

		local path = "/"
		list = {}	
		local markerList = {}
		local markerNameList = {}	
		function split(inputstr, sep)
				if sep == nil then
						sep = "%s"
				end
				local t={} ; i=1
				for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
						t[i] = str
						i = i + 1
				end
				return t
		end
		local sPath
		if "Win" == platformName or "iPhone OS" == platformName then
			sPath = system.pathForFile( "", system.DocumentsDirectory).."cached.hoyobeat"
		else
			-- sPath = "/sdcard/cached.hoyobeat"
			sPath = system.pathForFile( "", system.DocumentsDirectory).."cached.hoyobeat"
		end
		if "Win" == platformName then
			globals.markerPath = "../marker/"
		end
		if globals.isNFirst ~= true or doesFileExist(sPath) == false then
		-- if globals.lists == nil then
			globals.isNFirst = true
			globals.lists = {}
			globals.files = {}
			if "Win" == platformName then
				path = system.pathForFile( "", system.ResourceDirectory)
				--print(system.pathForFile( "", system.DocumentsDirectory))
				-- --print(path)
				-- for dir in io.popen([[dir C:\Hoyobeat\songs /b /ad /b /ad]]):lines() do
					-- table.insert(list,"songs/"..dir)
				path = "../songs"
				if "iPhone OS" == platformName then
					path = "songs"
				end
				-- --print(path)
				for file in lfs.dir(system.pathForFile(path,system.ResourceDirectory)) do
				   --file is the current file or directory name
				   print( "Found file: " .. file )
				   --TODO: check error -hoyo
					local willBeAdd = {}
					willBeAdd.extData = {level=0,exists=false,note="",offset=0}
					willBeAdd.bscData = {level=0,exists=false,note="",offset=0}
					willBeAdd.advData = {level=0,exists=false,note="",offset=0}
					if(file ~= "." and file ~= ".." and isDir(system.pathForFile(path.."/"..file))) then
						for jbfile in lfs.dir(system.pathForFile(path.."/"..file,system.ResourceDirectory)) do
							if(string.find(jbfile,".txt") ~= nil and jbfile:find("manifest") == nil) then
								willBeAdd.isTXT = true
								willBeAdd.albumart = "txt.png"
								willBeAdd.title = jbfile:gsub(".txt","")
								willBeAdd.level = 10
								willBeAdd.startTime = 20000
								willBeAdd.bpm = 100
								willBeAdd.txtNote = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,".png") ~= nil) then
								willBeAdd.albumart = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,".jpg") ~= nil) then
								willBeAdd.albumart = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,".mp3") ~= nil) then
								willBeAdd.mp3 = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"ext.jmt") ~= nil) then
								willBeAdd.isTXT = false
								willBeAdd.extData.note = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"adv.jmt") ~= nil) then
								willBeAdd.isTXT = false
								willBeAdd.advData.note = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"bsc.jmt") ~= nil) then
								willBeAdd.isTXT = false
								willBeAdd.bscData.note = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"manifest.txt") ~= nil and willBeAdd.isTXT ~= true) then
								local jmt = io.open(system.pathForFile(path.."/"..file.."/"..jbfile,system.ResourceDirectory))
								local jmtStr = jmt:read("*all")
								local jmtUTF = jmtStr
								willBeAdd.startTime = 20000
								if(jmtUTF:upper():find("BPM=")) then
									local willBeNumber = jmtUTF:sub(jmtUTF:upper():find("BPM=")+4,(jmtUTF:upper():find("\n",jmtUTF:upper():find("BPM=")+4))):gsub("^%s*(.-)%s*$", "%1")
									willBeAdd.bpm = tonumber(willBeNumber) or 160
								end
								if(jmtUTF:upper():find("COMPOSER=")) then
									local composer
									local success = pcall(function()
										composer = jmtUTF:sub(jmtUTF:upper():find("COMPOSER=")+9,(jmtUTF:upper():find("\n",jmtUTF:upper():find("COMPOSER=")+9))):gsub("^%s*(.-)%s*$", "%1")
									end)
									willBeAdd.composer = success and composer or "Various Artist"
								end
								if(jmtUTF:upper():find("NAME=")) then
									willBeAdd.title = jmtUTF:sub(jmtUTF:upper():find("NAME=")+5,(jmtUTF:upper():find("\n",jmtUTF:upper():find("NAME=")+5))):gsub("^%s*(.-)%s*$", "%1")..""---"JMT"
								end
								if(jmtUTF:upper():find("LEVEL=")) then
									local lvlstr = jmtUTF:sub(jmtUTF:upper():find("LEVEL=")+6,(jmtUTF:upper():find("\n",jmtUTF:upper():find("LEVEL=")+6))):gsub("^%s*(.-)%s*$", "%1")
									lvlstr = split(lvlstr,",")
									willBeAdd.bscData.level = lvlstr[1]
									willBeAdd.advData.level = lvlstr[2]
									willBeAdd.extData.level = lvlstr[3]
								end
							end
						end
						willBeAdd.isTBJ = false
						willBeAdd.level = {willBeAdd.bscData,willBeAdd.advData,willBeAdd.extData}
						local album_ = display.newImage(willBeAdd.albumart or "")
						if(album_ == nil or album_.xScale == nil or album_.width == nil) then
							willBeAdd.title = nil
						end
						display.remove(album_)
						album_ = nil
						if((willBeAdd.title ~= nil and willBeAdd.mp3 ~= nil and willBeAdd.startTime ~= nil and willBeAdd.bpm ~= nil and willBeAdd.albumart ~= nil) or willBeAdd.isTXT) then
							willBeAdd.file = file
							table.insert(globals.lists,willBeAdd)
						else
							print("ERROR",willBeAdd.title)
						end
						table.insert(globals.files,file)
					end
				end
				json = require "json"
				
				path_tb = "../songs181"
				
				if "iPhone OS" == platformName then
					path_tb = "songs181"
				end
				for file in lfs.dir(system.pathForFile(path_tb,system.ResourceDirectory)) do
				   --file is the current file or directory name
				   -- print( "Found file: " .. file)
				   --TODO: check error -hoyo
					local loaded = pcall(function()
						if(file ~= "." and file ~= ".." and isDir(system.pathForFile(path_tb.."/"..file))) then
							for tbfile in lfs.dir(system.pathForFile(path_tb.."/"..file,system.ResourceDirectory)) do
								if(string.find(tbfile,".ybi") ~= nil and system.pathForFile(path_tb.."/"..file.."/"..tbfile,system.ResourceDirectory) ~= nil) then
									-- print(file)
									-- print(path_tb.."/"..file.."/"..tbfile)
									-- print(system.pathForFile(path_tb.."/"..file.."/"..tbfile,system.ResourceDirectory))
									local ybi = io.open(system.pathForFile(path_tb.."/"..file.."/"..tbfile,system.ResourceDirectory))
									-- for line in ybi:lines() do print(line) end
									local ybiStr = ybi:read("*all")
									local ybiUTF = decode2(ybiStr)
									local willBeAdd = {}
									if(ybiUTF:upper():find("#JACKET")) then
										willBeAdd.albumart = trim1(path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#JACKET")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#JACKET")+8))))
									end
									if(ybiUTF:upper():find("#AUDIO_FILE")) then
										local willFind = ".MP3"
										if(ybiUTF:upper():find(".OGG")) then
											willFind = ".OGG"
										end
										if(ybiUTF:upper():find(".WAV")) then
											willFind = ".WAV"
										end
										willBeAdd.mp3 = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#AUDIO_FILE")+12,(ybiUTF:upper():find(willFind,ybiUTF:upper():find("#AUDIO_FILE")+12))+3)
									end
									if(ybiUTF:upper():find("#ARTIST")) then
										willBeAdd.composer = ybiUTF:sub(ybiUTF:upper():find("#ARTIST")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#ARTIST")+8))):gsub("^%s*(.-)%s*$", "%1")
									else
										willBeAdd.composer = "Various Artist"
									end
									if(ybiUTF:upper():find("#BGM_START")) then
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BGM_START")+11,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BGM_START")+11))):gsub("^%s*(.-)%s*$", "%1")
										willBeAdd.startTime = tonumber(willBeNumber)
									end
									if(ybiUTF:upper():find("#MUSIC_TIME")) then
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#MUSIC_TIME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#MUSIC_TIME")+12))):gsub("^%s*(.-)%s*$", "%1")
										willBeAdd.musicTime = tonumber(willBeNumber)
									end
									if(ybiUTF:upper():find("#BPM_SHOW")) then
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BPM_SHOW")+10,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BPM_SHOW")+10))):gsub("^%s*(.-)%s*$", "%1")
										willBeAdd.bpm = tonumber(willBeNumber) or 160
									else
										willBeAdd.bpm = 160
									end
									if(ybiUTF:upper():find("#TITLE_NAME")) then
										willBeAdd.title = ybiUTF:sub(ybiUTF:upper():find("#TITLE_NAME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#TITLE_NAME")+12))):gsub("^%s*(.-)%s*$", "%1")
									end
									
									if(ybiUTF:upper():find("NOTES:2")) then
										local noteData = {}
										local IDX = ybiUTF:upper():find("NOTES:2")
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.level = willBeNumber
										
										willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.offset = tonumber(willBeNumber)
										noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.exists = true
										willBeAdd.advData = noteData
									else
										willBeAdd.advData = {level=0,offset=0,exists=false}
									end
									
									if(ybiUTF:upper():find("NOTES:3")) then
										local noteData = {}
										local IDX = ybiUTF:upper():find("NOTES:3")
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.level = willBeNumber
										willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.offset = tonumber(willBeNumber)
										noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.exists = true
										willBeAdd.extData = noteData
									else
										willBeAdd.extData = {level=0,offset=0,exists=false}
									end
									
									if(ybiUTF:upper():find("NOTES:1")) then
										local noteData = {}
										local IDX = ybiUTF:upper():find("NOTES:1")
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.level = willBeNumber
										
										willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.offset = tonumber(willBeNumber)
										noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.exists = true
										willBeAdd.bscData = noteData
									else
										willBeAdd.bscData = {level=0,offset=0,exists=false}
									end
									willBeAdd.isTBJ = true
									local offsets = {willBeAdd.bscData.offset,willBeAdd.advData.offset,willBeAdd.extData.offset}
									local offsetForNow = 0
									for k,v in pairs(offsets) do
										if(v ~= nil) then
											offsetForNow = v
										end
									end
									if(offsetForNow ~= 0) then
										if(willBeAdd.bscData.offset == 0) then
											willBeAdd.bscData.offset = offsetForNow
										end
										if(willBeAdd.advData.offset == 0) then
											willBeAdd.advData.offset = offsetForNow
										end
										if(willBeAdd.extData.offset == 0) then
											willBeAdd.extData.offset = offsetForNow
										end
									end
									willBeAdd.level = {willBeAdd.bscData,willBeAdd.advData,willBeAdd.extData}
									local album_ = display.newImage(willBeAdd.albumart or "")
									if(album_ == nil or album_.xScale == nil or album_.width == nil) then
										willBeAdd.title = nil
									end
									display.remove(album_)
									album_ = nil
									if(willBeAdd.title ~= nil and willBeAdd.mp3 ~= nil and willBeAdd.startTime ~= nil and willBeAdd.bpm ~= nil and willBeAdd.albumart ~= nil) then
										willBeAdd.file = file
										table.insert(globals.lists,willBeAdd)
									end
								end
							end
							table.insert(globals.files,file)
							-- table.insert(files,file)
							-- table.insert(list,path_tb.."/"..file)
						end
					end)
					if(loaded == false) then
						print("FAILED TO LOAD ",path_tb.."/"..file)
					end
				end
				
				path_tb = "../songs8"
				
				if "iPhone OS" == platformName then
					path_tb = "songs8"
				end
				for file in lfs.dir(system.pathForFile(path_tb,system.ResourceDirectory)) do
				   --file is the current file or directory name
				   -- print( "Found file: " .. file)
				   --TODO: check error -hoyo
					local loaded = pcall(function()
						if(file ~= "." and file ~= ".." and isDir(system.pathForFile(path_tb.."/"..file))) then
							for tbfile in lfs.dir(system.pathForFile(path_tb.."/"..file,system.ResourceDirectory)) do
								if(string.find(tbfile,".ybi") ~= nil and system.pathForFile(path_tb.."/"..file.."/"..tbfile,system.ResourceDirectory) ~= nil) then
									print(file)
									-- print(path_tb.."/"..file.."/"..tbfile)
									-- print(system.pathForFile(path_tb.."/"..file.."/"..tbfile,system.ResourceDirectory))
									local ybi = io.open(system.pathForFile(path_tb.."/"..file.."/"..tbfile,system.ResourceDirectory))
									-- for line in ybi:lines() do print(line) end
									local ybiStr = ybi:read("*all")
									local ybiUTF = decode(ybiStr)
									local willBeAdd = {}
									if(ybiUTF:upper():find("#JACKET")) then
										willBeAdd.albumart = trim1(path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#JACKET")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#JACKET")+8))))
										print(willBeAdd.albumart)
									end
									if(ybiUTF:upper():find("#AUDIO_FILE")) then
										local willFind = ".MP3"
										if(ybiUTF:upper():find(".OGG")) then
											willFind = ".OGG"
										end
										if(ybiUTF:upper():find(".WAV")) then
											willFind = ".WAV"
										end
										willBeAdd.mp3 = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#AUDIO_FILE")+12,(ybiUTF:upper():find(willFind,ybiUTF:upper():find("#AUDIO_FILE")+12))+3)
										print(willBeAdd.mp3)
									end
									if(ybiUTF:upper():find("#ARTIST")) then
										willBeAdd.composer = ybiUTF:sub(ybiUTF:upper():find("#ARTIST")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#ARTIST")+8))):gsub("^%s*(.-)%s*$", "%1")
									else
										willBeAdd.composer = "Various Artist"
									end
									if(ybiUTF:upper():find("#BGM_START")) then
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BGM_START")+11,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BGM_START")+11))):gsub("^%s*(.-)%s*$", "%1")
										willBeAdd.startTime = tonumber(willBeNumber)
									end
									if(ybiUTF:upper():find("#MUSIC_TIME")) then
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#MUSIC_TIME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#MUSIC_TIME")+12))):gsub("^%s*(.-)%s*$", "%1")
										willBeAdd.musicTime = tonumber(willBeNumber)
									end
									if(ybiUTF:upper():find("#BPM_SHOW")) then
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BPM_SHOW")+10,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BPM_SHOW")+10))):gsub("^%s*(.-)%s*$", "%1")
										willBeAdd.bpm = tonumber(willBeNumber) or 160
									else
										willBeAdd.bpm = 160
									end
									if(ybiUTF:upper():find("#TITLE_NAME")) then
										willBeAdd.title = ybiUTF:sub(ybiUTF:upper():find("#TITLE_NAME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#TITLE_NAME")+12))):gsub("^%s*(.-)%s*$", "%1")
									end
									
									if(ybiUTF:upper():find("NOTES:2")) then
										local noteData = {}
										local IDX = ybiUTF:upper():find("NOTES:2")
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.level = willBeNumber
										
										willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.offset = tonumber(willBeNumber)
										noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.exists = true
										willBeAdd.advData = noteData
									else
										willBeAdd.advData = {level=0,offset=0,exists=false}
									end
									
									if(ybiUTF:upper():find("NOTES:3")) then
										local noteData = {}
										local IDX = ybiUTF:upper():find("NOTES:3")
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.level = willBeNumber
										willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.offset = tonumber(willBeNumber)
										noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.exists = true
										willBeAdd.extData = noteData
									else
										willBeAdd.extData = {level=0,offset=0,exists=false}
									end
									
									if(ybiUTF:upper():find("NOTES:1")) then
										local noteData = {}
										local IDX = ybiUTF:upper():find("NOTES:1")
										local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.level = willBeNumber
										
										willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.offset = tonumber(willBeNumber)
										noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
										noteData.exists = true
										willBeAdd.bscData = noteData
									else
										willBeAdd.bscData = {level=0,offset=0,exists=false}
									end
									willBeAdd.isTBJ = true
									local offsets = {willBeAdd.bscData.offset,willBeAdd.advData.offset,willBeAdd.extData.offset}
									local offsetForNow = 0
									for k,v in pairs(offsets) do
										if(v ~= nil) then
											offsetForNow = v
										end
									end
									if(offsetForNow ~= 0) then
										if(willBeAdd.bscData.offset == 0) then
											willBeAdd.bscData.offset = offsetForNow
										end
										if(willBeAdd.advData.offset == 0) then
											willBeAdd.advData.offset = offsetForNow
										end
										if(willBeAdd.extData.offset == 0) then
											willBeAdd.extData.offset = offsetForNow
										end
									end
									willBeAdd.level = {willBeAdd.bscData,willBeAdd.advData,willBeAdd.extData}
									
									local album_ = display.newImage(willBeAdd.albumart or "")
									if(album_ == nil or album_.xScale == nil or album_.width == nil) then
										willBeAdd.title = nil
									end
									display.remove(album_)
									album_ = nil
									if((willBeAdd.title ~= nil and willBeAdd.mp3 ~= nil and willBeAdd.startTime ~= nil and willBeAdd.bpm ~= nil and willBeAdd.albumart ~= nil) or willBeAdd.isTXT) then
										willBeAdd.file = file
										table.insert(globals.lists,willBeAdd)
									end
								end
							end
							
							-- table.insert(files,file)
							-- table.insert(list,path_tb.."/"..file)
						end
					end)
					if(loaded == false) then
						print("FAILED TO LOAD ",path_tb.."/"..file)
					end
				end
				
				local function compare(a,b)
					if(a.title == nil) then
						a.title="ERROR!"
					end
					return a.title:upper() < b.title:upper()
				end
				table.sort(globals.lists,compare)
					
				if(isDir(system.pathForFile(globals.markerPath,system.ResourceDirectory))) then
					for file in lfs.dir(system.pathForFile(globals.markerPath,system.ResourceDirectory)) do
					   --file is the current file or directory name
					   print( "Found file: " .. file )
					   --TODO: check error -hoyo
						if(file ~= "." and file ~= ".." and isDir(system.pathForFile(globals.markerPath..file))) then
							table.insert(markerList,globals.markerPath..file)
							table.insert(markerNameList,file)
							print(file)
						end
					end
				end
				-- --print(dir)
			elseif "Android" == platformName or "iPhone OS" == platformName then
				path = scene.isSDcard
				if "iPhone OS" == platformName then
					path = system.pathForFile("songs")
					path2 = "songs"
				else
					path2 = path
				end
				for file in lfs.dir(path) do
				   --file is the current file or directory name
				   print( "Found file: " .. file )
				   --TODO: check error -hoyo
					local willBeAdd = {}
					willBeAdd.extData = {level=0,exists=false,note="",offset=0}
					willBeAdd.bscData = {level=0,exists=false,note="",offset=0}
					willBeAdd.advData = {level=0,exists=false,note="",offset=0}
					if(file ~= "." and file ~= ".." and isDir(path.."/"..file)) then
						for jbfile in lfs.dir(path.."/"..file) do
							if(string.find(jbfile,".txt") ~= nil and jbfile:find("manifest") == nil) then
								willBeAdd.isTXT = true
								willBeAdd.albumart = "txt.png"
								willBeAdd.title = jbfile:gsub(".txt","")
								willBeAdd.level = {10,10,10}
								willBeAdd.startTime = 20000
								willBeAdd.bpm = 100
								willBeAdd.txtNote = path2.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,".png") ~= nil) then
								willBeAdd.albumart = path2.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,".jpg") ~= nil) then
								willBeAdd.albumart = path2.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,".mp3") ~= nil) then
								willBeAdd.mp3 = path2.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"ext.jmt") ~= nil) then
								willBeAdd.isTXT = false
								willBeAdd.extData.note = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"adv.jmt") ~= nil) then
								willBeAdd.isTXT = false
								willBeAdd.advData.note = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"bsc.jmt") ~= nil) then
								willBeAdd.isTXT = false
								willBeAdd.bscData.note = path.."/"..file.."/"..jbfile
							end
							if(string.find(jbfile,"manifest.txt") ~= nil and willBeAdd.isTXT ~= true) then
								local jmt = io.open(path.."/"..file.."/"..jbfile)
								if(jmt ~= nil) then
									local jmtStr = jmt:read("*all")
									jmt:close()
									local jmtUTF = jmtStr
									willBeAdd.startTime = 20000
									if(jmtUTF:upper():find("BPM=")) then
										local willBeNumber = jmtUTF:sub(jmtUTF:upper():find("BPM=")+4,(jmtUTF:upper():find("\n",jmtUTF:upper():find("BPM=")+4))):gsub("^%s*(.-)%s*$", "%1")
										willBeAdd.bpm = tonumber(willBeNumber) or 160
									end
									if(jmtUTF:upper():find("COMPOSER=")) then
										local composer
										local success = pcall(function()
											composer = jmtUTF:sub(jmtUTF:upper():find("COMPOSER=")+9,(jmtUTF:upper():find("\n",jmtUTF:upper():find("COMPOSER=")+9))):gsub("^%s*(.-)%s*$", "%1")
										end)
										willBeAdd.composer = success and composer or "Various Artist"
									end
									if(jmtUTF:upper():find("NAME=")) then
										willBeAdd.title = jmtUTF:sub(jmtUTF:upper():find("NAME=")+5,(jmtUTF:upper():find("\n",jmtUTF:upper():find("NAME=")+5))):gsub("^%s*(.-)%s*$", "%1")
									end
									if(jmtUTF:upper():find("LEVEL=")) then
										local lvlstr = jmtUTF:sub(jmtUTF:upper():find("LEVEL=")+6,(jmtUTF:upper():find("\n",jmtUTF:upper():find("LEVEL=")+6))):gsub("^%s*(.-)%s*$", "%1")
										lvlstr = split(lvlstr,",")
										willBeAdd.bscData.level = lvlstr[1]
										willBeAdd.advData.level = lvlstr[2]
										willBeAdd.extData.level = lvlstr[3]
									end
								end
							end
						end
						willBeAdd.isTBJ = false
						willBeAdd.level = {willBeAdd.bscData,willBeAdd.advData,willBeAdd.extData}
						local album_ = display.newImage(willBeAdd.albumart or "")
						if(album_ == nil or album_.xScale == nil or album_.width == nil) then
							willBeAdd.title = nil
						end
						display.remove(album_)
						album_ = nil
						if(willBeAdd.title ~= nil and willBeAdd.mp3 ~= nil and willBeAdd.startTime ~= nil and willBeAdd.bpm ~= nil and willBeAdd.albumart ~= nil) then
							willBeAdd.file = file
							table.insert(globals.lists,willBeAdd)
						else
							print("ERROR",willBeAdd.bpm)
						end
					end
				end
				local function find_path_tb1(path_tb,path_tb22)
				-- path_tb = 
					-- if isDir(path_tb) then
						-- for file in lfs.dir(path_tb) do
							 --file is the current file or directory name
							 print( "Found file: " .. path_tb)
							 --TODO: check error -hoyo
							local loaded = pcall(function()
								for tbfile in lfs.dir(path_tb) do
									if(tbfile ~= "." and tbfile ~= "..") then
										if(isDir(path_tb.."/"..tbfile) == true) then
											print("DEEP",path_tb.."/"..tbfile)
											find_path_tb1(path_tb.."/"..tbfile)
										elseif(string.find(tbfile,".ybi") ~= nil) then
											print( "Found file: " .. path_tb.."/"..tbfile)
											local ybi = io.open(path_tb.."/"..tbfile)
											-- for line in ybi:lines() do print(line) end
											local ybiStr = ybi:read("*all")
											local ybiUTF = decode(ybiStr)
											print( "DECODED!" )
											local willBeAdd = {}
											if(ybiUTF:upper():find("#JACKET")) then
											willBeAdd.albumart = trim1(path_tb.."/"..ybiUTF:sub(ybiUTF:upper():find("#JACKET")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#JACKET")+8))))
											end
											if(ybiUTF:upper():find("#AUDIO_FILE")) then
												local willFind = ".MP3"
												if(ybiUTF:upper():find(".OGG")) then
													willFind = ".OGG"
												end
												if(ybiUTF:upper():find(".WAV")) then
													willFind = ".WAV"
												end
												willBeAdd.mp3 = path_tb.."/"..ybiUTF:sub(ybiUTF:upper():find("#AUDIO_FILE")+12,(ybiUTF:upper():find(willFind,ybiUTF:upper():find("#AUDIO_FILE")+12))+3)
											end
											if(ybiUTF:upper():find("#ARTIST")) then
												willBeAdd.composer = ybiUTF:sub(ybiUTF:upper():find("#ARTIST")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#ARTIST")+8))):gsub("^%s*(.-)%s*$", "%1")
											else
												willBeAdd.composer = "Various Artist"
											end
											if(ybiUTF:upper():find("#BGM_START")) then
												local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BGM_START")+11,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BGM_START")+11))):gsub("^%s*(.-)%s*$", "%1")
												willBeAdd.startTime = tonumber(willBeNumber) or 20000
											end
											if(ybiUTF:upper():find("#MUSIC_TIME")) then
												local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#MUSIC_TIME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#MUSIC_TIME")+12))):gsub("^%s*(.-)%s*$", "%1")
												willBeAdd.musicTime = tonumber(willBeNumber)
											end
											if(ybiUTF:upper():find("#BPM_SHOW")) then
												local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BPM_SHOW")+10,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BPM_SHOW")+10))):gsub("^%s*(.-)%s*$", "%1")
												willBeAdd.bpm = tonumber(willBeNumber) or 160
											else
												willBeAdd.bpm = 160
											end
											if(ybiUTF:upper():find("#TITLE_NAME")) then
												willBeAdd.title = ybiUTF:sub(ybiUTF:upper():find("#TITLE_NAME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#TITLE_NAME")+12))):gsub("^%s*(.-)%s*$", "%1")
											end
											
											if(ybiUTF:upper():find("NOTES:2")) then
												local noteData = {}
												local IDX = ybiUTF:upper():find("NOTES:2")
												local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
												noteData.level = willBeNumber
												
												local succeed =  pcall(function() willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1") end)
												noteData.offset = succeed == false and 0 or tonumber(willBeNumber)
												noteData.note = path_tb.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
												noteData.exists = true
												willBeAdd.advData = noteData
											else
												willBeAdd.advData = {level=0,offset=0,exists=false}
											end
											
											if(ybiUTF:upper():find("NOTES:3")) then
												local noteData = {}
												local IDX = ybiUTF:upper():find("NOTES:3")
												local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
												noteData.level = willBeNumber == nil and 0 or willBeNumber
												local succeed =  pcall(function() willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1") end)
												noteData.offset = succeed == false and 0 or tonumber(willBeNumber)
												noteData.note = path_tb.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
												noteData.exists = true
												willBeAdd.extData = noteData
											else
												willBeAdd.extData = {level=0,offset=0,exists=false}
											end
											
											if(ybiUTF:upper():find("NOTES:1")) then
												local noteData = {}
												local IDX = ybiUTF:upper():find("NOTES:1")
												local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
												noteData.level = willBeNumber
												
												local succeed =  pcall(function() willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1") end)
												noteData.offset = succeed == false and 0 or tonumber(willBeNumber)
												noteData.note = path_tb.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
												noteData.exists = true
												willBeAdd.bscData = noteData
											else
												willBeAdd.bscData = {level=0,offset=0,exists=false}
											end
											willBeAdd.isTBJ = true
											local offsets = {willBeAdd.bscData.offset,willBeAdd.advData.offset,willBeAdd.extData.offset}
											local offsetForNow = 0
											for k,v in pairs(offsets) do
												if(v ~= nil) then
													offsetForNow = v
												end
											end
											if(offsetForNow ~= 0) then
												if(willBeAdd.bscData.offset == 0) then
													willBeAdd.bscData.offset = offsetForNow
												end
												if(willBeAdd.advData.offset == 0) then
													willBeAdd.advData.offset = offsetForNow
												end
												if(willBeAdd.extData.offset == 0) then
													willBeAdd.extData.offset = offsetForNow
												end
											end
											willBeAdd.level = {willBeAdd.bscData,willBeAdd.advData,willBeAdd.extData}
											local album_ = display.newImage(willBeAdd.albumart or "")
											if(album_ == nil or album_.xScale == nil or album_.width == nil) then
												willBeAdd.title = nil
											end
											display.remove(album_)
											album_ = nil
											if(willBeAdd.title ~= nil and willBeAdd.mp3 ~= nil and willBeAdd.startTime ~= nil and willBeAdd.bpm ~= nil and willBeAdd.albumart ~= nil) then
												print("FILE",tbfile)
												willBeAdd.file = tbfile
												table.insert(globals.lists,willBeAdd)
											else
												print("FILEERR",tbfile)
											end
										end
									end
									table.insert(globals.files,file)
									-- table.insert(files,file)
									-- table.insert(list,path_tb)
								end
							end)
							if(loaded == false) then
								print("FAILED TO LOAD ",path_tb)
							end
						-- end
					-- end	
				end
				
				if isDir(scene.pathtb) and "iPhone OS" ~= platformName then
					for file in lfs.dir(scene.pathtb) do
						if(file ~= "." and file ~= "..") then
							find_path_tb1(scene.pathtb.."/"..file)
						end
					end
				end
				
				if "iPhone OS" == platformName then
					scene.pathtb2 = system.pathForFile("songs181")
					path_tb2 = "songs181"
				else
					path_tb2 = scene.pathtb2
				end
				
				path_tb = scene.pathtb2
				
				if isDir(path_tb) then
					for file in lfs.dir(path_tb) do
					   --file is the current file or directory name
					   print( "Found file: " .. file)
					   --TODO: check error -hoyo
						local loaded = pcall(function()
							if(file ~= "." and file ~= ".." and isDir(path_tb.."/"..file)) then
								for tbfile in lfs.dir(path_tb.."/"..file) do
									if(string.find(tbfile,".ybi") ~= nil) then
										print( "Found file: " .. path_tb.."/"..file.."/"..tbfile)
										local ybi = io.open(path_tb.."/"..file.."/"..tbfile)
										-- for line in ybi:lines() do print(line) end
										local ybiStr = ybi:read("*all")
										ybi:close()
										local ybiUTF = decode2(ybiStr)
										print( "DECODED!" )
										local willBeAdd = {}
										if(ybiUTF:upper():find("#JACKET")) then
										willBeAdd.albumart = trim1(path_tb2.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#JACKET")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#JACKET")+8))))
										end
										if(ybiUTF:upper():find("#AUDIO_FILE")) then
											local willFind = ".MP3"
											if(ybiUTF:upper():find(".OGG")) then
												willFind = ".OGG"
											end
											if(ybiUTF:upper():find(".WAV")) then
												willFind = ".WAV"
											end
											willBeAdd.mp3 = path_tb2.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#AUDIO_FILE")+12,(ybiUTF:upper():find(willFind,ybiUTF:upper():find("#AUDIO_FILE")+12))+3)
										end
										if(ybiUTF:upper():find("#ARTIST")) then
											willBeAdd.composer = ybiUTF:sub(ybiUTF:upper():find("#ARTIST")+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#ARTIST")+8))):gsub("^%s*(.-)%s*$", "%1")
										else
											willBeAdd.composer = "Various Artist"
										end
										if(ybiUTF:upper():find("#BGM_START")) then
											local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BGM_START")+11,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BGM_START")+11))):gsub("^%s*(.-)%s*$", "%1")
											willBeAdd.startTime = tonumber(willBeNumber)
										end
										if(ybiUTF:upper():find("#MUSIC_TIME")) then
											local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#MUSIC_TIME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#MUSIC_TIME")+12))):gsub("^%s*(.-)%s*$", "%1")
											willBeAdd.musicTime = tonumber(willBeNumber)
										end
										if(ybiUTF:upper():find("#BPM_SHOW")) then
											local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#BPM_SHOW")+10,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#BPM_SHOW")+10))):gsub("^%s*(.-)%s*$", "%1")
											willBeAdd.bpm = tonumber(willBeNumber) or 160
										else
											willBeAdd.bpm = 160
										end
										if(ybiUTF:upper():find("#TITLE_NAME")) then
											willBeAdd.title = ybiUTF:sub(ybiUTF:upper():find("#TITLE_NAME")+12,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#TITLE_NAME")+12))):gsub("^%s*(.-)%s*$", "%1")
										end
										
										if(ybiUTF:upper():find("NOTES:2")) then
											local noteData = {}
											local IDX = ybiUTF:upper():find("NOTES:2")
											local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
											noteData.level = willBeNumber
											
											local succeed =  pcall(function() willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1") end)
											noteData.offset = succeed == false and 0 or tonumber(willBeNumber)
											noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
											noteData.exists = true
											willBeAdd.advData = noteData
										else
											willBeAdd.advData = {level=0,offset=0,exists=false}
										end
										
										if(ybiUTF:upper():find("NOTES:3")) then
											local noteData = {}
											local IDX = ybiUTF:upper():find("NOTES:3")
											local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
											noteData.level = willBeNumber == nil and 0 or willBeNumber
											local succeed =  pcall(function() willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1") end)
											noteData.offset = succeed == false and 0 or tonumber(willBeNumber)
											noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
											noteData.exists = true
											willBeAdd.extData = noteData
										else
											willBeAdd.extData = {level=0,offset=0,exists=false}
										end
										
										if(ybiUTF:upper():find("NOTES:1")) then
											local noteData = {}
											local IDX = ybiUTF:upper():find("NOTES:1")
											local willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#LEVEL",IDX)+7,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#LEVEL",IDX)))):gsub("^%s*(.-)%s*$", "%1")
											noteData.level = willBeNumber
											
											local succeed =  pcall(function() willBeNumber = ybiUTF:sub(ybiUTF:upper():find("#OFFSET",IDX)+8,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#OFFSET",IDX)))):gsub("^%s*(.-)%s*$", "%1") end)
											noteData.offset = succeed == false and 0 or tonumber(willBeNumber)
											noteData.note = path_tb.."/"..file.."/"..ybiUTF:sub(ybiUTF:upper():find("#FILE",IDX)+6,(ybiUTF:upper():find("\n",ybiUTF:upper():find("#FILE",IDX)))):gsub("^%s*(.-)%s*$", "%1")
											noteData.exists = true
											willBeAdd.bscData = noteData
										else
											willBeAdd.bscData = {level=0,offset=0,exists=false}
										end
										willBeAdd.isTBJ = true
										local offsets = {willBeAdd.bscData.offset,willBeAdd.advData.offset,willBeAdd.extData.offset}
										local offsetForNow = 0
										for k,v in pairs(offsets) do
											if(v ~= nil) then
												offsetForNow = v
											end
										end
										if(offsetForNow ~= 0) then
											if(willBeAdd.bscData.offset == 0) then
												willBeAdd.bscData.offset = offsetForNow
											end
											if(willBeAdd.advData.offset == 0) then
												willBeAdd.advData.offset = offsetForNow
											end
											if(willBeAdd.extData.offset == 0) then
												willBeAdd.extData.offset = offsetForNow
											end
										end
										willBeAdd.level = {willBeAdd.bscData,willBeAdd.advData,willBeAdd.extData}
										local album_ = display.newImage(willBeAdd.albumart or "")
										if(album_ == nil or album_.xScale == nil or album_.width == nil) then
											willBeAdd.title = nil
										end
										display.remove(album_)
										album_ = nil
										if(willBeAdd.title ~= nil and willBeAdd.mp3 ~= nil and willBeAdd.startTime ~= nil and willBeAdd.bpm ~= nil and willBeAdd.albumart ~= nil) then
											willBeAdd.file = file
											table.insert(globals.lists,willBeAdd)
										end
									end
								end
								table.insert(globals.files,file)
								-- table.insert(files,file)
								-- table.insert(list,path_tb.."/"..file)
							end
						end)
						if(loaded == false) then
							print("FAILED TO LOAD ",path_tb.."/"..file)
						end
					end
					
					local function compare(a,b)
						if(a.title == nil) then
							a.title="ERROR!"
						end
						return a.title:upper() < b.title:upper()
					end
					table.sort(globals.lists,compare)
					if("iPhone OS" ~= platformName and isDir(globals.markerPath)) then
						for file in lfs.dir(globals.markerPath) do
							if(file ~= "." and file ~= ".." and isDir(globals.markerPath..file)) then
									table.insert(markerList,globals.markerPath..file)
									table.insert(markerNameList,file)
							end
						end
					end
				end
			end
			print("sPath",sPath)
			tablesave.saveTable({globals.lists,globals.files},sPath,nil)
		else
			globals.lists,globals.files = unpack(tablesave.loadTable(sPath,nil))
			if "Win" == platformName then
				if(isDir(system.pathForFile(globals.markerPath,system.ResourceDirectory))) then
					for file in lfs.dir(system.pathForFile(globals.markerPath,system.ResourceDirectory)) do
						 --file is the current file or directory name
						 print( "Found file: " .. file )
						 --TODO: check error -hoyo
						if(file ~= "." and file ~= ".." and isDir(system.pathForFile(globals.markerPath..file))) then
							table.insert(markerList,globals.markerPath..file)
							table.insert(markerNameList,file)
							print(file)
						end
					end
				end
			else
				if(isDir(globals.markerPath)) then
					for file in lfs.dir(globals.markerPath) do
						if(file ~= "." and file ~= ".." and isDir(globals.markerPath..file)) then
								table.insert(markerList,globals.markerPath..file)
								table.insert(markerNameList,file)
						end
					end
				end
			end
		end
		print(display.pixelHeight)
		local pathType = ""
		local idx = 0
		Slevel = display.newText({text="BASIC",x=360,y=80,font=saucer_font,fontSize=70,align="center"})
		
		local right
		local left
		local settings
		settings = display.newImageRect("button_setting.png",720/4,pHeight)
		settings.x,settings.y = coords[15],coords_[15]
		screenGroup:insert(settings)
		settings.width , settings.height = 720/4,pHeight
		display.recalculate(settings)
		settings:addEventListener("touch",
		function(event)
			if(event.phase == "began" and selected ~= nil) then
				-- native.showAlert( "HOYO!", globals.markerPath,scene.isSDcard)
				selected.isVisible = false
				left.isVisible = false
				-- syncT.isVisible = false
				sync_bg.isVisible = false
				right.isVisible = false
				settings.isVisible = false
				local idx = selectedAlbum
				overlay = true
				local i_
				for i_ = 1, 16 do
					if(true and album[i_] ~= nil) then
						if(album[i_] ~= nil) then
							album[i_].isVisible = false
						end
					end
				end
				
				local impath = "thunder"
				local i_marker = nil
				local checkDir = ""
				if markersExists() and "iPhone OS" ~= platformName then
					checkDir = globals.markerPath..markersRead()
				end
				if "Win" == platformName and "iPhone OS" ~= platformName then
					checkDir = system.pathForFile(checkDir,system.ResourceDirectory)
				end
				if(markersExists()  and "iPhone OS" ~= platformName and isDir(checkDir)) then
					local tmp = markersRead()
					impath = tmp
				else
					markersWrite("thunder")
				end
				local imrealpath = "thunder"
				if(impath ~= "thunder") then
					imrealpath = impath
				end
				if(markersRead() ~= "thunder") then
					print(markersRead())
					i_marker = display.newImageRect(globals.markerPath..impath.."/".."cover.png",720/4,pHeight)
				else
					i_marker = display.newImageRect("marker/thunder.png",720/4,pHeight)
				end
				scene.markerIndex = 0
				i_marker.x,i_marker.y = coords[7],coords_[7]
				i_marker.width,i_marker.height = 720/4,pHeight
				display.recalculate(i_marker)
				screenGroup:insert(i_marker)
				panel:toFront()
				local function changeSetting(event)
					if(event.phase == "began") then
						print("BEGAN",scene.markerIndex)
						scene.markerIndex = scene.markerIndex + 1
						scene.markerIndex = scene.markerIndex%(#markerList+1)
						if(scene.markerIndex == 0) then
							display.remove(i_marker)
							i_marker = display.newImageRect("marker/thunder.png",720/4,pHeight)
							i_marker.x,i_marker.y = coords[7],coords_[7]
							screenGroup:insert(i_marker)
							panel:toFront()
							markersWrite("thunder")
						else
							display.remove(i_marker)
							print(system.ResourceDirectory)
							i_marker = display.newImageRect(markerList[scene.markerIndex].."/".."cover.png",720/4,pHeight)
							-- i_marker = display.newImageRect("cover.png",720/4,pHeight)
							print(markerList[scene.markerIndex])
							i_marker.x,i_marker.y = coords[7],coords_[7]
							screenGroup:insert(i_marker)
							panel:toFront()
							markersWrite(markerNameList[scene.markerIndex])
						end
						display.recalculate(i_marker)
						i_marker:addEventListener("touch",changeSetting)
					end
				end
				i_marker:addEventListener("touch",changeSetting)
				local ipath = "play/down.png"
				if(settingsExists()) then
					local tmp = settingsRead()
					if(tmp:find("1") ~= nil) then
						isDown = true
					else
						isDown = false
						ipath = "play/up.png"
					end
				else
					isDown = true
					settingsWrite(true)
				end
				local i_updown = display.newImageRect(ipath,720/4,pHeight)
				i_updown.x,i_updown.y = coords[4],coords_[4]
				i_updown.width,i_updown.height = 720/4,pHeight
				display.recalculate(i_updown)
				screenGroup:insert(i_updown)
				local function changeSetting(event)
					if(event.phase == "began")then
						if(isDown == true) then
							display.remove(i_updown)
							isDown = false
							ipath = "play/up.png"
							i_updown = display.newImageRect(ipath,720/4,pHeight)
							i_updown.x,i_updown.y = coords[4],coords_[4]
							i_updown.width,i_updown.height = 720/4,pHeight
							screenGroup:insert(i_updown)
							settingsWrite(false)
						else
							display.remove(i_updown)
							isDown = true
							ipath = "play/down.png"
							i_updown = display.newImageRect(ipath,720/4,pHeight)
							i_updown.x,i_updown.y = coords[4],coords_[4]
							screenGroup:insert(i_updown)
							settingsWrite(true)
						end
						display.recalculate(i_updown)
						i_updown:addEventListener("touch",changeSetting)
					end
				end
				i_updown:addEventListener("touch",changeSetting)
				local function playNow(index)
					local function file_exists(name)
					   local f = io.open(name,"r")
					   if f~=nil then io.close(f) return true else return false end
					end
					local base = ""
					if "Win" == platformName then
						base = "C:\\hoyobeat\\"
					end
					-- --print(base..lfs.attributes(base..list[idx].."/pt_"..levelIndex..".jmt","mode"))
					local notePos = levelT.note
					if(lvlidx.isTXT) then
						notePos = lvlidx.txtNote
					end
					if "Win" == platformName then
						notePos = system.pathForFile(notePos,system.ResourceDirectory)
					end
					print(notePos)
					if lfs.attributes(notePos,"mode") == "file" then
						local datas = scoreRead(globals.lists[lastSelected].file..".txt")
						print(lvlidx)
						local options =
						{
							time = 2000,
							params =
							{
								pdata = lvlidx,
								levelData = levelT,
								online = isOnline,
								updown = isDown,
								auto = auto,
								clap = clap,
								lists = globals.lists,
								key = key,
								folder = lvlidx.file,
								diff = easy,
								delay = delayRT.text,
								scene = "select",
								dir = list[lastSelected],
								level = levelIndex
							}
						}
						-- --print("changeScene")
						for k,v in pairs(album) do
							if(v ~= nil) then
								display.remove(v)
								album[k] = nil
							end
						end
						display.remove(right)
						display.remove(left)
						display.remove(level)
						if(halt == false) then
							audio.stop(bgmPlay)
							audio.dispose(bgm)
							bgm = nil
							composer.gotoScene( "play", options)
							halt = true
						end
					end
				end
				local i_area = display.newImageRect("play/area.png",720/4,pHeight)
				i_area.x,i_area.y = coords[12],coords_[12]
				i_area.width,i_area.height = 720/4,pHeight
				display.recalculate(i_area)
				screenGroup:insert(i_area)
				i_area:addEventListener("touch",function(event)
					
					if(event.phase == "began") then
						if(areaGroup == nil) then
							areaGroup = display.newGroup()
							scene.areas = {}
							scene.loadedArea = tablesave.loadTable("area.json", system.DocumentsDirectory )
							if(scene.loadedArea == nil) then
								print("init Area")
								tablesave.saveTable({area=1},"area.json", system.DocumentsDirectory )
								scene.loadedArea = tablesave.loadTable("area.json", system.DocumentsDirectory )
							end
							for i = 1,16,1 do
								local area = display.newImageRect("panel_size.png",720/4,pHeight)
								area.x,area.y = coords[i],coords_[i]
								area.alpha = 0.5
								area.xScale,area.yScale = scene.loadedArea.area,scene.loadedArea.area
								display.recalculate(area)
								areaGroup:insert(area)
								table.insert(scene.areas,area)
							end
						end
					end
					if(areaGroup ~= nil) then
						if(event.phase == "began") then
							scene.xLast = event.x
							display.getCurrentStage():setFocus(event.target)
						elseif(event.phase == "moved") then
								scene.loadedArea.area = math.min(1.5,math.max(scene.loadedArea.area+(scene.xLast-event.x)/720,0.5))
								print(scene.loadedArea.area,scene.xLast-event.x)
								for k,v in pairs(scene.areas) do
									v.xScale,v.yScale = scene.loadedArea.area*(display.pixelWidth/720),scene.loadedArea.area*(display.pixelHeight/1280)
								end
								scene.xLast = event.x
						elseif(event.phase == "ended") then
							tablesave.saveTable({area=scene.loadedArea.area},"area.json", system.DocumentsDirectory )
							for k,v in pairs(scene.areas) do
								v.xScale,v.yScale = scene.loadedArea.area*(display.pixelWidth/720),scene.loadedArea.area*(display.pixelHeight/1280)
							end
							display.remove(areaGroup)
							areaGroup = nil
							display.getCurrentStage():setFocus(nil)
						end
					end	
				end)
				local i_diff = display.newImageRect("play/hard.png",720/4,pHeight)
				i_diff.x,i_diff.y = coords[1],coords_[1]
				i_diff.width,i_diff.height = 720/4,pHeight
				screenGroup:insert(i_diff)
				display.recalculate(i_diff)
				i_diff:addEventListener("touch", 
				function(event)
					if(event.phase == "began") then
						if(easy == false) then
							easy = true
							i_hard = display.newImageRect("play/easy.png",720/4,pHeight)
							display.recalculate(i_hard)
							i_hard.x,i_hard.y = coords[1],coords_[1]
							display.recalculate(i_hard)
							screenGroup:insert(i_hard)
							i_hard.width,i_hard.height = 720/4,pHeight
						else
							easy = false
							display.remove(i_hard)
							i_hard = nil
						end
					end
				end)
				local i_auto = display.newImageRect("play/auto off.png",720/4,pHeight)
				i_auto.x,i_auto.y = coords[6],coords_[6]
				i_auto.width,i_auto.height = 720/4,pHeight
				screenGroup:insert(i_auto)
				display.recalculate(i_auto)
				i_auto:addEventListener("touch", 
				function(event)
					if(event.phase == "began") then
						if(auto == false) then
							auto = true
							i_auto2 = display.newImageRect("play/auto.png",720/4,pHeight)
							i_auto2.x,i_auto2.y = coords[6],coords_[6]
							display.recalculate(i_auto2)
							screenGroup:insert(i_auto2)
						else
							auto = false
							display.remove(i_auto2)
							i_auto2 = nil
						end
					end
				end)
				local i_online = display.newImageRect("play/local.png",720/4,pHeight)
				i_online.x,i_online.y = coords[13],coords_[13]
				screenGroup:insert(i_online)
				display.recalculate(i_online)
				i_online:addEventListener("touch", 
				function(event)
					if(event.phase == "began") then
						if(isOnline == false) then
							isOnline = true
							i_online2 = display.newImageRect("play/matching.png",720/4,pHeight)
							i_online2.x,i_online2.y = coords[13],coords_[13]
							screenGroup:insert(i_online2)
							i_online2.width,i_online2.height = 720/4,pHeight
							display.recalculate(i_online2)
						else
							isOnline = false
							display.remove(i_online2)
							i_online2 = nil
						end
					end
				end)
				local i_key = display.newImageRect("play/key.png",720/4,pHeight)
				i_key.x,i_key.y = coords[5],coords_[5]
				i_key.width,i_key.height = 720/4,pHeight
				screenGroup:insert(i_key)
				display.recalculate(i_key)
				i_key:addEventListener("touch", 
				function(event)
					if(event.phase == "began") then
						if(key == true) then
							key = false
							i_nokey = display.newImageRect("play/nokey.png",720/4,pHeight)
							i_nokey.x,i_nokey.y = coords[5],coords_[5]
							screenGroup:insert(i_nokey)
							display.recalculate(i_nokey)
							i_nokey.width,i_nokey.height = 720/4,pHeight
						else
							key = false
							display.remove(i_nokey)
							i_nokey = nil
						end
					end
				end)
				local i_clap = display.newImageRect("play/noclap.png",720/4,pHeight)
				i_clap.x,i_clap.y = coords[3],coords_[3]
				i_clap.width,i_clap.height = 720/4,pHeight
				screenGroup:insert(i_clap)
				display.recalculate(i_clap)
				i_clap:addEventListener("touch", 
				function(event)
					if(event.phase == "began") then
						if(clap == false) then
							clap = true
							i_noclap = display.newImageRect("play/clap.png",720/4,pHeight)
							i_noclap.x,i_noclap.y = coords[3],coords_[3]
							screenGroup:insert(i_noclap)
							display.recalculate(i_noclap)
							i_noclap.width,i_noclap.height = 720/4,pHeight
						else
							clap = false
							display.remove(i_noclap)
							i_noclap = nil
						end
					end
				end)
				local i_play = display.newImageRect("play/start.png",720/4,pHeight)
				i_play.x,i_play.y = coords[16],coords_[16]
				i_play.width,i_play.height = 720/4,pHeight
				screenGroup:insert(i_play)
				display.recalculate(i_play)
				i_play:addEventListener("touch",
				function(event)
					if(event.phase == "began") then
						playNow(selectedAlbum+(idx_-1))
					end
				end)
				local manifest
				local data
				if "Win" == platformName then
					--manifest = io.open("C:\\hoyobeat\\"..list[selectedAlbum+(idx_-1)].."/manifest.txt")
					--data = manifest:read("*a")
				elseif "Android" == platformName then
					--manifest = io.open(list[selectedAlbum+(idx_-1)].."/manifest.txt")
					--data = manifest:read("*a")
				end
				-- local sName_T = string.find(data,"Name=")+string.len("Name=")
				-- local sName = string.gsub(string.gsub(string.sub(data,sName_T,string.find(data,"\n",sName_T)),"\n",""),"\r","")
				
				-- local slvl_T = string.find(data,"Level=")+string.len("Level=")
				-- -- --print(slvl_T)
				-- local slvl = string.sub(data,slvl_T,string.find(data,"\n",slvl_T))
				sName = globals.lists[selectedAlbum+(idx_-1)].title
				
				if(levelIndex == "bsc") then
					levelT = globals.lists[selectedAlbum+(idx_-1)].level[1]
					lvlidx = globals.lists[selectedAlbum+(idx_-1)]
				end
				if(levelIndex == "adv") then
					levelT = globals.lists[selectedAlbum+(idx_-1)].level[2]
					lvlidx = globals.lists[selectedAlbum+(idx_-1)]
				end
				if(levelIndex == "ext") then
					levelT = globals.lists[selectedAlbum+(idx_-1)].level[3]
					lvlidx = globals.lists[selectedAlbum+(idx_-1)]
				end
				
				levels = globals.lists[selectedAlbum+(idx_-1)].level
				
				if(scoreExists(globals.lists[selectedAlbum+(idx_-1)].file..".txt") == false) then print("Initalizing score "..globals.lists[selectedAlbum+(idx_-1)].file..".txt") scoreWrite(globals.lists[selectedAlbum+(idx_-1)].file..".txt",sName) end
				if(scoreExists(globals.lists[selectedAlbum+(idx_-1)].file..".txt") == true) then
					datas = scoreRead(globals.lists[selectedAlbum+(idx_-1)].file..".txt")
				end
				local datas = scoreRead(globals.lists[selectedAlbum+(idx_-1)].file..".txt")
				local delay = delayRead(globals.lists[selectedAlbum+(idx_-1)].file)
				--print(delay)
				--print(delay)
				--print(delay)
				local delayT = display.newText({text="Delay",x=coords[2],y=coords_[2]-50,font=saucer_font,fontSize=50,align="center"})
				delayRT = display.newText({text=tostring(delay),x=coords[2],y=coords_[2]+10,font=saucer_font,fontSize=100,align="center"})
				if(delay == "tbj") then
					delayRT.isTBJT2 = true
					delayRT.text = "1550t"
				else
					delayRT.isTBJT2 = false
				end
				screenGroup:insert(delayT)
				screenGroup:insert(delayRT)
				local function onStepperPress(event) 
					local dataNow = scoreRead(globals.lists[selectedAlbum+(idx_-1)].file..".txt")
					--print(event.phase)
					if ( "increment" == event.phase ) then
						if(delayRT.isTBJT2 == false and tonumber(delayRT.text) + 5 <= 1500) then
							delayRT.text = tostring(tonumber(delayRT.text) + 5)
							delayWrite(globals.lists[selectedAlbum+(idx_-1)].file,tostring(delayRT.text))
							--print("INC")
						elseif(globals.lists[selectedAlbum+(idx_-1)].isTBJ and delayRT.isTBJT2 == false) then
							delayRT.isTBJT2 = true
							delayRT.text = "1550t"
							delayWrite(globals.lists[selectedAlbum+(idx_-1)].file,"tbj")
						end
					elseif ( "decrement" == event.phase ) then
						if(delayRT.isTBJT2 == true) then
							delayRT.isTBJT2 = false
							delayRT.text = "0"
							delayWrite(globals.lists[selectedAlbum+(idx_-1)].file,"0")
						elseif(tonumber(delayRT.text) - 5 >= -1500) then
							delayRT.text = tostring(tonumber(delayRT.text) - 5)
							delayWrite(globals.lists[selectedAlbum+(idx_-1)].file,tostring(delayRT.text))
							--print("DEC")
						end
					end
				end
				local options_ = 
				{
					x = coords[2],
					y = coords_[2]+50,
					minimumValue = -156464,
					onPress = onStepperPress,
					timerIncrementSpeed = 150,
				}
				local step = widget.newStepper( options_ )
				display.recalculate(step)
				screenGroup:insert(step)
				local markerSpeed = markerSpeedRead()
				local markerSpeedT = display.newText({text="marker",x=coords[8],y=coords_[8]-50,font=saucer_font,fontSize=50,align="center"})
				markerSpeedRT = display.newText({text=tostring(markerSpeed),x=coords[8],y=coords_[8]+10,font=saucer_font,fontSize=100,align="center"})
				screenGroup:insert(markerSpeedT)
				screenGroup:insert(markerSpeedRT)
				local function onStepperPress2(event) 
					local dataNow = scoreRead(globals.lists[selectedAlbum+(idx_-1)].file..".txt")
					--print(event.phase)
					if ( "increment" == event.phase ) then
						if(tonumber(markerSpeedRT.text) + 1 <= 950) then
							markerSpeedRT.text = tostring(tonumber(markerSpeedRT.text) + 1)
							markerSpeedWrite(tostring(markerSpeedRT.text))
						end
					elseif ( "decrement" == event.phase ) then
						if(tonumber(markerSpeedRT.text) - 1 >= 400) then
							markerSpeedRT.text = tostring(tonumber(markerSpeedRT.text) - 1)
							markerSpeedWrite(tostring(markerSpeedRT.text))
							--print("DEC")
						end
					end
				end
				local options_ = 
				{
					x = coords[8],
					y = coords_[8]+50,
					minimumValue = -156464,
					onPress = onStepperPress2,
					timerIncrementSpeed = 150,
				}
				local markerSpeedStep = widget.newStepper( options_ )
				screenGroup:insert(markerSpeedStep)
				display.recalculate(markerSpeedStep)
				local i_exit = display.newImageRect("play/exit.png",720/4,pHeight)
				i_exit.x,i_exit.y = coords[15],coords_[15]
				screenGroup:insert(i_exit)
				display.recalculate(i_exit)
				i_exit.width,i_exit.height = 720/4,pHeight
				timer.performWithDelay(300,function()
					if(i_exit ~= nil and i_exit.x ~= nil) then
						i_exit:addEventListener("touch",
							function()
							local i__
							for i__ = 1, 16 do
								if(album[i__] ~= nil and i__ ~= selectedAlbum) then
									album[i__].isVisible = true
								end
							end
							overlay = false
							display.remove(i_area)
							display.remove(i_exit)
							display.remove(i_play)
							display.remove(i_diff)
							display.remove(i_hard)
							display.remove(i_clap)
							display.remove(i_noclap)
							display.remove(i_key)
							display.remove(i_nokey)
							display.remove(i_auto)
							display.remove(i_marker)
							display.remove(i_updown)
							display.remove(i_auto2)
							display.remove(i_online)
							display.remove(i_online2)
							-- display.remove(delay)
							display.remove(delayT)
							display.remove(delayRT)
							display.remove(step)
							display.remove(markerSpeedT)
							display.remove(markerSpeedRT)
							display.remove(markerSpeedStep)
							selected.isVisible = true
							left.isVisible = true							
							-- syncT.isVisible = true
							sync_bg.isVisible = true
							right.isVisible = true
							settings.isVisible = true
						end)
					end
				end)
			end
		end)
		if(levelIndex == nil) then
			levelIndex = "bsc"
			levelIndexN = 1
		end
		Slevel.isVisible = false
		
		local function touch(idx,event,kk)
		if(event.phase == "began") then
				--print(idx)
				display.remove(selected)
				display.remove(mainAlbum)
				display.remove(mainAlbumName)
				display.remove(maxSC)
				display.remove(maxSCT)
				display.remove(lastSC)
				display.remove(lastSCT)
				display.remove(LVL)
				display.remove(LVT)
				if(album[selectedAlbum] ~= nil) then
					album[selectedAlbum].isVisible = true
				end
				selectedAlbum = idx-(idx_-1)
				lastIDX = idx_
				lastSelectedAlbum = selectedAlbum
				--print(selectedAlbum)
				audio.stop(bgmPlay)
				audio.dispose(bgm)
				bgm = nil
				lastSelected = selectedAlbum+(idx_-1)
				if "Win" == platformName then
					--manifest = io.open("C:\\hoyobeat\\"..list[selectedAlbum+(idx_-1)].."/manifest.txt")
					bgm = audio.loadStream(globals.lists[selectedAlbum+(idx_-1)].mp3)
					--data = manifest:read("*a")
				elseif "Android" == platformName or "iPhone OS" == platformName then
					--manifest = io.open(list[selectedAlbum+(idx_-1)].."/manifest.txt")
					bgm = audio.loadStream(globals.lists[selectedAlbum+(idx_-1)].mp3)
					--data = manifest:read("*a")
				end
				-- local sName_T = string.find(data,"Name=")+string.len("Name=")
				-- local sName = string.gsub(string.gsub(string.sub(data,sName_T,string.find(data,"\n",sName_T)),"\n",""),"\r","")
				sName = globals.lists[selectedAlbum+(idx_-1)].title
				audio.seek(globals.lists[selectedAlbum+(idx_-1)].startTime,bgm)
				audio.setVolume(1,{channel=freeChan})
				bgmPlay = audio.play(bgm,{fadeIn=4000,loops = -1,channel=freeChan})
				-- local slvl_T = string.find(data,"Level=")+string.len("Level=")
				-- -- --print(slvl_T)
				-- local slvl = string.sub(data,slvl_T,string.find(data,"\n",slvl_T))
				
				if(levelIndex == "bsc") then
					levelT = globals.lists[selectedAlbum+(idx_-1)].level[1]
					lvlidx = list[selectedAlbum+(idx_-1)]
				end
				if(levelIndex == "adv") then
					levelT = globals.lists[selectedAlbum+(idx_-1)].level[2]
					lvlidx = list[selectedAlbum+(idx_-1)]
				end
				if(levelIndex == "ext") then
					levelT = globals.lists[selectedAlbum+(idx_-1)].level[3]
					lvlidx = list[selectedAlbum+(idx_-1)]
				end
				
				levels = globals.lists[selectedAlbum+(idx_-1)].level
				
				album[selectedAlbum].isVisible = false
				mainAlbum = display.newImageRect(albumPath[selectedAlbum],200,200)
				mainAlbum.x,mainAlbum.y = 100,100
				mainAlbumName = display.newText({text=sName,x=220,y=50,font=saucer_font,fontSize=45})
				mainAlbumName.anchorX = 0
				display.recalculate(mainAlbum)
				local roomPropertiesTable = {}  
				roomPropertiesTable[SV_CHANNEL] = 1
				roomPropertiesTable[crypto.digest(crypto.md5,sName):sub(1,5)] = 1
				--print(SV_CHANNEL,crypto.digest(crypto.md5,sName):sub(1,5))
				--print(SV_CHANNEL,sName,sName:len())
				-- -- appWarpClient.getRoomsWithProperties(roomPropertiesTable)
				screenGroup:insert(mainAlbum)
				screenGroup:insert(mainAlbumName)
				selected = display.newImageRect("select_"..(levelIndex):upper()..".png",720/4,pHeight)
				selected.x,selected.y = coords[selectedAlbum],coords_[selectedAlbum]
				display.recalculate(selected)
				screenGroup:insert(selected)
				local function updateSelect(event)
					if(event.phase == "began") then
						local datas
						if(true) then
							datas = scoreRead(globals.lists[selectedAlbum+(idx_-1)].file..".txt")
						end
						if(Slevel.text == "BASIC")  then
							Slevel.text = "ADVENCED"
							levelIndex = "adv"
							levelIndexN = 2
							if(true) then
								lastSCT.text = datas[5]
								maxSCT.text = datas[7]
								LVT.text = levels[2].level
							end
						elseif(Slevel.text == "ADVENCED")  then
							Slevel.text = "EXTREME"
							levelIndex = "ext"
							levelIndexN = 3
							if(true) then
								lastSCT.text = datas[6]
								maxSCT.text = datas[8]
								LVT.text = levels[3].level
							end
						elseif(Slevel.text == "EXTREME")  then
							Slevel.text = "BASIC"
							levelIndex = "bsc"
							levelIndexN = 1
							if(true) then
								lastSCT.text = datas[1]
								maxSCT.text = datas[2]
								LVT.text = levels[1].level
							end
						end
					end
					display.remove(selected)
					selected = display.newImageRect("select_"..(levelIndex):upper()..".png",720/4,pHeight)
					selected.x,selected.y = coords[selectedAlbum],coords_[selectedAlbum]
					selected.width = 720/4
					selected.height = 720/4
					display.recalculate(selected)
					screenGroup:insert(selected)
					selected:addEventListener("touch",updateSelect)
				end
				selected.width = 720/4
				selected.height = 720/4
				selected:addEventListener("touch",updateSelect)
				local datas = {}
				if(scoreExists(globals.lists[selectedAlbum+(idx_-1)].file..".txt") == false) then print("Initalizing score "..globals.lists[selectedAlbum+(idx_-1)].file..".txt") scoreWrite(globals.lists[selectedAlbum+(idx_-1)].file..".txt",sName) end
				if(scoreExists(globals.lists[selectedAlbum+(idx_-1)].file..".txt") == true) then
					datas = scoreRead(globals.lists[selectedAlbum+(idx_-1)].file..".txt")
				end
				local lastT
				local maxT	
				if(levelIndex == "bsc") then
					lastT = datas[1]
					maxT = datas[2]
				elseif(levelIndex == "adv") then
					lastT = datas[5]
					maxT = datas[7]
				else
					lastT = datas[6]
					maxT = datas[8]
				end
				lastSC = display.newText({text="Last Score",x=220,y=100,font=saucer_font,fontSize=50,align="center"})
				lastSC.anchorX = 0
				screenGroup:insert(lastSC)
				lastSCT = display.newText({text=lastT,x=220,y=150,font=saucer_font,fontSize=45,align="center"})
				screenGroup:insert(lastSCT)
				lastSCT.anchorX = 0
				maxSC = display.newText({text="Max Score",x=480,y=100,font=saucer_font,fontSize=50,align="center"})
				screenGroup:insert(maxSC)
				maxSC.anchorX = 0
				maxSCT = display.newText({text=maxT,x=480,y=150,font=saucer_font,fontSize=45,align="center"})
				screenGroup:insert(maxSCT)
				maxSCT.anchorX = 0
				LVL = display.newText({text="Level",x=220,y=190,font=saucer_font,fontSize=40,align="center"})
				LVL.anchorX = 0
				screenGroup:insert(LVL)
				LVT = display.newText({text=levelT.level,x=360,y=190,font=saucer_font,fontSize=40,align="center"})
				screenGroup:insert(LVT)
				
			end
		end
		local function draw(i)
			local j
			local k_ = 0
			for j = i,i+11,1 do
				k_ = k_+1
				if(globals.lists[j] ~= nil) then
					local album_ = display.newImageRect(globals.lists[j].albumart,720/4-10,pHeight-10)
					if(album_ ~= nil and album_.xScale ~= nil and album_.width ~= nil) then
						local data
						local manifest
						album_.x,album_.y = coords[k_],coords_[k_]
						album[k_] = album_
						albumPath[k_] = globals.lists[j].albumart
						display.recalculate(album_)
						screenGroup:insert(album_)
						--print(albumPath[k_]..k_)
					end
				end
			end 
			for k,v in pairs(album) do
				if(v ~= nil) then
					-- v.width,v.height = 720/4-14,pHeight-15
					panel:toFront()
					v.alpha = 1
					-- --print(i)
					-- --print(k)
					v:addEventListener("touch",function(event) if(event.phase == "began") then touch(i+(k-1),event,k) end end)
				end
			end
		end
		local pressTimeR
		local pressTimeL
		right = display.newImageRect("button_right.png",720/4,pHeight)
		right.x,right.y = coords[14],coords_[14]
		screenGroup:insert(right)
		right.width , right.height = 720/4,pHeight
		display.recalculate(right)
		local function rightT()
			display.remove(selected)
			bgm = nil
			if(idx_ + 12 <= #globals.lists) then
				for k,v in pairs(album) do
					if(v ~= nil) then
						albumPath[k] = nil
						display.remove(v)
						album[k] = nil
					end
				end
				idx_ = idx_ + 12
				draw(idx_)
			end
		end
		right:addEventListener("touch",
		function(event)
			if(event.phase == "began" and overlay == false) then
				print("RESETLPR")
				tc = 300
				pressTimeR = system.getTimer()
				rightT()
			end
			if(event.phase == "ended") then
				pressTimeR = nil	
			end
		end)
		left = display.newImageRect("button_left.png",720/4,pHeight)
		left.x,left.y = coords[13],coords_[13]
		display.recalculate(left)
		screenGroup:insert(left)
		local function leftT()
			display.remove(selected)
			-- if(bgm ~= nil) then
				-- audio.stop(bgmPlay)
				-- audio.dispose(bgm)
			-- end
			bgm = nil
			if(idx_ - 12 > 0) then
				for k,v in pairs(album) do
					if(v ~= nil) then
						albumPath[k] = nil
						display.remove(v)
						album[k] = nil
					end
				end
				idx_ = idx_ - 12
				draw(idx_)
			end
		end
		left.width , left.height = 720/4,pHeight
		left:addEventListener("touch",
		function(event)
			if(event.phase == "began" and overlay == false) then
				print("RESETLPR")
				tc = 300
				pressTimeL = system.getTimer()
				leftT()
			end
			if(event.phase == "ended") then
				pressTimeL = nil
			end
		end)
		if(lastIDX == nil) then
			draw(idx_)
		else
			draw(lastIDX)
		end
		if(#list >= 1 and lastSelected ~= nil) then
			if "Win" == platformName then
				--manifest = io.open("C:\\hoyobeat\\"..list[lastSelected].."/manifest.txt")
				--data = manifest:read("*a")
			elseif "Android" == platformName then
				--manifest = io.open(list[lastSelected].."/manifest.txt")
				--data = manifest:read("*a")
			end
			-- local sName_T = string.find(data,"Name=")+string.len("Name=")
			local function trim1(s)
				return (s:gsub("^%s*(.-)%s*$", "%1"))
			end
			-- local sName = trim1(string.sub(data,sName_T,string.find(data,"\n",sName_T)))
			sName = globals.lists[lastSelected].title
			local slvl_T = string.find(data,"Level=")+string.len("Level=")
			-- --print(slvl_T)
			local slvl = string.sub(data,slvl_T,string.find(data,"\n",slvl_T))
			
			if(levelIndex == "bsc") then
				levelT = globals.lists[lastSelected].level[1]
				lvlidx = list[selectedAlbum+(idx_-1)]
			end
			if(levelIndex == "adv") then
				levelT = globals.lists[lastSelected].level[2]
				lvlidx = list[selectedAlbum+(idx_-1)]
			end
			if(levelIndex == "ext") then
				levelT = globals.lists[lastSelected].level[3]
				lvlidx = list[selectedAlbum+(idx_-1)]
			end
			levels = globals.lists[lastSelected].level
			selectedAlbum = lastSelectedAlbum
			print("SEL",selectedAlbum)
			album[selectedAlbum].isVisible = false
			mainAlbum = display.newImageRect(albumPath[selectedAlbum],200,200)
			mainAlbum.x,mainAlbum.y = 100,100
			mainAlbum.width,mainAlbum.height = 200,200
			display.recalculate(mainAlbum)
			mainAlbumName = display.newText({text=sName,x=220,y=50,font=saucer_font,fontSize=45})
			mainAlbumName.anchorX = 0
			screenGroup:insert(mainAlbum)
			screenGroup:insert(mainAlbumName)
			selected = display.newImageRect("select_"..(levelIndex):upper()..".png",720/4-15,pHeight-15)
			selected.x,selected.y = coords[selectedAlbum],coords_[selectedAlbum]
			selected.width = 720/4
			selected.height = 720/4
			display.recalculate(selected)
			local datas = {}
			if(scoreExists(globals.lists[lastSelected].file..".txt") == false) then print("Initalizing score "..globals.lists[lastSelected].file..".txt") scoreWrite(globals.lists[lastSelected].file..".txt",sName) end
			if(scoreExists(globals.lists[lastSelected].file..".txt") == true) then
				datas = scoreRead(globals.lists[lastSelected].file..".txt")
			end
			local lastT
			local maxT	
			if(levelIndex == "bsc") then
				lastT = datas[1]
				maxT = datas[2]
			elseif(levelIndex == "adv") then
				lastT = datas[5]
				maxT = datas[7]
			else
				lastT = datas[6]
				maxT = datas[8]
			end
			lastSC = display.newText({text="Last Score",x=20,y=220,font=saucer_font,fontSize=50,align="center"})
			lastSC.anchorX = 0
			screenGroup:insert(lastSC)
			lastSCT = display.newText({text=lastT,x=20,y=260,font=saucer_font,fontSize=45,align="center"})
			screenGroup:insert(lastSCT)
			lastSCT.anchorX = 0
			maxSC = display.newText({text="Max Score",x=20,y=300,font=saucer_font,fontSize=50,align="center"})
			screenGroup:insert(maxSC)
			maxSC.anchorX = 0
			maxSCT = display.newText({text=maxT,x=20,y=340,font=saucer_font,fontSize=45,align="center"})
			screenGroup:insert(maxSCT)
			maxSCT.anchorX = 0
			LVL = display.newText({text="Level",x=330,y=220,font=saucer_font,fontSize=45,align="center"})
			LVL.anchorX = 0
			screenGroup:insert(LVL)
			LVT = display.newText({text=levelT.level,x=395,y=260,font=saucer_font,fontSize=45,align="center"})
			screenGroup:insert(LVT)
			if "Win" == platformName then
				--manifest = io.open("C:\\hoyobeat\\"..list[lastSelected].."/manifest.txt")
				bgm = audio.loadStream(globals.lists[lastSelected].mp3)
				--data = manifest:read("*a")
			elseif "Android" == platformName then
				--manifest = io.open(list[lastSelected].."/manifest.txt")
				bgm = audio.loadStream(globals.lists[lastSelected].mp3)
				--data = manifest:read("*a")
			end
			audio.seek(globals.lists[lastSelected].startTime,bgm)
			bgmPlay = audio.play(bgm,{fadeIn=4000,loops = -1,channel=audio.findFreeChannel()})
		end
		Runtime:addEventListener("enterFrame",function()
			if(pressTimeR ~= nil) then
				if(system.getTimer() > pressTimeR + math.max(tc,50)) then
					tc = tc - 100
					pressTimeR = system.getTimer()
					-- print("LPR",pressTimeR,system.getTimer())
					rightT()
				end
			end
			if(pressTimeL ~= nil) then
				if(system.getTimer() > pressTimeL + math.max(tc,50)) then
					tc = tc - 100
					pressTimeL = system.getTimer()
					-- print("LPR",pressTimeR,system.getTimer())
					leftT()
				end
			end
		end)
		-- local th2 = display.newImage("marker/base2.png",360,520)
		-- dg:insert(th)
		-- local th = display.newImage("marker/base2.png",400,400)
		-- th.fill.blendMode =  { srcColor="srcColor",dstColor="ConstantColor"}
		-- th.fill.effect = "filter.monotone"
		

		-- th.fill.effect.coefficients =
		-- {
				-- 1, 0, 1, 0,  --red coefficients
				-- 1, 0, 1, 0,  --green coefficients
				-- 1, 0, 1, 0,  --blue coefficients
				-- 1, 1, 1, 1   --alpha coefficients
		-- }
		-- th.fill.effect.bias = { 1, 1, 1, 0 }
		-- display.save(dg,{filename="saved.png",  baseDir=system.DocumentsDirectory, isFullResolution=true, backgroundColor={0,0} })
		-- th2.fill.blendMode =  { srcColor="srcColor", dstColor="oneMinusSrcColor" }
		-- th:setFillColor(4,4,4)
	end
end
-- local function onGetMatchedRoomsDone(resultCode, roomsTable)
	-- if(resultCode == WarpResponseResultCode.SUCCESS) then
		-- for k,v in pairs(roomsTable) do
			-- -- appWarpClient.getLiveRoomInfo(v["id"])
		-- end
	-- end
-- end
-- local function onConnectDone_S(resultCode)
	-- print("CONNECT DONE S")
	-- if(resultCode == WarpResponseResultCode.SUCCESS and #list >= 1) then
	-- end
-- end
-- local function onGetLiveRoomInfoDone(resultCode,roomsTable)
	-- if(resultCode == WarpResponseResultCode.SUCCESS) then
		-- local matchIDX
		-- for k,v in pairs(roomsTable["propertyTable"]) do
			-- for iik = 1,12 do
				-- if(album[iik] ~= nil and album[iik].tag ~= nil) then
					-- if(k:find(album[iik].tag) or (album[iik].tag):find(k)) then
						-- print("RES",k,v)
						-- matchIDX = iik
					-- end
				-- end
			-- end
		-- end
		-- print("RES2",#roomsTable["joinedUsersTable"])
		-- if(#roomsTable["joinedUsersTable"] == 1 and matchIDX ~= nil) then
			-- print("RES3")
			-- matching[matchIDX].isVisible = true
		-- elseif(matchIDX ~= nil and matching[matchIDX].isVisible ~= true) then
			-- matching[matchIDX].isVisible = false
		-- end
	-- else
		-- print("ERR",resultCode)
	-- end
-- end
-- appWarpClient.addRequestListener("onGetMatchedRoomsDone", onGetMatchedRoomsDone)
-- appWarpClient.addRequestListener("onGetLiveRoomInfoDone", onGetLiveRoomInfoDone)
-- appWarpClient.addRequestListener("onConnectDone", onConnectDone_S)
-- Called when scene is about to move offscreen:
function scene:hide( event )
	local screenGroup = self.view
	display.remove(panel)
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	local screenGroup = self.view
	transition.cancel()
	for ik=1,screenGroup.numChildren do
		display.remove(screenGroup[ik])
		screenGroup[ik] = nil
	end	
	display.remove(screenGroup)
	screenGroup = nil
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

------------	---------------------------------------------------------------------

return scene