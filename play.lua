
require("kconv")
local loadsave = require("replay")
local socket = require "socket"
local crypto = require "crypto"
local widget = require "widget"
local TouchMgr = require( "dmc_touchmanager" )
local globals = require( "mod_globals" )
local tablesave = require( "tablesave" )
----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local gameNetwork 
if "Android" == system.getInfo("platformName") then
	gameNetwork = require "gameNetwork"
end
-- local self.view = display.newGroup()



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


-- Called immediately after scene has moved onscreen:
local function markersRead()
	local path_ = system.pathForFile( "markers.setting", system.DocumentsDirectory )
	local file = io.open(path_,"r")
	if(file) then
		local toRead
		local indata = file:read("*l")
		io.close(file)
		if(indata == nil) then
			return ""
		end
		return indata
	else
		----print("FATAL:: cannot open file : "..fn)
		return nil
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
function scene:create( event )
	local group = self.view
	local ia = 0
	physics.start()
	scene.markerSpeed = markerSpeedRead()
	scene.markerFactor = (scene.markerSpeed/24)*16
	-- local pHeight = 580*((16/9)/(display.pixelHeight/display.pixelWidth))
	local pHeight = display.pixelWidth
	print("PH",pHeight)
	local function decode(t)
		local toutf = ""
		for code in t:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
			if(string.byte(code) ~= 0) then
				toutf = toutf..code
			end
		end
		return toutf
	end
	local math_ceil = math.ceil
	local function trim(s)
		return (s:gsub("^%s*(.-)%s*$", "%1"))
	end
	local math_abs = function(var)
		if(var > 0) then
			return var
		else
			return -var
		end
	end
	local math_max = math.max
	local math_floor = math.floor
	local math_min = math.min
	local string_rep = string.rep
	local table_remove = table.remove
	local isReplyable
	local replayLoad
	local replaySave
	local replayScore
	-- Runtime:addEventListener("enterFrame", gameLoop)
	if(composer.getSceneName( "previous" ) ~= nil) then
		composer.removeScene(composer.getSceneName( "previous" ))
	end
	
	-- local timeNow = function()
		-- if(scene.isMusicPlayed == true) then
			-- return al.GetSource(scene.bgmSource,al.SAMPLE_OFFSET)/44.1
		-- else
			-- if(scene.stime == nil) then
				-- scene.stime = system.getTimer()
				-- scene.stime2 = system.getTimer()
				-- print("STIME",scene.stime)
			-- end
			-- return system.getTimer() - scene.stime
		-- end
	-- end
	system.activate( "multitouch" )
	system.setTapDelay(0)
	system.setIdleTimer(true)
	--print("init")
	local pt_ent = {}
	local touchedIndexes = {}
	-- local sclap = 
	local goods = {}
	local perfects = {}
	local greats = {}
	local notgoods = {}
	local thunder = {} 
	local ssclap = audio.loadSound("play/clap.mp3")
	local diff = 0
	scene.halted = false
	scene.timers = {}
	local firsttimed = false
	local coords = {}
	local replaySave = {}
	local coords_ = {}
	local s_coords = {}
	local s_coords_ = {}
	local nCombo = 0
	local combo
	local sync
	local combo2
	local combo3
	local dOffset = 0
	local dOffset2 = 0
	local dOffset3 = 0
	local gOffset = 0
	local loadedSettings = tablesave.loadTable("settings.json", system.DocumentsDirectory ) or {sync=0}
	local syncD = loadedSettings.sync
	scene.halt = false
	local smallSprites = {{},{},{}}
	local timers = {}	
	local bscore = 0
	local sending = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	local isRoomCreated = false
	local isDownside = false
	local barcount = 0
	local bx = 200*(display.pixelWidth/720)
	local fbx = 200*(display.pixelWidth/720)
	local bpfc = 0
	local betc = 0
	local bmsc = 0
	local started = false
	local pfc = 0
	local grc = 0
	local gdc = 0
	local bdc = 0
	local msc = 0
	local pt_entities = {}
	local isMultiPlayer = false
	local isAuto = event.params.auto
	local online = event.params.online
	local clap = event.params.clap
	local key = event.params.key
	local isEasy = event.params.diff
	local folder = event.params.folder
	local delay = event.params.delay
	local level = event.params.level
	local levelData = event.params.levelData
	--1550
	local offset = levelData.offset
	local lists = event.params.lists
	local pdata = event.params.pdata
	local isTBJT2 = false
	
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
	if(delayRead(pdata.file) == "tbj" or (type(delay) == "string" and delay:find("1550t") ~= nil)) then
		print(delay)
		delay = 0
		isTBJT2 = true
	end
	lastlevel = level
	--print(isAuto)	
	-- print("offset",offset)
	if(USER_NAME == nil) then	
		USER_NAME = "GUEST-01"
	end
	if(SV_CHANNEL == nil) then
		SV_CHANNEL = "result3"
	end
	local function table_insert(t,v)
		t[#t+1] = v
	end
	local function table_insert_timers(time,onComplete)
		-- for itv = #t,1 do
			-- if(t[itv] == nil) then
				-- table.remove(t,itv)
			-- end
		-- end
		-- t[#t+1] = v
		timer.performWithDelay(time,function() if(scene ~= nil and scene.halted ~= true) then onComplete() end end)
		-- transition.to({},{time=time,onComplete=function(sender) sender = nil onComplete() end})
	end
	-- scene.sclaps = {}
	-- scene.sclapidx = 1
	-- for i7 = 1,20,1 do
		-- -- table_insert(scene.sclaps,)
	-- end
	local hard = 0
	local delayFuncs = {}
	local timeplay
	local _, noteCount = 0
	local base
	local k_ = 1
	local ck_ = 1
	local function updateCombo()
		if(combo ~= nil) then
			if(nCombo >= 5) then
				combo.text = tostring(nCombo)
				-- print(nCombo,tostring(nCombo))
			else
				combo.text = ""
			end
		end
		if(isMultiPlayer) then
			local willsend = string_rep("0",16)
			gameNetwork.request("sendMessage", 
			{
				playerIDs = scene.finalPlayers,
				roomID = scene.roomID,
				message =  tostring(math_floor(score+0.5)).."\n"..tostring(nCombo).."\n"..tostring(sName).."\n"..USER_NAME.."\n"..willsend.."\n"..tostring(scene.localPlayerID)
			})
		end
		-- print("BSC",bscore)
		scene.shutteru.y = math.min(-( pHeight*bscore)/2,0)
		scene.shutterd.y = math.max(pHeight*bscore/2,0)
	end
	local function eom()
		--print("END OF MUSIC")
		if(scene.halted == false) then
			--print("END OF MUSIC2")
			local function scoreRead(fn)
				local path_ = system.pathForFile( fn, system.DocumentsDirectory )
				local file = io.open(path_,"r")
				if(file) then
					local toRead
					local indata = file:read("*a")
					-- --------print(indata)
					local indataSp = {}
					local index_ = 0
					for value in string.gmatch(indata,"[^%s]+") do
						--------print(tostring(index_).." : "..value)
						indataSp[index_] = value
						index_ = index_ + 1
					end
					io.close(file)
					return indataSp
				else
					--------print("FATAL:: cannot open file : "..fn)
					return nil
				end
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
					-- --------print(toWrite.." / "..fn)
					file:write(toWrite)
					io.close(file)
				else
					--------print("FATAL:: cannot open file : "..fn)
				end
			end
			if(bscore ~= nil and scene.halt == false) then
				if(bscore > 1) then
					bscore = 1
				end
				if(bscore<-1) then
					bscore = -1
				end
				table_insert_timers(1000, function()
					timer.performWithDelay(25, function()
						score = math_min(score + bscore*4000,1000000)
						tscore.text = string.format("%07d",math_floor(score+0.5))
					end,25)
				end,1)
				table_insert_timers(4000, function()
					key = true
					local sframe
					if(math_floor(score+0.5) < 500000) then
						sframe = 9
					elseif(math_floor(score+0.5) < 700000) then
						sframe = 8
					elseif(math_floor(score+0.5) < 800000) then
						sframe = 7
					elseif(math_floor(score+0.5) < 850000) then
						sframe = 6
					elseif(math_floor(score+0.5) < 900000) then
						sframe = 5
					elseif(math_floor(score+0.5) < 950000) then
						sframe = 4
					elseif(math_floor(score+0.5) < 980000) then
						sframe = 3
					elseif(math_floor(score+0.5) < 1000000) then
						sframe = 2
					else
						sframe = 1
					end
					
					if(isMultiPlayer) then
					end
					if(scene.rank ~= nil and scene.rank.x ~= nil) then
						local dataNow = scoreRead(folder..".txt")
						if(level == "bsc") then
							scoreMax = dataNow[2]
						elseif(level == "adv") then
							scoreMax = dataNow[5]
						else
							scoreMax = dataNow[8]
						end
						--------print(level)
						--------print(tostring(score)..type(score))
						--------print(tostring(scoreMax)..type(scoreMax))
						if(score > tonumber(scoreMax) and (isAuto ~= true or "Win" == system.getInfo("platformName"))) then
							scoreMax = score
							loadsave.saveTable(replaySave, folder..level.."_replay.json", system.DocumentsDirectory )
						end
						if(level == "bsc" and (isAuto ~= true or "Win" == system.getInfo("platformName"))) then
							scoreWrite(folder..".txt",dataNow[0],math_floor(score+0.5),math_floor(tonumber(scoreMax)+0.5),dataNow[3],dataNow[4],dataNow[5],dataNow[6],dataNow[7],dataNow[8])
						elseif(level == "adv" and (isAuto ~= true or "Win" == system.getInfo("platformName"))) then
							scoreWrite(folder..".txt",dataNow[0],dataNow[1],dataNow[2],dataNow[3],dataNow[4],math_floor(score+0.5),dataNow[6],math_floor(tonumber(scoreMax)+0.5),dataNow[8])
						elseif((isAuto ~= true or "Win" == system.getInfo("platformName"))) then
							scoreWrite(folder..".txt",dataNow[0],dataNow[1],dataNow[2],dataNow[3],dataNow[4],dataNow[5],math_floor(score+0.5),dataNow[7],math_floor(tonumber(scoreMax)+0.5))
						end
						--print(system.pathForFile( folder..level.."_replay.json", system.DocumentsDirectory ))
						combo.isVisible = false
						scene.rank:setFrame(sframe)
						scene.rank.isVisible = true
						rating.isVisible = true
						result.text = "Perfect : "..pfc.."\n".."Great : "..grc.."\n".."Good : "..gdc.."\n".."Bad : "..bdc.."\n".."MISS : "..msc
					end
				end,1)
			end
		else
			-- scene.halted = false
		end
	end
	local function judgeNow(index,tb,js,bs,sc)
		if(scene.halt ~= true) then
			local pjS = tb[index]
			pjS.isVisible = true
			thunder[index].isVisible = false
			table_insert_timers(500,function()
				pjS.isVisible = false
			end)
			
			if(isMultiPlayer) then
				local willsend = string_rep("0",index-1)..js..string_rep("0",(16-index))
				gameNetwork.request("sendMessage", 
				{
					playerIDs = scene.finalPlayers,
					roomID = scene.roomID,
					message =  tostring(math_floor(score+0.5)).."\n"..tostring(nCombo).."\n"..tostring(sName).."\n"..USER_NAME.."\n"..willsend.."\n"..tostring(scene.localPlayerID)
				})
			end
			pjS.frame = 1
			pjS:play()
			-- pjS:toFront()
			local scoreCache = score
			score = scoreCache + sc
			local bscoreCache = bscore + bs/noteCount
			if(bscoreCache > 1) then
				bscoreCache = 1
			elseif(bscoreCache < -1) then
				bscoreCache = -1
			end
			bscore = bscoreCache
			tscore.text = string.format("%07d",math_floor(score+0.5))
			-- print(bscore)
			updateCombo()
		end
	end
	
	function scene:show( event )
		-----------------------------------------------------------------------------
			
		--	CREATE display objects and add them to 'group' here.
		--	Example use-case: Restore 'group' from previously saved state.
		
		-----------------------------------------------------------------------------
		
	end

	-- local function performLater()
		-- local i___ = 1
		-- while(i___ <= #delayFuncs) do
			-- local v = delayFuncs[i___]
			-- if(v ~= nil and system.getTimer()>(v[1])) then
				-- -- ----print(i___)
				-- v[2]()
				-- table_remove(delayFuncs,i___)
			-- else
				-- i___ = i___ + 1
			-- end
		-- end
	-- end

	scene.onKeyEvent = function( event )
		if(true) then
			local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
			if  "back" == event.keyName or "escape" == event.keyName  then
				if event.phase == "down" and scene.halt == false then
					-- --------print( message )
					-- --------print(event.keyName.."aaa")
					-- --------print("HALT1")
					for k,v in pairs(thunder) do
						display.remove(v)
					end
					scene.halt = true
					delayFuncs = {}
					if(setGlobalTouch ~= nil) then
						Runtime:removeEventListener("Htouch",scene.touched)
					end
					Runtime:removeEventListener("touch",scene.touched)
					composer.gotoScene("select")
				end
				-- composer.gotoScene("select")
				return true
			elseif(("back" == event.keyName or "escape" == event.keyName) and not key) then
				return true
			end
			-- if("a" == event.keyName) then
				-- touch(1,"")
			-- elseif("b" == event.keyName) then
				-- touch(2,"")
			-- elseif("c" == event.keyName) then
				-- touch(3,"")
			-- elseif("d" == event.keyName) then
				-- touch(4,"")
			-- elseif("e" == event.keyName) then
				-- touch(5,"")
			-- elseif("f" == event.keyName) then
				-- touch(6,"")
			-- elseif("g" == event.keyName) then
				-- touch(7,"")
			-- elseif("h" == event.keyName) then
				-- touch(8,"")
			-- elseif("i" == event.keyName) then
				-- touch(9,"")
			-- elseif("j" == event.keyName) then
				-- touch(10,"")
			-- elseif("k" == event.keyName) then
				-- touch(11,"")
			-- elseif("l" == event.keyName) then
				-- touch(12,"")
			-- elseif("m" == event.keyName) then
				-- touch(13,"")
			-- elseif("n" == event.keyName) then
				-- touch(14,"")
			-- elseif("o" == event.keyName) then
				-- touch(15,"")
			-- elseif("p" == event.keyName) then
				-- touch(16,"")
			-- end
			if "menu" == event.keyName or "1" == event.keyName then
				if(scene.halt == true and event.phase == "down") then
					-- --------print("ERRRRR")
				end
				if event.phase == "down" and scene.halt == false then
					if(true) then
						-- --------print( message )
						-- --------print("aa")
						-- --------print(lastlevel)
						-- --------print(lastdir)
						-- local options = 
						-- {
							-- params=
							-- {
								-- online2 = online,
								-- diff2 = diff,
								-- clap2 = clap,
								-- level2 = lastlevel,
								-- dir2 = lastdir,
								-- delay2 = delay,
								-- folder2 = folder,
								-- key2 = key,
							-- }
						-- }
						-- --------print("HALT2")
						-- scene.halt = true
						-- display.remove(group)
						-- halt = true	
						-- composer.gotoScene("play",options)	
						-- composer.reloadScene()
						-- local currScene = composer.getSceneName( "current" )
						-- --------print("UCRRRRR",currScene)
						-- composer.gotoScene( "play2",options)
					end
				end
			end
		end
	end

	if "Win" == system.getInfo( "platformName" ) or "iPhone OS" == system.getInfo( "platformName" ) then
		saucer_font = "NanumBarunGothic"
		-- USER_NAME = "(SIMULATOR)hoyo321"
	elseif "Android" == system.getInfo( "platformName" ) then
		saucer_font = "NanumBarunGothic"
	end

	-- local manifest
	-- local data
	-- if(diff == false) then
		-- hard = 1
	-- else	
		-- hard = 0
	-- end
	-- if "Win" == system.getInfo( "platformName" ) then
		-- pdir = "C:\\hoyobeat\\"..event.params.dir
		-- pdir_ = event.params.dir
		-- manifest = io.open("C:\\hoyobeat\\"..event.params.dir.."/manifest.txt")
		-- data = manifest:read("*a")
	-- elseif "Android" == system.getInfo( "platformName" ) then
		-- pdir = event.params.dir
		-- pdir_ = event.params.dir
		-- manifest = io.open(event.params.dir.."/manifest.txt")
		-- data = manifest:read("*a")
	-- end
	
	-- local jmtdir = system.DocumentsDirectory
	-- if "Win" == system.getInfo( "platformName" ) then
		-- jmtdir = pdir.."\\pt_"..level..".jmt"
	-- elseif "Android" == system.getInfo( "platformName" ) then
		-- jmtdir = pdir.."/pt_"..level..".jmt"
	-- end
	-- end
	scene.halt = false
	local group = self.view	
	composer.removeScene(event.params.scene)
	isDownside = event.params.updown
	if(isDownside) then
		dOffset = 360*(720/pHeight)+260
		dOffset2 = pHeight
		dOffset3 = 50
		gOffset2 = 0
		gOffset3 = 0
		gOffset4 = 0
	else
		-- gOffset = pHeight
		gOffset2 = -250
		gOffset3 = -300
		gOffset4 = -165
	end
	for x = 1,4,1 do
		for y = 1,4,1 do
			coords[x+(y-1)*4],coords_[x+(y-1)*4] = (pHeight/4)*x-(pHeight/8)-pHeight/2,(pHeight/4)*y-pHeight/8-pHeight/2
		end
	end
	-- panel = display.newImageRect(screenGroup,"panel_4x4.png",720,pHeight*4)
	-- panel.x,panel.y = 360,(isDownside == true and display.pixelHeight-pHeight*2 or pHeight*2)
	
	s_coords[1],s_coords_[1] = (160/4)*1+25,(160/4)*1+250+gOffset-120
	s_coords[3],s_coords_[3] = (160/4)*3+25,(160/4)*1+250+gOffset-120
	s_coords[2],s_coords_[2] = (160/4)*2+25,(160/4)*1+250+gOffset-120
	s_coords[4],s_coords_[4] = (160/4)*4+25,(160/4)*1+250+gOffset-120
	s_coords[5],s_coords_[5] = (160/4)*1+25,(160/4)*2+250+gOffset-120
	s_coords[6],s_coords_[6] = (160/4)*2+25,(160/4)*2+250+gOffset-120
	s_coords[7],s_coords_[7] = (160/4)*3+25,(160/4)*2+250+gOffset-120
	s_coords[8],s_coords_[8] = (160/4)*4+25,(160/4)*2+250+gOffset-120
	s_coords[9],s_coords_[9] = (160/4)*1+25,(160/4)*3+250+gOffset-120	
	s_coords[10],s_coords_[10] = (160/4)*2+25,(160/4)*3+250+gOffset-120
	s_coords[11],s_coords_[11] = (160/4)*3+25,(160/4)*3+250+gOffset-120
	s_coords[12],s_coords_[12] = (160/4)*4+25,(160/4)*3+250+gOffset-120
	s_coords[13],s_coords_[13] = (160/4)*1+25,(160/4)*4+250+gOffset-120
	s_coords[14],s_coords_[14] = (160/4)*2+25,(160/4)*4+250+gOffset-120
	s_coords[15],s_coords_[15] = (160/4)*3+25,(160/4)*4+250+gOffset-120
	s_coords[16],s_coords_[16] = (160/4)*4+25,(160/4)*4+250+gOffset-120
	if(isDownside) then
		for k,v in pairs(s_coords_) do
			s_coords_[k] = display.pixelHeight - v
		end
	end
	scene.bgm = audio.loadStream(pdata.mp3)
	scene.bpm = pdata.bpm
	scene.bgmPath = pdata.mp3
	-- audio.setVolume(0,{channel=4})
	-- audio.pause(4)
	
	local function firsttime()
		-- transition.to({},{time=10,onComplete=function()
		lastdir = event.params.dir
		--print("FIRSTINIT!!")
		local data_ = ""
		local jmtdir_
		local lvlNote
		if(pdata.isTXT) then
			lvlNote = pdata.txtNote
		else
			lvlNote = levelData.note
		end
		if "Win" == system.getInfo( "platformName" ) then
			jmtdir_ = system.pathForFile(lvlNote,system.ResourceDirectory)
		elseif "Android" == system.getInfo( "platformName" ) or "iPhone OS" == system.getInfo( "platformName" ) then
			jmtdir_ = lvlNote
		end
		local firstLoadedFile = io.open(jmtdir_)
		data_ = firstLoadedFile:read("*a")
		print("OFFSET",offset)
		if(pdata.isTBJ) then
			-- see offset = load.... if you want modify this!
			scene.msFactor = scene.markerFactor
			-- if(offset > 0) then
				-- isTBJT2 = true
			-- end
			_, noteCount = string.gsub(data_, ",", ",")
			perfectScore = (900000/noteCount)
			greatScore = (perfectScore*0.7)
			goodScore = (perfectScore*0.4)
			badScore = (perfectScore*0.1)
		elseif(not pdata.isTXT) then
			-- see offset = load.... if you want modify this!
			scene.msFactor = scene.markerFactor
			_, noteCount = string.gsub(data_, "#", "#")	
			perfectScore = (900000/noteCount)
			greatScore = (perfectScore*0.7)
			goodScore = (perfectScore*0.4)
			badScore = (perfectScore*0.1)
		else
			scene.msFactor = scene.markerFactor
		end
		--print("isTBJ",pdata.isTBJ)
		local function decode(t)
			local toutf = ""
			for code in t:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
				if(string.byte(code) ~= 0) then
					toutf = toutf..code
				end
			end
			return toutf
		end
		if(pdata.isTXT) then
			local function decode2(t)
				-- print(t)
				return kconv.kconvert(t, "sjis", "utf-8")
			end
			-- charContent = "①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯"
			local datas = {}
			local index = 0
			local tmpArray = {}
			local finalArray = {}
			local bpm
			local offset = 0
			local tmp = {}
			local beat
			local lastIndexOf = 0
			local firstBeat
			local chars = {"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩","⑪","⑫","⑬","⑭","⑮","⑯","□"}
			local function compare(a,b)
				return a[1] < b[1]
			end
			-- function table.indexOf(array,data)
				-- local valid = {}
				-- for i = 1, #array do
					-- valid[array[i]] = {true,i}
				-- end
				-- if valid[data] ~= nil then
					-- return valid[data][2]
				-- else
					-- return nil
				-- end
			-- end
			local k = 0
			local tmpOutput = io.open(system.pathForFile("tmp.txt",system.TemporaryDirectory),"w+")
			tmpOutput:write(decode2(io.open(jmtdir_):read("*a")))
			tmpOutput:close()
			local tmpInput = io.open(system.pathForFile("tmp.txt",system.TemporaryDirectory),"r")
			for v in tmpInput:lines() do
				k = k + 1
				local line = v:gsub("^%s*(.-)%s*$", "%1")
				if(k < 6) then
					print(line,line:lower():find("o=",0,true))
				end
				if(line:find("--",0,true) ~= nil) then
					index = index + 1
					offset = offset + beat*16
				elseif(line:lower():find('t=') ~= nil) then
					print(k,"t",line,line:lower():find("t="))
					local tmpVar = line:gsub("t",""):gsub("=",""):gsub("^%s*(.-)%s*$", "%1")
					bpm = tonumber(tmpVar)
					print("BPM",bpm)
					beat = 60000/bpm/4
					if(firstBeat == nil) then
						firstBeat = 60000/bpm/4
						print("FIRST BEAT",firstBeat)
					end
					print("BEAT",beat)
					-- print("("..k..")".." : changing BPM = "..bpm,"beat = "..beat)
				elseif(line:lower():find("o=",0,true)) then
					local tmpVar = line:gsub("o",""):gsub("=",""):gsub("^%s*(.-)%s*$", "%1")
					offset = offset + tonumber(tmpVar)-150
					print("o",offset)
					-- print("("..k..")".." : changing BPM = "..bpm,"beat = "..beat)
				else
					-- if(k >= 6 and k <= 10) then
					-- print("!!",k,line)
					if(line:len() > 8) then
						for c in (line:gmatch("...")) do
						-- for ik = 1,4,1 do
							-- local c = line:sub((ik-1)*3+1,(ik)*3+1)
							if(table.indexOf(chars,c) ~= nil) then
								table.insert(tmp,c)
							end
							-- print(#tmp)
							if(#tmp == 16) then
								for k2,v2 in pairs(tmp) do
									-- print(k2,v2)3
									local indexOf = table.indexOf(chars,v2)
									-- print(k,k2,v2,indexOf)
									if(indexOf ~= nil and indexOf <= 16) then
										-- print(k2,indexOf*beat+(beat*16)*index)
										offset = offset + (indexOf*beat-lastIndexOf)
										lastIndexOf = indexOf*beat
										table.insert(tmpArray,{k2 > 16 and k2 - 16 or k2,offset})
									end
								end
								tmp = {}
								-- print(k,"--",line,line:find("--"))
								-- table.sort(tmpArray,compare)
								table.insert(datas,tmpArray)
								-- print("==========="..index.."===========")
								for k2,v2 in pairs(tmpArray) do
									-- print(k,v2[1]..":"..v2[2])
								end
								tmpArray = {}
							end
						end
					-- print("=!=")
					end
				end
			end
			for k,v in pairs(datas) do
				-- print("==========="..k.."===========")
				for k2,v2 in pairs(v) do
					finalArray[#finalArray+1] = {math.floor(v2[2]),v2[1]}
				end
			end
			table.sort(finalArray,compare)
			timers = finalArray
			noteCount = #finalArray
			perfectScore = (900000/noteCount)
			greatScore = (perfectScore*0.7)
			goodScore = (perfectScore*0.4)
			badScore = (perfectScore*0.1)
		elseif(pdata.isTBJ ~= true) then
			for line in io.lines(jmtdir_) do
					--table.insert(noteArray,line)
					----------print(line)
					-- --------print(last)
					local first = line:find(".",1,true)
					if(first ~= nil) then
					--------print(line)
					--------print(first)
					local index = tonumber(line:sub(2,first-1))
					--------print(line:sub(2,first-1))
					local last = line:find(".",first+1,true)
					if(last == nil) then
						last = line:len()
					end
					local ltime = tonumber(line:sub(first+1,last))
					-- --------print(first.."/"..last..";"..line:sub(first+1,last))
					if(ltime ~= nil and index ~= nil) then
						table.insert(timers,{ltime,index})
					end
				end
			end
			perfectScore = (900000/#timers)
			greatScore = (perfectScore*0.7)
			goodScore = (perfectScore*0.4)
			badScore = (perfectScore*0.1)
			local function compare(a,b)
				return a[1] < b[1]
			end
			table.sort(timers, compare)
		else
			print("TBJ NOTE")
			local noteFile = io.open(jmtdir_)
			local noteData = decode(noteFile:read("*a"))
			-- local diffMT = math.abs((audio.getDuration(scene.bgm) - pdata.musicTime))
			-- local diffMT = pdata.musicTime/150	
			-- offset = offset+2500
			-- offset = diffMT+math.abs(offset)
			-- if(offset > 0) then
			-- else
				-- -- offset = math.abs(offset)*2-150
				-- -- offset = math.abs(offset) * 4 - 2000
				-- -- offset = 1500+(offset-50)-896
			-- end
				-- for iv = 1,16,1 do
					
				-- end
				-- offset = offset * 4 - 
			-- print("MT",diffMT,offset)
			for line in noteData:gmatch("[^\r\n]+") do
					--table.insert(noteArray,line)
					----------print(line)
					-- --------print(last)
					local first = line:find(",",1,true)
					if(first ~= nil) then
					--------print(line)
					--------print(first)
					local index = line:sub(first+1,line:len()):gsub("^%s*(.-)%s*$", "%1")
					index = tonumber(index)
					--------print(line:sub(2,first-1))
					local ltime = tonumber(line:sub(1,first-1))
					-- --------print(first.."/"..last..";"..line:sub(first+1,last))
					if(ltime ~= nil and index ~= nil) then
						table.insert(timers,{ltime,index})
					end
				end
			end
			perfectScore = (900000/#timers)
			greatScore = (perfectScore*0.7)
			goodScore = (perfectScore*0.4)
			badScore = (perfectScore*0.1)
			local function compare(a,b)
				return a[1] < b[1]
			end
			table.sort(timers, compare)
			if(isTBJT2) then
				-- scene.msFactor = 0
				-- print("TBJt2")
				local df = timers[1][1]
				for k,v in pairs(timers) do
					timers[k][1] = v[1]-df+1550
				end	
			else
				local df = timers[1][1]
				print("ODF",timers[1][1])
				print("OTF",offset)
				for k,v in pairs(timers) do
					-- timers[k][1] = v[1]-df+offset-400
					timers[k][1] = v[1]+offset
				end	
			end
		end
		print("DF",timers[1][1])
		scene.bg = _G.nimgr(isDownside and "play/bg_up.png" or "play/bg_down.png",display.pixelWidth,display.pixelHeight - display.pixelWidth)
		scene.bg.x,scene.bg.y = display.pixelWidth/2,isDownside and (display.pixelHeight - display.pixelWidth)/2 or display.pixelWidth + (display.pixelHeight - display.pixelWidth)/2
		group:insert(scene.bg)
		scene.bg.width = display.pixelWidth
		scene.bg.height = display.pixelHeight - display.pixelWidth
		-- display.recalculate(scene.bg)
		-- scene.touchBuffer2 = display.newRect(360,isDownside and display.pixelHeight-pHeight/2 or pHeight/2,720,pHeight)
		-- scene.touchBuffer = display.newRect(360,isDownside and display.pixelHeight-pHeight/2 or pHeight/2,720,pHeight)
		-- scene.touchBuffer = {}
		-- for ik = 1,30,1 do
			-- local touchBuffer = display.newRect(360,isDownside and display.pixelHeight-pHeight/2 or pHeight/2,720,pHeight)
			-- -- touchBuffer.alpha = 0.01
			-- touchBuffer.isVisible = false
			-- touchBuffer.isHitTestable = true
			-- table_insert(scene.touchBuffer,touchBuffer)
			-- group:insert(touchBuffer)
		-- end
		scene.bgContainer = display.newContainer(display.pixelWidth,display.pixelWidth)
		scene.bgContainer.x,scene.bgContainer.y = display.pixelWidth/2,isDownside and display.pixelHeight-display.pixelWidth/2 or display.pixelWidth/2
		scene.bg_ = display.newImageRect("play/bg_dark.png",pHeight,pHeight)
		-- bg_.x,bg_.y = 360,isDownside and display.pixelHeight-pHeight/2 or pHeight/2
		group:insert(scene.bgContainer)
		-- display.recalculate(scene.bgContainer)
		scene.bgContainer:insert(scene.bg_)
		nCombo = 0
		score = 0
		bscore = 0
		dOffset3 = 100
		bpfc = 0
		betc = 0
		barcount = 0
		grc = 0
		gdc = 0
		bdc = 0
		msc = 0
		stime = nil
		if(isDownside) then
			dOffset3 = 100
		end
		audio.play(audio.loadStream("play/ready.ogg"),{channel=7})
		local ready = display.newImageRect("play/ready.png",800,800)
		ready.x,ready.y = 380,330-50+(dOffset)
		display.recalculate(ready)
		ready.xScale,ready.yScale = ready.xScale*0.3,ready.yScale*0.3
		ready:toFront()
		scene.panel = display.newImageRect("play/panel_4x4.png",display.pixelWidth,display.pixelWidth)
		scene.panel2 = display.newImageRect("play/panel_4x4.png",display.pixelWidth,display.pixelWidth)
		scene.panel.x,scene.panel.y = display.pixelWidth/2,isDownside and display.pixelHeight-display.pixelWidth/2 or display.pixelWidth/2
		scene.panel2.x,scene.panel2.y = display.pixelWidth/2,isDownside and display.pixelHeight-display.pixelWidth/2 or display.pixelWidth/2
		group:insert(scene.panel)
		group:insert(scene.panel2)
		-- display.recalculate(scene.panel)
		-- display.recalculate(scene.panel2)
		scene.shutteru = display.newImageRect("play/shutter_above.png",pHeight,pHeight)
		scene.shutterd = display.newImageRect("play/shutter_below.png",pHeight,pHeight)
		
		scene.shutteru.y = -pHeight/2-30
		scene.shutterd.y = pHeight/2+30
		scene.bgContainer:insert(scene.shutteru)
		scene.bgContainer:insert(scene.shutterd)
		-- display.recalculate(scene.shutteru)
		-- display.recalculate(scene.shutterd)
		scene.panel:toFront()
		scene.panel2:toFront()
		scene.bgContainer:toFront()
		scene.panel2.alpha = 0.01
		rating = display.newImageRect("play/rating.png",pHeight,pHeight)
		rating.x,rating.y = pHeight/2,pHeight/2 + (isDownside and display.pixelHeight-pHeight or 0)
		group:insert(rating)
		rating.isVisible = false
		result = display.newText({text="",x=15,y=pHeight/2 + (isDownside and display.pixelHeight-pHeight-pHeight/2 or -pHeight/4),fontSize=40,font=saucer_font})
		result.anchorY = 0
		result.anchorX = 0
		group:insert(result)
		scene.panel:toFront()
		scene.panel2:toFront()
		
		group:insert(ready)
		k_ = 1
		local firsts = {}
		if(timers ~= nil and timers[k_] ~= nil and timers[k_][1] ~= nil) then
			if(true) then
				while(k_ <= #timers and scene.halt == false) do
					local index = timers[k_][2]
					local fimage = display.newImageRect("play/startpoint.png",pHeight/4,pHeight/4)
					fimage.x,fimage.y = coords[index],coords_[index]
					print("FI",fimage.x,fimage.y)
					scene.bgContainer:insert(fimage)
					-- fimage.width,fimage.height = 720/4-14,pHeight/4
					fimage.alpha = 1
					table.insert(firsts,fimage)
					if(timers[k_][1] - timers[k_ + 1][1] < 0) then
						-- --------print("!stimulatly"..timers[k_][1].."/"..timers[k_+1][1])
						k_ = 1
						break
					else
						k_ = k_ + 1
						-- --------print("stimulatly")
					end
				end
			end
		end
		
		scene.infoGroup = display.newGroup()
		albumart = display.newImageRect(pdata.albumart,70,70)
		-- albumart.anchorX = 0
		-- albumart.anchorY = 0.5
		albumart.x = 70
		albumart.y = 70
		-- albumart.y = display.pixelHeight-70-60
		if(isDownside) then
			-- albumart.anchorX = 0
			-- albumart.anchorY = 0.5
		end
		display.recalculate(albumart)
		local sName_T = pdata.title
		sName = sName_T
		if(isAuto == true) then
			sName = sName .. " (AUTOMODE)"
		end
		local lvlidx
		local level2
		local levelColor
		if(level == "bsc") then
			lvlidx = 1
			level2 = "    BASIC"
			levelColor = {0.2,0.2,1}
		end
		if(level == "adv") then
			lvlidx = 2
			level2 = "ADVANCED"
			levelColor = {1,1,0.2}
		end
		if(level == "ext") then
			lvlidx = 3
			level2 = "EXTREME"
			levelColor = {1,0.2,0.2}
		end
		-- --------print("slvl"..slvl)
		
		local levelT = levelData.level
		if(pdata.isTXT) then
			levelT = "10"
		end
		aLVLCT = display.newText({text=level2,x=200,y=70,fontSize=30,font=saucer_font})
		aLVLCT.anchorX = 0.5
		aLVLCT.anchorY = 1
		aLVLCT:setFillColor(unpack(levelColor))
		aLVL = display.newText({text="LEVEL: "..levelT,x=120,y=70,fontSize=35,font=saucer_font})
		aLVL.anchorX = 0
		aLVL.anchorY = 0
		-- local LVL = display.newGroup()
		-- LVL.anchorX = 0.5
		-- display.recalculateS(LVL)
		-- local levelSheet = graphics.newImageSheet("play/LVL_num.png", { width=460/5, height=260/2, numFrames=10,sheetContentWidth = 460,sheetContentHeight = 260})
		-- local lastWidth = 0
		-- print("LT",levelT)
		-- for ik = 1,#tostring(levelT) do
			-- local n_lvlFrame = ((tonumber(levelT:sub(ik,ik)) or 0)+1)%11
			-- print(n_lvlFrame)
			-- local lvlFrame = display.newImageRect(levelSheet,n_lvlFrame,40,65)
			-- -- lvlFrame.width = 40
			-- lastWidth = lastWidth + 40
			-- -- lvlFrame.height = 65
			-- lvlFrame.x = (ik-1)*40
			-- lvlFrame.y = 0
			-- display.recalculate(lvlFrame)
			-- LVL:insert(lvlFrame)
		-- end
		-- LVL.x = 120 + aLVL.width + (levelT:sub(1,1) == "1" and -10 or 5) + 10
		-- LVL.y = aLVL.y+45
		-- display.recalculate(LVL)
		aName = display.newText({text=sName,x=500,y=75,fontSize=25,font=saucer_font,width=350,height=25,align="center"})
		aName.anchorX = 0.5
		aName.anchorY = 1
		aComposer = display.newText({text=pdata.composer or "(E) Various Artist",x=500,y=75,fontSize=25,font=saucer_font,align="center",width=350,height=25})
		aComposer.anchorX = 0.5
		aComposer.anchorY = 0
		-- display.recalculateS(aName)
		-- display.recalculateS(aComposer)
		print("AC",aComposer.width)
		print("AN",aName.width)
		scene.infoGroup:insert(albumart)
		scene.infoGroup:insert(aName)
		scene.infoGroup:insert(aLVL)
		scene.infoGroup:insert(aLVLCT)
		scene.infoGroup:insert(aComposer)
		if(not isDownside) then
			aLVL.y = display.pixelHeight - aLVL.y
			aLVLCT.y = display.pixelHeight - aLVLCT.y
			aComposer.y = display.pixelHeight - aComposer.y
			aName.y = display.pixelHeight - aName.y
			albumart.y = display.pixelHeight - albumart.y
		end
		-- scene.infoGroup:insert(LVL)
		group:insert(scene.infoGroup)
		if(true) then
			scene.rival = {}
			scene.rivalSC = {}
			scene.grid1 = display.newImageRect("play/grid.png",160,160)
			scene.grid1.x,scene.grid1.y = 150,250
			group:insert(scene.grid1)
			display.recalculate(scene.grid1)
			scene.rivalSC[1] = display.newText({text="",fontSize=25,x=150,y=250-95})
			scene.rival[1] = display.newText({text="",fontSize=30,x=150,y=250+95})
			
			group:insert(scene.rivalSC[1])
			group:insert(scene.rival[1])
			scene.grid2 = display.newImageRect("play/grid.png",160,160)
			scene.grid2.x,scene.grid2.y = 150+620/3,250
			group:insert(scene.grid2)
			display.recalculate(scene.grid2)
			scene.rivalSC[2] = display.newText({text="",fontSize=25,x=150+620/3,y=250-95})
			scene.rival[2] = display.newText({text="",fontSize=30,x=150+620/3,y=250+95})
			group:insert(scene.rivalSC[2])
			group:insert(scene.rival[2])
			scene.grid3 = display.newImageRect("play/grid.png",160,160)
			scene.grid3.x,scene.grid3.y = 150+(620/3)*2,250
			group:insert(scene.grid3)
			display.recalculate(scene.grid3)
			scene.rivalSC[3] = display.newText({text="",fontSize=25,x=150+(620/3)*2,y=250-95})
			scene.rival[3] = display.newText({text="",fontSize=30,x=150+(620/3)*2,y=250+95})
			group:insert(scene.rivalSC[3])
			group:insert(scene.rival[3])
			scene.userName = _G.nt({text=USER_NAME,fontSize=35,x=10,y=(isDownside and display.pixelHeight-pHeight-40*(display.pixelHeight/1280) or pHeight+40*(display.pixelHeight/1280)),font=saucer_font})
			scene.userName.anchorX=0
			scene.userName.anchorY=1
			display.recalculateS(scene.userName)
			group:insert(scene.userName)
			
			scene.rival[1].text = USER_NAME
			scene.rivalSC[1].text = "0"
			if(not isDownside) then
				scene.grid1.y = display.pixelHeight - scene.grid1.y
				scene.grid2.y = display.pixelHeight - scene.grid2.y
				scene.grid3.y = display.pixelHeight - scene.grid3.y
				for k,v in pairs(scene.rivalSC) do
					v.y = display.pixelHeight - v.y
				end
				for k,v in pairs(scene.rival) do
					v.y = display.pixelHeight - v.y
				end
			end
		end
		
		tscore = _G.nt({text="0000000",x=10,y=(isDownside and display.pixelHeight-pHeight-40*(display.pixelWidth/720) or pHeight+40*(display.pixelHeight/1280)),fontSize=40,align="center",font=saucer_font})
		tscore.anchorX = 0
		tscore.anchorY = 0
		group:insert(tscore)
		display.recalculateS(tscore)
		transition.to(ready,{time=1750,alpha=0,xScale=2,yScale=2,delay=0,onComplete=
		function(obj)
			if(scene.halt == false) then
				display.remove(obj)
				audio.play(audio.loadStream("play/go.ogg"),{channel=8})
				globals.lists = nil
				globals.files = nil
				collectgarbage('collect')
				collectgarbage('collect')
				collectgarbage('collect')
				collectgarbage('collect')
				local go = display.newImageRect("play/go.png",800,800)
				go.x,go.y = 380,330-50+(dOffset)
				group:insert(go)
				display.recalculate(go)
				go.xScale,go.yScale=go.xScale*0.2,go.yScale*0.2
				transition.to(go,{time=1500,alpha = 0,xScale=0.9,yScale=0.9,onComplete=
				function(obj)
					if(scene.halt == false) then
						transition.to(scene.shutterd,{time=500,y=0})
						transition.to(scene.shutteru,{time=500,y=0,onComplete=function()
							table_insert_timers(1500,function()
								if(started == false) then
									--print("START!")
									started = true
									if "Win" == system.getInfo("platformName") then
										-- media.playSound(scene.bgmPath)
										-- scene.bgmPlay,scene.bgmSource = audio.play(scene.bgm,options)
									else
										-- scene.bgmPlay,scene.bgmSource = audio.play(scene.bgm,options)
										-- media.playSound(scene.bgmPath)
									end
									if("Win" == system.getInfo("platformName")) then
										scene.udp = socket.udp()
										scene.udp:setsockname("127.0.0.1", 2324)
										scene.udp:settimeout(0)
									end
									table_insert_timers(25,function() Runtime:addEventListener("enterFrame",scene.chktime) end)
									scene.timebar = timer.performWithDelay(audio.getDuration(scene.bgm)/60,
										function()
											local isGray = false
											local isBlue = false
											--------print("==D==")
											--------print(betc)
											--------print(bpfc)
											--------print(barcount)
											--------print("==DEND==")
											if(barcount == 0) then
												bx = bx
											else 
												bx = bx + (display.pixelWidth-fbx - 20*(display.pixelWidth/720))/60
												if(bpfc > 0) then
													if(bmsc > 0 or betc > 0) then
														-- ------print(bmsc,betc)
														isBlue = true
													end
												end
												if(betc > 0) then
													-- ------print(betc)
													isBlue = true
												end
												if(bmsc > 0) then
													isBlue = false
													isGray = true
													-- ------print(bmsc)
												end
												if(betc == 0 and bpfc == 0) then
													isBlue = false
													isGray = true
													-- ------print(bmsc,betc)
												end
												local bi
												for bi = 0,math_floor(math_min(barcount/3,10))-1,1 do
												local rect = _G.nr(bx,scene.userName.y-((isDownside and bi*(((display.pixelWidth-fbx))/60) or -bi*(((display.pixelWidth-fbx))/60))),(display.pixelWidth-fbx)/60,(display.pixelWidth-fbx)/60)
												-- display.recalculateS(rect)
												if(isGray == true) then
													rect:setFillColor(0.2,0.2,0.2)
												end
												if(isBlue == true) then
													rect:setFillColor(0.2,0.2,1)
												end
												if(isBlue == false and isGray == false) then
													rect:setFillColor(1,1,0.2)
												end
													group:insert(rect)
												end
											end
											barcount = 0
											bpfc = 0 
											bmsc = 0
											betc = 0
									end,60)
									print("FIR!!!!!")
									if(true) then
										if(scene.halt == false) then
											for k,v in pairs(firsts) do
												display.remove(v)
											end
										end
										updateCombo()
									end
								end
							end)
						end})
						display.remove(obj)
					end
				end})
			end
		end})
		-- end})
	end
	local markerName = markersRead()

	
	local function playNow()
		transition.to({},{time=2000,onComplete=function()
		--print("PLAYNOW")
		-- timer.performWithDelay(30,function()
			sync = _G.nt({text="",x=pHeight/2-pHeight/8,y=pHeight/2-pHeight/8,fontSize=35,align="center"})
			display.recalculateS(sync)
			scene.bgContainer:insert(sync)
			scene.msFactor = (scene.markerSpeed/25)*17
			print("msFactor",scene.msFactor)
			Runtime:addEventListener( "key", scene.onKeyEvent )
			scene.infoGroup:toFront()
			if(isDownside) then
				dOffset3 = 50
			end
			combo = _G.nt({text="",x=0,y=0,fontSize=100,align="center",font=saucer_font})
			combo.xScale=3.5
			combo.yScale=3.5
			display.recalculateCS(combo)
			-- sync.anchorX = 1
			scene.bgContainer:insert(combo)
			-- group:insert(sync)
			-- combo.alpha = 0.74
			
			--print(system.pathForFile( folder..level.."_replay.json", system.DocumentsDirectory ))
			local f = io.open(system.pathForFile( folder..level.."_replay.json", system.DocumentsDirectory ),"r")
			if (f~=nil and not isMultiPlayer) then 
				io.close(f)
				replayScore = 0
				replayCombo = 0
				replayLoad = loadsave.loadTable(folder..level.."_replay.json", system.DocumentsDirectory )
				isReplyable = true
				--print("Replay Loaded")
			else
				replayLoad = nil
				--print("NO REPLAY!")
			end
			if(isReplyable and isMultiPlayer ~= true) then
				-- combo2 = display.newText({text="Rival Name : / Rival Combo : \nRival Score: / Rival Song:",x=120,y=720+75-dOffset2-gOffset4,font=saucer_font,fontSize=20,align="left"})
				-- combo2.anchorX = 0
				-- group:insert(combo2)
				-- combo2.alpha = 1
				combo3 = _G.nt({text="Rival : 0",x=-pHeight/3,y=-pHeight/3,font=saucer_font,fontSize=60,align="center"})
				display.recalculateS(combo3)
				scene.bgContainer:insert(combo3)
				combo3.alpha = 1
				combo3.anchorX = 0
				if(isReplyable) then
					-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
				end
				-- scene.grid1 = display.newImageRect("play/grid.png",200,200)
				-- scene.grid1.x,scene.grid1.y = 150,210+gOffset
				-- group:insert(scene.grid1)
			end
			-- --------print("NC:"..noteCount)
			-- --------print(data)
			local s_base = graphics.newImageSheet("marker/s_base.png", { width=90/5, height=90/5, numFrames=25,sheetContentWidth = 90,sheetContentHeight = 90})
			local s_goodsh = graphics.newImageSheet("marker/s_good.png", { width=90/4, height=90/4, numFrames=16,sheetContentWidth = 90,sheetContentHeight = 90})
			local s_notgoodsh = graphics.newImageSheet("marker/s_notgood.png", { width=90/4, height=90/4, numFrames=16,sheetContentWidth = 90,sheetContentHeight = 90})
			local s_perfectsh = graphics.newImageSheet("marker/s_perfect.png", { width=90/4, height=90/4, numFrames=16,sheetContentWidth = 90,sheetContentHeight = 90})
			local s_greatsh = graphics.newImageSheet("marker/s_great.png", { width=90/4, height=90/4, numFrames=16,sheetContentWidth = 90,sheetContentHeight = 90})
			local grids = {scene.grid1,scene.grid2,scene.grid3}
			for ikv = 1,3,1 do
				local s_thunders = {}
				local s_goods = {}
				local s_perfects = {}
				local s_greats = {}
				local s_notgoods = {}
				for x = 1,4 do
					for y = 1,4 do
						s_coords[x+(y-1)*4] = grids[ikv].x + (grids[ikv].contentWidth/4)*(x-1) - (grids[ikv].contentWidth/2)
						s_coords_[x+(y-1)*4] = grids[ikv].y + (grids[ikv].contentHeight/4)*(y-1) - (grids[ikv].contentHeight/2) + (grids[ikv].contentHeight/8)
						print(ikv,x+(y-1)*4,s_coords[x+(y-1)*4],s_coords_[x+(y-1)*4])
					end
				end
				for ik = 1,16,1 do
					-- for k,v in pairs(s_coords) do
					local s_thunder = display.newSprite(s_base,{name="base",start=1,count=24,time=scene.markerSpeed,loopCount=1})
					s_thunder.xScale,s_thunder.yScale = grids[ikv].contentWidth/4/18,grids[ikv].contentHeight/4/18
					s_thunder.x,s_thunder.y = s_coords[ik],s_coords_[ik]
					s_thunder.isVisible = false
					local s_good = display.newSprite(s_goodsh,{name="base",start=1,count=16,time=500,loopCount=1})
					s_good.xScale,s_good.yScale = grids[ikv].contentWidth/4/22.5,grids[ikv].contentHeight/4/22.5
					s_good.x,s_good.y = s_coords[ik],s_coords_[ik]
					s_good.isVisible = false
					local s_notgood = display.newSprite(s_notgoodsh,{name="base",start=1,count=16,time=500,loopCount=1})
					s_notgood.xScale,s_notgood.yScale = grids[ikv].contentWidth/4/22.5,grids[ikv].contentHeight/4/22.5
					s_notgood.x,s_notgood.y = s_coords[ik],s_coords_[ik]
					s_notgood.isVisible = false
					local s_perfect = display.newSprite(s_perfectsh,{name="base",start=1,count=16,time=500,loopCount=1})
					s_perfect.xScale,s_perfect.yScale = grids[ikv].contentWidth/4/22.5,grids[ikv].contentHeight/4/22.5
					s_perfect.x,s_perfect.y = s_coords[ik],s_coords_[ik]
					s_perfect.isVisible = false
					local s_great = display.newSprite(s_greatsh,{name="base",start=1,count=16,time=500,loopCount=1})
					s_great.xScale,s_great.yScale = grids[ikv].contentWidth/4/22.5,grids[ikv].contentHeight/4/22.5
					s_great.x,s_great.y = s_coords[ik],s_coords_[ik]
					s_great.isVisible = false
					
					group:insert(s_thunder)
					group:insert(s_good)
					group:insert(s_notgood)
					group:insert(s_great)
					group:insert(s_perfect)
					
					s_thunder.anchorX = 0
					s_good.anchorX = 0
					s_notgood.anchorX = 0
					s_great.anchorX = 0
					s_perfect.anchorX = 0
					
					-- s_thunder.width = 
					-- s_thunder.height = grids[ikv].contentHeight/4
					-- display.recalculateS(s_thunder)
					-- display.recalculateS(s_good)
					-- display.recalculateS(s_notgood)
					-- display.recalculateS(s_great)
					-- display.recalculateS(s_perfect)
					table_insert(s_thunders,s_thunder)
					table_insert(s_goods,s_good)
					table_insert(s_notgoods,s_notgood)
					table_insert(s_greats,s_great)
					table_insert(s_perfects,s_perfect)
				end
				smallSprites[ikv].s_thunders = s_thunders
				smallSprites[ikv].s_goods = s_goods
				smallSprites[ikv].s_notgoods = s_notgoods
				smallSprites[ikv].s_greats = s_greats
				smallSprites[ikv].s_perfects = s_perfects
			end
			scene.grid1:toFront()
			scene.grid2:toFront()
			scene.grid3:toFront()
			-- local thunders = {}
			local checkDir
			if "iPhone OS" ~= system.getInfo("platformName") then
				checkDir = globals.markerPath..markersRead()
			else
				checkDir = "marker/"
			end
			if(markersRead() == "thunder") then
				checkDir = "marker/"
			end
			-- --print(checkDir)
			-- local sheetInfo = require("n_thunder")
			-- local sheet = {}
			-- sheet.normal = "normal_"
			-- sheet.miss = "miss_"
			-- sheet.perfectB = "normalpassed_"
			-- sheet.perfect = "perfect_"
			-- sheet.great = "great_"
			-- sheet.good = "good_"
			-- sheet.bad = "bad_"
			-- sheet.normalFrames = {}
			-- sheet.judgeFunc = function(frame)
				-- if(frame > 0 and frame <= sheet.jbd1) then
					-- return "bad"
				-- elseif(frame > sheet.jbd1 and frame <= sheet.jgd1) then
					-- return "good"
				-- elseif(frame > sheet.jgd1 and frame <= sheet.jgr1) then
					-- return "great"
				-- elseif(frame > sheet.jgr1 and frame <= sheet.jpf) then
					-- return "perfect"
				-- elseif(frame > sheet.jpf and frame <= sheet.jgr2) then
					-- return "great"
				-- elseif(frame > sheet.jgr2 and frame <= sheet.jgd2) then
					-- return "good"
				-- elseif(frame > sheet.jgd2 and frame <= sheet.jbd2) then
					-- return "bad"
				-- end
			-- end
			-- sheet.judges = {} 
			-- sheet.missFrames = {}
			-- sheet.perfectBFrames = {}
			-- sheet.baseFrames = {}
			-- sheet.greatFrames = {}
			-- sheet.perfectFrames = {}
			-- sheet.goodFrames = {}
			-- sheet.badFrames = {}
			-- sheet.frames = sheetInfo:getFrame()
			-- for k,v in pairs(sheet.frames) do
				-- if(k:find(sheet.normal)) then 
					-- table_insert(sheet.normalFrames,{k,v})	
				-- elseif(k:find(sheet.perfectB)) then
					-- table_insert(sheet.perfectBFrames,{k,v})
				-- elseif(k:find(sheet.miss)) then
					-- --print(k)
					-- table_insert(sheet.missFrames,{k,v})
				-- elseif(k:find(sheet.great)) then
					-- table_insert(sheet.greatFrames,{v})
				-- elseif(k:find(sheet.perfect)) then
					-- table_insert(sheet.perfectFrames,{v})
				-- elseif(k:find(sheet.bad)) then
					-- table_insert(sheet.badFrames,{v})
				-- elseif(k:find(sheet.good)) then
					-- table_insert(sheet.goodFrames,{v})
				-- end
			-- end
			-- sheet.jbd1 = math.floor(#sheet.normalFrames/3+0.5)
			-- sheet.jgd1 = math.floor(#sheet.normalFrames/3+0.5)*2
			-- sheet.jgr1 = #sheet.normalFrames
			-- sheet.jgr2 = #sheet.normalFrames+#sheet.perfectBFrames+math.floor(#sheet.missFrames/3+0.5)
			-- sheet.jgd2 = #sheet.normalFrames+#sheet.perfectBFrames+math.floor(#sheet.missFrames/3+0.5)*2
			-- sheet.jbd2 = #sheet.normalFrames+#sheet.perfectBFrames+#sheet.missFrames
			-- sheet.jpf = #sheet.normalFrames+#sheet.perfectBFrames
			-- for k,v in pairs(sheet.normalFrames) do
				-- table_insert(sheet.baseFrames,v[2])
			-- end
			-- for k,v in pairs(sheet.perfectBFrames) do
				-- table_insert(sheet.baseFrames,v[2])
			-- end
			-- for k,v in pairs(sheet.missFrames) do
				-- --print(v[2])
				-- table_insert(sheet.baseFrames,v[2])
			-- end
			-- sheet.graphics = graphics.newImageSheet("marker/n_thunder.png",sheetInfo:getSheet() )
			local shsub
			local sheetInfo = {goodsh={},notgoodsh={},greatsh={},perfectsh={},thundersh={}}
			shsub = display.newImage((checkDir.."/good.png"):gsub("//","/"))
			local goodsh = graphics.newImageSheet((checkDir.."/good.png"):gsub("//","/"), { width=shsub.width/4, height=shsub.height/4, 
			numFrames=16})
			sheetInfo.goodsh.scaleWidth,sheetInfo.goodsh.scaleHeight = shsub.width,shsub.height
			display.remove(shsub)
			shsub = display.newImage((checkDir.."/notgood.png"):gsub("//","/"))
			local notgoodsh = graphics.newImageSheet((checkDir.."/notgood.png"):gsub("//","/"), { width=shsub.width/4, height=shsub.height/4, numFrames=16})
			sheetInfo.notgoodsh.scaleWidth,sheetInfo.notgoodsh.scaleHeight = shsub.width,shsub.height
			display.remove(shsub)
			shsub = display.newImage((checkDir.."/perfect.png"):gsub("//","/"))
			local perfectsh = graphics.newImageSheet((checkDir.."/perfect.png"):gsub("//","/"), { width=shsub.width/4, height=shsub.height/4, numFrames=16})
			sheetInfo.perfectsh.scaleWidth,sheetInfo.perfectsh.scaleHeight = shsub.width,shsub.height
			display.remove(shsub)
			shsub = display.newImage((checkDir.."/great.png"):gsub("//","/"))
			local greatsh = graphics.newImageSheet((checkDir.."/great.png"):gsub("//","/"), { width=shsub.width/4, height=shsub.height/4, numFrames=16})
			sheetInfo.greatsh.scaleWidth,sheetInfo.greatsh.scaleHeight = shsub.width,shsub.height
			display.remove(shsub)
			shsub = display.newImage((checkDir.."/base.png"):gsub("//","/"))
			local thundersh = graphics.newImageSheet((checkDir.."/base.png"):gsub("//","/"), { width=shsub.width/5, height=shsub.height/5, numFrames=24})
			sheetInfo.thundersh.scaleWidth,sheetInfo.thundersh.scaleHeight = shsub.width,shsub.height
			display.remove(shsub)
			for ik = 1,16,1 do
				local good = display.newSprite(goodsh,{name="base",start=1,count=16,time=500,loopCount=1})
				good.xScale,good.yScale = ((pHeight-12)/4)/(sheetInfo.goodsh.scaleWidth/4),((pHeight-12)/4)/(sheetInfo.goodsh.scaleHeight/4)
				good.x,good.y = coords[ik],coords_[ik]
				good.isVisible = false
				local notgood = display.newSprite(notgoodsh,{name="base",start=1,count=16,time=500,loopCount=1})
				notgood.xScale,notgood.yScale = ((pHeight-12)/4)/(sheetInfo.notgoodsh.scaleWidth/4),((pHeight-12)/4)/(sheetInfo.notgoodsh.scaleHeight/4)
				notgood.x,notgood.y = coords[ik],coords_[ik]
				notgood.isVisible = false
				local perfect = display.newSprite(perfectsh,{name="base",start=1,count=16,time=500,loopCount=1})
				perfect.xScale,perfect.yScale = ((pHeight-12)/4)/(sheetInfo.perfectsh.scaleWidth/4),((pHeight-12)/4)/(sheetInfo.perfectsh.scaleHeight/4)
				perfect.x,perfect.y = coords[ik],coords_[ik]
				perfect.isVisible = false
				local great = display.newSprite(greatsh,{name="base",start=1,count=16,time=500,loopCount=1})
				great.xScale,great.yScale = ((pHeight-12)/4)/(sheetInfo.greatsh.scaleWidth/4),((pHeight-12)/4)/(sheetInfo.greatsh.scaleHeight/4)
				great.x,great.y = coords[ik],coords_[ik]
				great.isVisible = false
				local thunder_sub = display.newSprite(thundersh,{name="base",start=1,count=24,time=scene.markerSpeed,loopCount=1})
				-- thunder_sub.fill.blendMode =  { srcColor="srcColor", dstColor="one" }
				thunder_sub.xScale,thunder_sub.yScale = ((pHeight-12)/4)/(sheetInfo.thundersh.scaleWidth/5),((pHeight-12)/4)/(sheetInfo.thundersh.scaleHeight/5)
				thunder_sub.x,thunder_sub.y  = coords[ik],coords_[ik]
				thunder_sub.isVisible = false
				scene.bgContainer:insert(good)
				scene.bgContainer:insert(notgood)	
				scene.bgContainer:insert(great)
				scene.bgContainer:insert(perfect)
				scene.bgContainer:insert(thunder_sub)
				table_insert(goods,good)
				table_insert(notgoods,notgood)
				table_insert(greats,great)
				table_insert(perfects,perfect)
				table_insert(thunder,thunder_sub)
				thunder_sub:addEventListener("sprite",function(event)
					-- local ik = ik
					if(event.target.frame == 17) then
						if(clap) then
							system.vibrate()
							-- print(thunder[ik].frame)
						end
						if(isAuto) then
							replaySave[event.target.noteIndex] = 17
							-- table_insert_timers(scene.markerFactor,function()
								ia = ia+1
								audio.play(ssclap,{channel=15+ia%17})
							-- end)
							pfc = pfc + 1
							bpfc = bpfc + 1
							nCombo = nCombo + 1
							-- system.vibrate()
							judgeNow(ik,perfects,"p",2,perfectScore)
							local entity = thunder[ik]
							-- local frameNow = math_floor((system.getTimer() - entity.startTime)/(1/24*scene.markerSpeed) + 0.5)
							local avrNow = math_floor((1/24*scene.markerSpeed*16)-(system.getTimer() - entity.startTime)+0.5)
							local frameNow = math_floor((system.getTimer() - entity.startTime)/(1/24*scene.markerSpeed) + 0.5)
							if(scene.lastPavr == nil and (frameNow >= 15 and frameNow <= 17)) then
								scene.lastPavr = avrNow
							end
							if(scene.lastAavr == nil) then
								scene.lastAavr = avrNow
							end
							sync.text = "NOW:"..tostring(avrNow)
							.."\nAVR:"..scene.lastAavr
							.."\nPAVR:"..(scene.lastPavr or "N/A")
							scene.lastAavr = math_floor((avrNow+scene.lastAavr)/2)
							if((frameNow >= 15 and frameNow <= 17)) then
								scene.lastPavr = math_floor((avrNow+scene.lastPavr)/2)
							end
							-- sync.text = tostring(math_floor((1/245*900*15)-(system.getTimer() - entity.startTime)+0.5)).."/"..tostring(math_floor(1/24*900+0.5))
							if "Win" == system.getInfo("platformName") then
								print(frameNow,entity.frame)
							end
						end
					end
				end)
			end
			scene.rank = graphics.newImageSheet("play/rank.png", { width=1200/3, height=1200/3, numFrames=9,sheetContentWidth = 1200,sheetContentHeight = 1200})
			scene.rank = display.newSprite( scene.rank, {name="rank",start=1,count=9} )
			scene.rank.x,scene.rank.y = pHeight/2,pHeight/2 + (isDownside and display.pixelHeight-pHeight or 0)
			group:insert(scene.rank)
			scene.rank.isVisible = false
			
			function touch(index,phase,event)
				local entity = thunder[index]
				if(entity ~= nil and isAuto ~= true) then
					if(scene.halt ~= true) then
						if(entity.isVisible ~= false and started ~= false) then
							local avrNow = math_floor((1/24*scene.markerSpeed*16)-(system.getTimer() - entity.startTime)+0.5)
							local frameNow = math_floor((system.getTimer() - entity.startTime)/(1/24*scene.markerSpeed) + 0.5)
							-- local frameNow = entity.frame
							if(scene.lastPavr == nil and (frameNow >= 15 and frameNow <= 17)) then
								scene.lastPavr = avrNow
							end
							if(scene.lastAavr == nil) then
								scene.lastAavr = avrNow
							end
							sync.text = "NOW:"..tostring(avrNow)
							.."\nAVR:"..scene.lastAavr
							.."\nPAVR:"..(scene.lastPavr or "N/A")
							scene.lastAavr = math_floor((avrNow+scene.lastAavr)/2)
							if((frameNow >= 15 and frameNow <= 17)) then
								scene.lastPavr = math_floor((avrNow+scene.lastPavr)/2)
							end
							-- sync.text = tostring(math_floor((1/245*900*15)-(system.getTimer() - entity.startTime)+0.5)).."/"..tostring(math_floor(1/24*900+0.5))
							if "Win" == system.getInfo("platformName") then
								print(frameNow,entity.frame)
							end
							replaySave[entity.noteIndex] = frameNow
							if(frameNow <= 5 and frameNow ~= 0) then
								nCombo = 0
								bdc = bdc + 1
								bmsc = bmsc + 1
								judgeNow(index,notgoods,"b",-4,badScore)
							elseif(frameNow <= 10 and frameNow ~= 0) then
								nCombo = nCombo + 1
								gdc = gdc + 1
								betc = betc + 1
								judgeNow(index,goods,"g",2,goodScore)
							elseif(frameNow <= 14 and frameNow ~= 0) then
								nCombo = nCombo + 1
								grc = grc + 1
								betc = betc + 1
								judgeNow(index,greats,"r",2,greatScore)
							elseif(frameNow <= 17 and frameNow ~= 0) then
								nCombo = nCombo + 1
								pfc = pfc + 1
								bpfc = bpfc + 1
								judgeNow(index,perfects,"p",2,perfectScore)
							elseif(frameNow <= 19 and frameNow ~= 0) then
								nCombo = nCombo + 1
								grc = grc + 1
								betc = betc + 1
								judgeNow(index,greats,"r",2,greatScore)
							elseif(frameNow <= 21 and frameNow ~= 0) then
								nCombo = nCombo + 1
								gdc = gdc + 1
								betc = betc + 1
								judgeNow(index,goods,"g",2,goodScore)
							elseif(frameNow < 25) then
								nCombo = 0
								bdc = bdc + 1
								bmsc = bmsc + 1
								judgeNow(index,notgoods,"b",-4,badScore)
							end	
							if(clap == true and entity.dtime ~= lastDT) then
								lastDT = entity.dtime
								if composer.clapable then
									playTouchSound()
								else
									system.vibrate()
								end
								-- system.vibrate()
							end
						end
					end
				end	
			end
			scene.loadedArea = tablesave.loadTable("area.json", system.DocumentsDirectory )
			if(scene.loadedArea == nil) then
				-- print("init Area")
				tablesave.saveTable({area=1},"area.json", system.DocumentsDirectory )
				scene.loadedArea = tablesave.loadTable("area.json", system.DocumentsDirectory )
			end
			-- coords[1],coords_[1] = (pHeight/4)*1-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*1 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[2],coords_[2] = (pHeight/4)*2-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*1 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[4],coords_[4] = (pHeight/4)*4-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*1 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[3],coords_[3] = (pHeight/4)*3-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*1 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[5],coords_[5] = (pHeight/4)*1-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*2 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[6],coords_[6] = (pHeight/4)*2-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*2 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[7],coords_[7] = (pHeight/4)*3-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*2 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[8],coords_[8] = (pHeight/4)*4-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*2 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[9],coords_[9] = (pHeight/4)*1-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*3 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[10],coords_[10] = (pHeight/4)*2-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*3 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[11],coords_[11] = (pHeight/4)*3-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*3 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[12],coords_[12] = (pHeight/4)*4-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*3 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[13],coords_[13] = (pHeight/4)*1-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*4 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[14],coords_[14] = (pHeight/4)*2-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*4 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[15],coords_[15] = (pHeight/4)*3-pHeight/8,(pHeight -(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*4 - (isDownside and 0 or (pHeight -pHeight))
			-- coords[16],coords_[16] = (pHeight/4)*4-pHeight/8,(display.pixelHeight-(pHeight/4)*4-(pHeight/4)/2)+((pHeight/4))*4 - (isDownside and 0 or (display.pixelHeight-pHeight))
			for x = 1,4,1 do
				for y = 1,4,1 do
					coords[x+(y-1)*4],coords_[x+(y-1)*4] = (pHeight/4)*x-(pHeight/8),(pHeight/4)*y-pHeight/8 + (isDownside and (display.pixelHeight-pHeight) or 0)
				end
			end
			local touchIndexes = {}
			local onJudgeCollision = function(self,event)
				-- print(self.idx,event.phase)
				if(event.phase ~= "ended") then
					self.ik.isVisible = true
					touch(self.idx,"")
				else
					self.ik.isVisible = false
				end
			end
			local createButton
			createButton = function(k)
				for ik = 1,1,1 do
					local pt_ent_inv = _G.nr(coords[k],coords_[k],(pHeight/4)*math_min(scene.loadedArea.area,1.5),(pHeight/4)*math_min(scene.loadedArea.area,1.5))
					local ik = 1
					pt_ent_inv.isVisible = false
					-- pt_ent_inv.isHitTestable = true
					pt_ent_inv.ik = pt_entities[k]
					pt_ent_inv.idx = k
					group:insert(pt_ent_inv)
					pt_ent_inv.collision = onJudgeCollision
					pt_ent_inv:addEventListener( "collision" )
					pt_entities[k].inv = pt_ent_inv
					physics.addBody(pt_ent_inv, "static", {isSensor = true})
					-- function pt_ent_inv:touch( event )
						-- -- print(k,event.phase,system.getTimer())
						-- if (event.phase == "began" or event.phase == "moved") and self.isFocus ~= true then
							-- -- print( "Touch event began on: " .. self.id )
							-- touch(k,"")
							-- -- set touch focus
							-- self.ik.isVisible = true
							-- -- local tTable = touchIndexes[event.id]
							-- if(touchIndexes[event.id] == nil) then
								-- touchIndexes[event.id] = {}
							-- end
							-- touchIndexes[event.id][#touchIndexes[event.id]+1] = self
							-- display.getCurrentStage():setFocus( self, event.id)
							-- -- touchIndexes[event.id] = self
							-- self.isFocus = true
						-- elseif self.isFocus then
								-- if event.phase == "moved" then
									-- -- print( "Moved phase of touch event detected." )
									-- if math_abs(event.x - self.x) > self.contentWidth/2 or math_abs(event.y - self.y) > self.contentWidth/2 then
										-- self.ik.isVisible = false
										-- display.getCurrentStage():setFocus( self,nil )
										-- self.isFocus = nil
										-- -- createButton(k)
										-- -- display.remove(self)
										-- -- self = nil
									-- end
								-- elseif event.phase == "ended" or event.phase == "cancelled" then
									-- -- reset touch focus
									-- -- self.ik.isVisible = false
									-- local tTable = touchIndexes[event.id]
									-- if(tTable ~= nil) then
										-- print(tTable)
										-- for k = 1,#tTable,1 do
											-- local v = tTable[k]
											-- v.ik.isVisible = falsefalse
											-- display.getCurrentStage():setFocus( v,nil )
											-- v.isFocus = nil
										-- end
									-- end
									-- -- createButton(k)
									-- -- display.remove(self)
									-- -- self = nil
								-- end
						-- end
						-- return false
					-- end
					-- pt_ent_inv:addEventListener( "touch", function()
						-- if(event.phase =="ended") then
							-- pt_ent_inv.ik.isVisible = false
						-- end
						-- return false
					-- end)
				end
			end
			for k,v in pairs(coords) do 	
				pt_entities[k] = display.newImageRect("panel_selected.png",pHeight/4,pHeight/4)
				group:insert(pt_entities[k])
				pt_entities[k].x,pt_entities[k].y = coords[k],coords_[k]
				pt_entities[k].isVisible = false
				
				-- for ik = 1,250,1 do
				createButton(k)
			end
			
			-- local touchPos = widget.newButton({x=360,y=isDownside and display.pixelHeight-pHeight/2 or pHeight/2,width=720,height=pHeight,defaultFile="panel_unselected.png",overFile="panel_unselected.png"
			-- ,onEvent=function(event)
				-- -- print("AAA",event.phase,event.id)
				-- -- print("TED",event.phase,system.getTimer())
				-- for iptk = 1,16,1 do
					-- local target = pt_entities[iptk]
					-- if(event.phase == "began" or event.phase == "moved") then
						-- -- local target = event.target
						-- if(math_abs(event.x - target.x) > target.contentWidth/2 or math_abs(event.y - target.y) > target.contentHeight/2) then
							-- -- print("END!")
							-- -- if(target.lastID ~= nil and touchIndexes[target.lastID] ~= nil) then
								-- -- for k2,v2 in pairs(touchIndexes[target.lastID]) do
									-- -- pt_entities[v2].isVisible = false
									-- -- -- TouchMgr:unsetFocus( target, event.id )
								-- -- end
								-- -- touchIndexes[target.lastID] = nil
							-- -- end
							-- -- pt_entities[iptk].isVisible = false
						-- end
						-- if(math_abs(event.x - target.x) < target.contentWidth/2 and math_abs(event.y - target.y) < target.contentHeight/2) then
							-- -- pt_entities[iptk].isVisible = true
							-- -- TouchMgr:setFocus(target,event.id)
							-- -- target.lastID = event.id
							-- -- if(touchIndexes[event.id] == nil) then
								-- -- print("GEN!")
								-- -- touchIndexes[event.id] = {}
							-- -- end
							-- -- table_insert(touchIndexes[event.id],iptk)
							-- -- system.activate( "multitouch" )
							-- -- system.setTapDelay(10000)
							-- -- pt_entities[v2].isVisible = false
							-- touch(iptk,"")
						-- end
					-- else
						-- -- print("END")
						-- -- if(target.lastID ~= nil and touchIndexes[target.lastID] ~= nil) then
							-- -- for k2,v2 in pairs(touchIndexes[target.lastID]) do
								-- -- pt_entities[v2].isVisible = false
								-- -- print(event.id)
								-- -- -- TouchMgr:unsetFocus( target, event.id )
							-- -- end
							-- -- touchIndexes[target.lastID] = nil
						-- -- end
					-- end
				-- end
				-- return true	
			-- end})
			-- group:insert(touchPos)
			-- local touchPos = widget.newButton({x=360,y=isDownside and display.pixelHeight-pHeight/2 or pHeight/2,width=720,height=pHeight,defaultFile="panel_unselected.png",overFile="panel_unselected.png"
			-- ,onEvent=function(event)
				-- -- print("AAA",event.phase,event.id)
				-- -- print("TED",event.phase,system.getTimer())
				-- for iptk = 1,16,1 do
					-- local target = pt_entities[iptk]
					-- if(event.phase == "began" or event.phase == "moved") then
						-- -- local target = event.target
						-- if(math_abs(event.x - target.x) > target.contentWidth/2 or math_abs(event.y - target.y) > target.contentHeight/2) then
							-- -- print("END!")
							-- -- if(target.lastID ~= nil and touchIndexes[target.lastID] ~= nil) then
								-- -- for k2,v2 in pairs(touchIndexes[target.lastID]) do
									-- -- pt_entities[v2].isVisible = false
									-- -- -- TouchMgr:unsetFocus( target, event.id )
								-- -- end
								-- -- touchIndexes[target.lastID] = nil
							-- -- end
							-- -- pt_entities[iptk].isVisible = false
						-- end
						-- if(math_abs(event.x - target.x) < target.contentWidth/2 and math_abs(event.y - target.y) < target.contentHeight/2) then
							-- -- pt_entities[iptk].isVisible = true
							-- -- TouchMgr:setFocus(target,event.id)
							-- -- target.lastID = event.id
							-- -- if(touchIndexes[event.id] == nil) then
								-- -- print("GEN!")
								-- -- touchIndexes[event.id] = {}
							-- -- end
							-- -- table_insert(touchIndexes[event.id],iptk)
							-- -- system.activate( "multitouch" )
							-- -- system.setTapDelay(10000)
							-- -- pt_entities[v2].isVisible = false
							-- touch(iptk,"")
						-- end
					-- else
						-- -- print("END")
						-- -- if(target.lastID ~= nil and touchIndexes[target.lastID] ~= nil) then
							-- -- for k2,v2 in pairs(touchIndexes[target.lastID]) do
								-- -- pt_entities[v2].isVisible = false
								-- -- print(event.id)
								-- -- -- TouchMgr:unsetFocus( target, event.id )
							-- -- end
							-- -- touchIndexes[target.lastID] = nil
						-- -- end
					-- end
				-- end
				-- return true	
			-- end})
			-- group:insert(touchPos)
			-- local touchPos = widget.newButton({x=360,y=isDownside and display.pixelHeight-pHeight/2 or pHeight/2,width=720,height=pHeight,defaultFile="panel_unselected.png",overFile="panel_unselected.png"
			-- ,onEvent=function(event)
				-- -- print("AAA",event.phase,event.id)
				-- -- print("TED",event.phase,system.getTimer())
				-- for iptk = 1,16,1 do
					-- local target = pt_entities[iptk]
					-- if(event.phase == "began" or event.phase == "moved") then
						-- -- local target = event.target
						-- if(math_abs(event.x - target.x) > target.contentWidth/2 or math_abs(event.y - target.y) > target.contentHeight/2) then
							-- -- print("END!")
							-- -- if(target.lastID ~= nil and touchIndexes[target.lastID] ~= nil) then
								-- -- for k2,v2 in pairs(touchIndexes[target.lastID]) do
									-- -- pt_entities[v2].isVisible = false
									-- -- -- TouchMgr:unsetFocus( target, event.id )
								-- -- end
								-- -- touchIndexes[target.lastID] = nil
							-- -- end
							-- -- pt_entities[iptk].isVisible = false
						-- end
						-- if(math_abs(event.x - target.x) < target.contentWidth/2 and math_abs(event.y - target.y) < target.contentHeight/2) then
							-- -- pt_entities[iptk].isVisible = true
							-- -- TouchMgr:setFocus(target,event.id)
							-- -- target.lastID = event.id
							-- -- if(touchIndexes[event.id] == nil) then
								-- -- print("GEN!")
								-- -- touchIndexes[event.id] = {}
							-- -- end
							-- -- table_insert(touchIndexes[event.id],iptk)
							-- -- system.activate( "multitouch" )
							-- -- system.setTapDelay(10000)
							-- -- pt_entities[v2].isVisible = false
							-- touch(iptk,"")
						-- end
					-- else
						-- -- print("END")
						-- -- if(target.lastID ~= nil and touchIndexes[target.lastID] ~= nil) then
							-- -- for k2,v2 in pairs(touchIndexes[target.lastID]) do
								-- -- pt_entities[v2].isVisible = false
								-- -- print(event.id)
								-- -- -- TouchMgr:unsetFocus( target, event.id )
							-- -- end
							-- -- touchIndexes[target.lastID] = nil
						-- -- end
					-- end
				-- end
				-- return true	
			-- end})
			-- group:insert(touchPos)
				-- pt_entities[k].id = k
				-- pt_entities[k+16].id = k
				-- for ik = 1,100,1 do
					-- local pt_ent_inv = display.newRect(coords[k],coords_[k],720/4,pHeight/4)
					-- pt_ent_inv.xScale,pt_ent_inv.yScale = math_min(scene.loadedArea.area,1),math_min(scene.loadedArea.area,1)
					-- pt_ent_inv.isVisible = false
					-- pt_ent_inv.isHitTestable = true
					-- group:insert(pt_ent_inv)
					-- pt_ent_inv:addEventListener("tap",function(event)
						-- print("tap",k,ik)
						-- touch(k,"")
						-- return true
					-- end)
				-- end
			-- end
			-- local areaFactor = scene.loadedArea.area/2
			-- scene.touched = function(event)
				-- print("TED",event.phase,system.getTimer())
				-- for iptk = 1,16,1 do
					-- local target = pt_entities[iptk+16]
					-- if(math_abs(event.x - target.x) > target.contentWidth/2 or math_abs(event.y - target.y) > target.contentHeight/2) then
						-- -- pt_entities[iptk].isVisible = false
					-- end
					-- if(math_abs(event.x - target.x) < target.contentWidth/2 and math_abs(event.y - target.y) < target.contentHeight/2) then
						-- if(event.phase == "began" or event.phase == "moved") then
							-- -- pt_entities[iptk].isVisible = true
							-- -- system.activate( "multitouch" )
							-- -- system.setTapDelay(10000)
							-- -- print("IPTK",iptk)
							-- touchedIndexes[event.id] = true
							-- touch(iptk,"")
						-- else
							-- -- pt_entities[iptk-16].isVisible = false
						-- end
					-- end
				-- end
				-- -- print(event.phase)
				-- -- if (event.x > scene.panel.x - scene.panel.width/2 or event.y > scene.panel.y - scene.panel.height/2 or event.x < scene.panel.x + scene.panel.width/2 or event.y < scene.panel.y + scene.panel.height/2)  then
					-- -- if(event.phase == "moved" or event.phase == "began") then
						-- -- if(isDownside) then
							-- -- dOffset3 = display.pixelHeight-pHeight
						-- -- else
							-- -- dOffset3 = 0
						-- -- end
						-- -- local ex = event.x
						-- -- local ey = event.y-dOffset3
						-- -- print(ex,ey,(ex%((720/4)))/(720/4))
						-- -- if((ex%((720/4))/720/4) > scene.loadedArea.area or (ex%((720/4))/720/4) < (1-scene.loadedArea.area)) then
							-- -- print("END")
							-- -- return
						-- -- end
						-- -- if((ey%(((pHeight/4)))/(pHeight/4)) > scene.loadedArea.area or (ey%(((pHeight/4)))/(pHeight/4)) < (1-scene.loadedArea.area)) then
							-- -- print("END")
							-- -- return
						-- -- end
						-- -- x = math_ceil(ex/(720/4))
						-- -- ----print((ey-dOffset3))
						-- -- y = math_floor((ey)/(pHeight/4))
						-- -- local dbg = display.newRect(ex,(ey),15,15)
						-- -- dbg:setFillColor(1,1,1)
						-- -- group:insert(dbg)
						-- -- local _i = x+y*4
						-- -- if(_i > 0 and _i<=16) then
							-- -- touch(_i,"")
						-- -- end
						-- -- if(_i<=16) then
							-- -- if(_i > 0) then
								-- -- local function table_find(t,var)
									-- -- for k,v in pairs(t) do
										-- -- if(v == var) then
											-- -- return true
										-- -- end
									-- -- end
									-- -- return false
								-- -- end
								-- -- if(table_find(pt_ent,_i) == false) then
									-- -- if(thunder[_i] ~= nil) then
										-- -- --print("began",_i)
									-- -- end
									-- -- pt_entities[_i].isVisible = true
									-- -- table_insert(pt_ent,_i)
								-- -- end
								-- -- for _k,_v in pairs(pt_ent) do
									-- -- local ptHeight = pHeight/8
									-- -- local ptWidth = 720/8
									-- -- local ptX = pt_entities[_v].x
									-- -- local ptY = pt_entities[_v].y
									-- -- if ((event.x < ptX - ptWidth or event.y < ptY - ptHeight or event.x > ptX + ptWidth or event.y > ptY + ptHeight))  then
										-- -- -- ----print("RELEASED",_v)
										-- -- pt_entities[_v].isVisible = false
										-- -- table_remove(pt_ent,_k)
									-- -- end
								-- -- end
							-- -- end
						-- -- end
					-- -- end
				-- -- end
				-- -- if(event.phase == "ended" or event.phase == "cancelled") then
					-- -- for k,v in pairs(pt_ent) do
						-- -- -- ----print("RELEASED",v)
						-- -- -- table_remove(pt_ent,_k)
						-- -- -- pt_entities[v].isVisible = false
					-- -- end
				-- -- end
				-- if(touchedIndexes[event.id] == true) then
					-- print("EID")
					-- return true
				-- else
					-- print("W : EID NOT EXISTS!")
					-- return false
				-- end
			-- end
			
			-- scene.touched = function(event)
				-- --print("HTOUCH!!!!",event.phase,event.x,event.y,system.getTimer())
				-- for iptk = 1,16,1 do
					-- local target = pt_entities[iptk]
					-- if(math_abs(event.x - target.x) > target.width/2 or math_abs(event.y - target.y) > target.height/2) then
						-- pt_entities[iptk].isVisible = false
					-- end
					-- if(math_abs(event.x - target.x) < target.width/2 and math_abs(event.y - target.y) < target.height/2) then
						-- if(event.phase == "began" or event.phase == "moved") then
							-- pt_entities[iptk].isVisible = true
							-- -- system.activate( "multitouch" )
							-- -- system.setTapDelay(10000)
							-- -- print("IPTK",iptk)
							-- -- touchedIndexes[event.id] = true
							-- --print("HTED!!",iptk)
							-- touch(iptk,"")
						-- else
							-- pt_entities[iptk].isVisible = false
						-- end
					-- end
				-- end
				-- -- print(event.phase)
				-- -- if (event.x > scene.panel.x - scene.panel.width/2 or event.y > scene.panel.y - scene.panel.height/2 or event.x < scene.panel.x + scene.panel.width/2 or event.y < scene.panel.y + scene.panel.height/2)  then
					-- -- if(event.phase == "moved" or event.phase == "began") then
						-- -- if(isDownside) then
							-- -- dOffset3 = display.pixelHeight-pHeight
						-- -- else
							-- -- dOffset3 = 0
						-- -- end
						-- -- local ex = event.x
						-- -- local ey = event.y-dOffset3
						-- -- print(ex,ey,(ex%((720/4)))/(720/4))
						-- -- if((ex%((720/4))/720/4) > scene.loadedArea.area or (ex%((720/4))/720/4) < (1-scene.loadedArea.area)) then
							-- -- print("END")
							-- -- return
						-- -- end
						-- -- if((ey%(((pHeight/4)))/(pHeight/4)) > scene.loadedArea.area or (ey%(((pHeight/4)))/(pHeight/4)) < (1-scene.loadedArea.area)) then
							-- -- print("END")
							-- -- return
						-- -- end
						-- -- x = math_ceil(ex/(720/4))
						-- -- ----print((ey-dOffset3))
						-- -- y = math_floor((ey)/(pHeight/4))
						-- -- local dbg = display.newRect(ex,(ey),15,15)
						-- -- dbg:setFillColor(1,1,1)
						-- -- group:insert(dbg)
						-- -- local _i = x+y*4
						-- -- if(_i > 0 and _i<=16) then
							-- -- touch(_i,"")
						-- -- end
						-- -- if(_i<=16) then
							-- -- if(_i > 0) then
								-- -- local function table_find(t,var)
									-- -- for k,v in pairs(t) do
										-- -- if(v == var) then
											-- -- return true
										-- -- end
									-- -- end
									-- -- return false
								-- -- end
								-- -- if(table_find(pt_ent,_i) == false) then
									-- -- if(thunder[_i] ~= nil) then
										-- -- --print("began",_i)
									-- -- end
									-- -- pt_entities[_i].isVisible = true
									-- -- table_insert(pt_ent,_i)
								-- -- end
								-- -- for _k,_v in pairs(pt_ent) do
									-- -- local ptHeight = pHeight/8
									-- -- local ptWidth = 720/8
									-- -- local ptX = pt_entities[_v].x
									-- -- local ptY = pt_entities[_v].y
									-- -- if ((event.x < ptX - ptWidth or event.y < ptY - ptHeight or event.x > ptX + ptWidth or event.y > ptY + ptHeight))  then
										-- -- -- ----print("RELEASED",_v)
										-- -- pt_entities[_v].isVisible = false
										-- -- table_remove(pt_ent,_k)
									-- -- end
								-- -- end
							-- -- end
						-- -- end
					-- -- end
				-- -- end
				-- -- if(event.phase == "ended" or event.phase == "cancelled") then
					-- -- for k,v in pairs(pt_ent) do
						-- -- -- ----print("RELEASED",v)
						-- -- -- table_remove(pt_ent,_k)
						-- -- -- pt_entities[v].isVisible = false
					-- -- end
				-- -- end
				-- -- if(false) then
					-- -- print("EID")
					-- -- return true
				-- -- else
					-- -- print("W : EID NOT EXISTS!")
					-- return false
				-- -- end
			-- end
			local touchPoints = {}
			local function isInBound(obj1,obj2)
				if ( obj1 == nil ) then  --make sure the first object exists
					return false
				end
				if ( obj2 == nil ) then  --make sure the other object exists
					return false
				end

				local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
				local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
				local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
				local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

				return (left or right) and (up or down)
			end
			scene.touched = function(event)
				-- event.rphase = event.phase
				if(touchPoints[event.id] == nil) then
					local touchPoint = display.newRect(event.x,event.y,10,10)
					group:insert(touchPoint)
					touchPoint.isVisible = false
					touchPoints[event.id] = touchPoint
					physics.addBody(touchPoint, "dynamic", {isSensor = true})
					touchPoint.gravityScale = 0
				end
				touchPoints[event.id].x,touchPoints[event.id].y = event.x,event.y
				if(event.phase == "ended") then
					for ik=1,16 do
						-- print(ik,isInBound(pt_entities[ik].inv,touchPoints[event.id]),pt_entities[ik].inv,touchPoints[event.id])
						if isInBound(pt_entities[ik].inv,touchPoints[event.id]) then
							pt_entities[ik].isVisible = false
						end
					end
					display.remove(touchPoints[event.id])
				end
				return false
			end
			if(isAuto ~= true) then
				-- scene.bg:addEventListener("touch",touched)
				-- scene.panel:addEventListener("touch",touched)
				-- scene.panel2:addEventListener("touch",touched)
				-- scene.touchBuffer:addEventListener("touch",touched)
				-- scene.touchBuffer2:addEventListener("touch",touched)
				-- for k,v in pairs(scene.touchBuffer) do
					-- v:addEventListener("touch",scene.touched)
				-- end
				-- if(setGlobalTouch ~= nil) then
					-- Runtime:addEventListener("Htouch",scene.touched)
				-- end
				Runtime:addEventListener("touch",scene.touched)
				-- Runtime:addEventListener("touch",scene.touched)
				-- display.getCurrentStage():setFocus(scene.panel)
			end
		end})
	end
		local onLoadLocalPlayer = function(event)
			USER_NAME = event.data.alias
			scene.rival[1].text = USER_NAME
			scene.userName.text = USER_NAME
			scene.localPlayerID = event.data.playerID
			--print("LOCAL",USER_NAME,event.data.playerID)
		end 
		if(loggedIntoGC) then
			gameNetwork.request( "loadLocalPlayer", { listener=onLoadLocalPlayer } )
		end
		if(not loggedIntoGC or not online) then
			firsttime()
			playNow()
		end
		local function rival_compare(a,b)
			return a[1] > b[1]
		end
		local rivalScores = {}
		local function rival_compare(a,b)
			return a[1] > b[1]
		end
		local songs = {pdata.title}
		scene.readyCount = 0
		scene.ready1Count = 0
		scene.snameCount = 0
		local replay = false
		local function roomListener(event)
			--print(event.type)
			if (event.type == "messageReceived") then
				local msg = event.data.message
				--print(msg)
				if(msg:find("SNAME")) then
					-- scene.readyCount = scene.readyCount + 1
					-- --print("scene.readyCount",scene.readyCount,scene.currentPlayers)
					-- if(scene.readyCount >= scene.currentPlayers) then
						-- --print("ALL READY")
						-- table_insert(songs,msg:gsub("SNAME",""))
						-- --print(songs,msg:gsub("SNAME",""))
						-- local function compareSong(a,b)
							-- return a:upper() > b:upper()
						-- end
						-- table.sort(songs,compareSong)
						-- scene.finalSong = songs[1]
						-- --print("FINAL",scene.finalSong)
						-- --print(pdata.title,msg:gsub("SNAME",""))
						-- local iHaveThisSong = nil
						-- local iHaveThisFumen = {}
						-- local myHighestFumen = 1
						-- local function file_exists(name)
							-- local f = io.open(name,"r")
							-- if f~=nil then io.close(f) return true else return false end
						-- end
						-- for k,v in pairs(lists) do
							-- if(type(k) == "number" and v.title == scene.finalSong) then
								-- --print("I HAVE!")
								-- iHaveThisSong = v
								-- for ivk = 1,3 do
								-- local notePos = v.level[ivk].note
									-- if "Win" == system.getInfo("platformName") then
										-- notePos = system.pathForFile(notePos,system.ResourceDirectory)
									-- end
									-- --print(notePos)
									-- if file_exists(notePos) and lfs.attributes(notePos,"mode") == "file" then
										-- table_insert(iHaveThisFumen,ivk)
										-- myHighestFumen = ivk
									-- end
								-- end
							-- end
						-- end
						-- if iHaveThisSong == nil then
							-- scene.snameCount = scene.snameCount+1
							-- --print("SNAME DIFF",scene.snameCount,math.floor(scene.currentPlayers/2+0.5))
							-- if(scene.snameCount >= math.floor(scene.currentPlayers/2+0.5)) then
								-- --print("DIFFERENT! LEAVING NOW")
								-- gameNetwork.request( "leaveRoom",
								-- {
									-- listener = function()
										-- --print("REJOIN")
										-- --print("REJOIN",scene.players)
										-- --print("REJOIN",scene.minAutoMatchPlayers)
										-- --print("REJOIN",scene.maxAutoMatchPlayers)
										-- gameNetwork.request( "createRoom",{
											-- listener = roomListener,
											-- playerIDs = scene.players,
											-- minAutoMatchPlayers = scene.minAutoMatchPlayers,
											-- maxAutoMatchPlayers = scene.maxAutoMatchPlayers,
										-- })
									-- end,
									-- roomID = scene.roomID,
								-- })
							-- end
						-- else
							-- scene.ready1Count= scene.ready1Count+1
							-- local currentFumen
							-- if(level == "bsc") then
								-- currentFumen = 1
							-- elseif(level == "adv") then
								-- currentFumen = 2
							-- elseif(level == "ext") then
								-- currentFumen = 3
							-- end
							-- --print("currentFumen",currentFumen)
							-- pdata = iHaveThisSong
							-- audio.dispose(scene.bgm)
							-- scene.bgm = nil
							-- scene.bgm = audio.loadStream(pdata.mp3)
							-- scene.bgmPath = pdata.mp3
							-- --print("SONG : ",pdata.title)
							-- local finalFumen = myHighestFumen
							-- for k,v in pairs(iHaveThisFumen) do
								-- if(v >= currentFumen) then
									-- finalFumen = v
									-- break
								-- end
							-- end
							-- --print("FUMENIDX",finalFumen)
							-- levelData = iHaveThisSong.level[finalFumen]
							-- --print("READY1 send")
							gameNetwork.request("sendMessage", 
							{
								playerIDs = scene.finalPlayers,
								roomID = scene.roomID,
								message =  "Ready1"..tostring(USER_NAME)
							})
						-- end
					-- end
				elseif(msg:find("Ready1")) then
					timer.performWithDelay(2500-syncD,function()
						gameNetwork.request("sendMessage", 
						{
							playerIDs = scene.finalPlayers,
							roomID = scene.roomID,
							message =  "Ready2"
						})
					end)
				elseif(msg:find("Ready2")) then
					--print("READY2 Recevied")
					gameNetwork.request("sendMessage", 
					{
						playerIDs =scene.finalPlayers,
						roomID = scene.roomID,
						message =  "GO"
					})
				elseif(msg == "GO") then
					--print("GOGOGO")
					if(scene.gameStarted ~= true) then
						scene.gameStarted = true
						firsttime()
						playNow()
					end
				else
					local arr2 = string.gmatch(msg, "[^\n]+")
					local arr = {}
					for v in arr2 do
						table_insert(arr,v)
					end	
					-- message =  tostring(math_floor(score+0.5)).."\n"..tostring(nCombo).."\n"..tostring(sName).."\n"..USER_NAME.."\n"..willsend..pid
					-- local idx = scene.finalPlayersIDX[event.daparticipantID]
					-- --print(idx)
					local receive = arr[5]
					rivalScores[arr[6]] = arr
					local datas = {}
					for k,v in pairs(rivalScores) do
						table_insert(datas,v)
					end
					for idx,v in pairs(datas) do
						local small = smallSprites[idx]
						for indexK = 1,16,1 do
							local received = v[5]:sub(indexK,indexK)
							scene.rival[idx].text =v[4]
							scene.rivalSC[idx].text =v[1]
							if(received == "1") then
								local sst = small.s_thunders[indexK]
								sst.isVisible = true
								sst.frame = 1
								sst:play()
								table_insert_timers(scene.markerSpeed,function() sst.isVisible = false end)
							elseif(received == "p") then
								local sst = small.s_perfects[indexK]
								small.s_thunders[indexK].isVisible =false
								sst.isVisible = true
								sst.frame = 1
								sst:play()
								table_insert_timers(500,function() sst.isVisible = false end)
							elseif(received == "b") then
								local sst = small.s_notgoods[indexK]
								small.s_thunders[indexK].isVisible =false
								sst.isVisible = true
								sst.frame = 1
								sst:play()
								table_insert_timers(500,function() sst.isVisible = false end)
							elseif(received == "g") then
								local sst = small.s_goods[indexK]
								small.s_thunders[indexK].isVisible =false
								sst.isVisible = true
								sst.frame = 1
								sst:play()
								table_insert_timers(500,function() sst.isVisible = false end)
							elseif(received == "r") then
								local sst = small.s_greats[indexK]
								small.s_thunders[indexK].isVisible =false
								sst.isVisible = true
								sst.frame = 1
								sst:play()
								table_insert_timers(500,function() sst.isVisible = false end)
							end
						end
					end
				end
			end
			if event.type == "connectedRoom" then
				-- for k,v in pairs(event.data) do
					-- --print(k,v)
				-- end
				-- --print("event.data[1]",event.data[1])
				-- --print("event.data.roomID",event.data.roomID)
				-- gameNetwork.request("sendMessage",
				-- {
					-- playerIDs = event.data[1],
					-- roomID = event.data.roomID,
					-- message =  "SNAME"..pdata.title
				-- })
			end
			if event.type == "joinRoom" or event.type == "createRoom" then
				--print("SHOW WAIT",event.data.roomID)
				scene.roomID = event.data.roomID
				if event.data.isError then 
					--print("ERROR2!",event.type,"ROOMID(DBG)",scene.roomID)
					native.showAlert("Room Error", "Error Has Occured!")
				else
					local function waitingRoomListener(waitingRoomEvent)
						--print(waitingRoomEvent.data.phase.."!")
						if waitingRoomEvent.data.phase == "start" then
							--print("START!")
							-- We only need the first player because its a 2 player game
							scene.finalPlayers = {waitingRoomEvent.data[1],waitingRoomEvent.data[2],waitingRoomEvent.data[3]}
							scene.finalPlayersIDX = {}
							scene.finalPlayersIDX[tostring(waitingRoomEvent.data[1])] = 1
							scene.finalPlayersIDX[tostring(waitingRoomEvent.data[2])] = 2
							scene.finalPlayersIDX[tostring(waitingRoomEvent.data[3])] = 3
							scene.currentPlayers = #scene.finalPlayers
							--print("ROOM",scene.roomID,tostring(waitingRoomEvent.data[1]))
							isMultiPlayer = true
							timer.performWithDelay(1500,function()
								gameNetwork.request("sendMessage",
								{
									playerIDs = scene.finalPlayers,
									roomID = scene.roomID,
									message =  "SNAME"..trim(pdata.title)
								})
							end)
							--print("REQUESTED!")
						else
							isMultiPlayer = false
							firsttime()
							playNow()
						end
						--print("LISTENER2!",event.type)
					end
					
					gameNetwork.show("waitingRoom", {
						listener = waitingRoomListener,
						roomID = scene.roomID,
						minPlayers = 1,
						maxPlayers = 3,
					})
				end
			end
		end
		
		local function selectPlayersListener(event)
			--print("PHASE",event.data.phase,"PID",event.data[1])
			if(event.data.phase == "selected") then
				--print("CREATE WITH",event.data[1],event.data[2],event.data[3])
				scene.players = {event.data[1],event.data[2],event.data[3]}
				scene.maxAutoMatchPlayers = event.data.maxAutoMatchPlayers
				scene.minAutoMatchPlayers = event.data.minAutoMatchPlayers
				--print("MAX",event.data.maxAutoMatchPlayers) -- --prints the maximum number of auto match players
				--print("MIN",event.data.minAutoMatchPlayers) -- --prints the minimum number of auto match players
				-- for k,v in pairs(event.data) do
					-- if(type(k) == "number") then
						-- table_insert(players,v)
						-- --print("WITH",v)
					-- end
				-- end
				--print("TOTAL",#scene.players)
				gameNetwork.request( "createRoom",{
					listener = roomListener,
					playerIDs = scene.players,
					minAutoMatchPlayers = scene.minAutoMatchPlayers,
					maxAutoMatchPlayers = scene.maxAutoMatchPlayers,
				})
			else
				--print("JOIN!")
				gameNetwork.show("invitations", {
				listener = function(invitationsEvent)
					if(invitationsEvent.data.phase == "cancelled" or invitationsEvent.data.isError) then
						isMultiPlayer = false
						firsttime()
						playNow()
					else
						gameNetwork.request("joinRoom",
						{
							listener = roomListener,
							roomID = invitationsEvent.data.roomID,
						})
					end
				end})
			end
		end
	if(loggedIntoGC and online) then
		gameNetwork.show("selectPlayers", {
			listener = selectPlayersListener,
			minPlayers = 1,
			maxPlayers = 3,
		})
	end
	-- Runtime:addEventListener("enterFrame",performLater)
	-- if(pdata.isTBJ) then
		-- delay = delay - 30
	-- end
	local s_number = 0
	local rects = {}
	local rectCount = 0
	local rectColor = {{0,1,0},{1,0,0},{0,0,1},{1,1,0}}
	scene.chktime = function()
		if("Win" == system.getInfo("platformName")) then
			-- print("UDP",scene.udp:receive())
			local udp_received = scene.udp:receive()
			if(udp_received ~= nil) then
				local udp_index = tonumber(udp_received)
				-- print(udp_index)
				touch(udp_index,"")
			end
		end
		if(scene.halt ~= true and timers ~= nil and timers[k_] ~= nil and timers[k_][1] ~= nil) then
			------print(system.getTimer89() - stime - delay,timers[k_][1])
			if(stime == nil) then
				stime = system.getTimer()
			end
			if(scene.isMusicPlayed ~= true) then
				scene.isMusicPlayed = true
				-- transition.to(scene.bg_,{xScale=1.15,yScale=1.15,time=300,transition=easing.outExpo,iterations=0,delay=600,onComplete=function()
					-- transition.to(scene.bg_,{xScale=0.95,yScale=0.95,time=300,transition=easing.inExpo})
				-- end})
				--print("Q")
				local diff4 = system.getTimer()
				
				local diff3 = 0
				diff = -diff3
				diff = 0
				scene.startedTime = system.getTimer()
				-- media.playSound(scene.bgmPath)
				--print("-DIFF3",diff)
				-- yyaudio.setVolume(1,{channel=4})
				-- audio.rewind(scene.bgmPlay)
				scene.bgmPlay,scene.bgmSource = audio.play(scene.bgm,{channel=4,loops=0})
				-- al.Source(scene.bgmSource,al.SAMPLE_OFFSET,0)
				-- print("AL",al.GetSource(scene.bgmSource,al.SAMPLE_OFFSET,0))
				table_insert_timers(audio.getDuration(scene.bgm)+1650,eom)
				local function shutter()
					transition.to(scene.shutterd,{time=scene.bpm,xScale=1.035,yScale=1.035,transition=easing.inExpo,transition=easing.inExpo,onComplete=function()
						transition.to(scene.shutterd,{time=scene.bpm,xScale=1,yScale=1,onComplete=shutter})
					end})
					transition.to(scene.shutteru,{time=scene.bpm,xScale=1.075,yScale=1.075,onComplete=function()
						transition.to(scene.shutteru,{time=scene.bpm,xScale=1,yScale=1})
					end})
				end
				shutter()
				-- stime = system.getTimer()
				-- timer.performWithDelay(5500,eom})
				--print("DUR",system.getTimer()+audio.getDuration(scene.bgm)+1650)
			--67
			end
			if(isAuto and scene.isMusicPlayed == true and timers[ck_] ~= nil and (system.getTimer() - stime - delay - diff) - (timers[ck_][1] - scene.msFactor) > 0) and platformName == "Win" then
				-- print((system.getTimer() - stime - delay - diff) - (timers[ck_][1] - scene.msFactor),scene.msFactor)
				local syncDiff = (system.getTimer() - stime - delay - diff) - (timers[ck_][1] - scene.msFactor)
				if(scene.lastClap ~= timers[ck_][1]) then
					-- table_insert_timers(scene.markerFactor - syncDiff,function()
						-- ia = ia+1
						-- audio.play(ssclap,{channel=15+ia%17})
					-- end)
				end
				scene.lastClap = timers[ck_][1]
				ck_ = ck_ + 1
			end
			if(scene.isMusicPlayed == true and (system.getTimer() - stime - delay - diff + scene.msFactor) - (timers[k_][1] + syncD) > 0) then
				-- print((system.getTimer() - stime - delay - diff) - (timers[k_][1] - scene.msFactor),scene.msFactor)
				-- --print(system.getTimer() - stime - delay - offset - diff)
				local syncDiff = (system.getTimer() - stime - delay - diff + scene.msFactor) - (timers[k_][1] + syncD)
				while(k_ <= #timers and scene.halt == false) do
					local index = timers[k_][2]
					local isStimulate = false
					if(timers[k_+1] ~= nil and timers[k_+1][1] == timers[k_][1]) then
						isStimulate = true
					end
					if(timers[k_-1] ~= nil and timers[k_-1][1] == timers[k_][1]) then
						isStimulate = true
					end
					if(true) then
						-- --print(syncDiff)
						-- syncDiff = 0
						if(replayLoad ~= nil and scene.halt ~= true) then
							smallSprites[1].s_thunders[index].isVisible = true
							smallSprites[1].s_thunders[index].frame = 1
							smallSprites[1].s_thunders[index]:play()
							local loaded = replayLoad[k_]
							if(loaded == nil and isMultiPlayer ~= true) then
								table_insert_timers(scene.markerSpeed,function()
									smallSprites[1].s_thunders[index].isVisible = false
								end)
							elseif(isMultiPlayer ~= true and loaded ~= nil) then
								table_insert_timers((1/24)*loaded*scene.markerSpeed,function()
									smallSprites[1].s_thunders[index].isVisible = false
									if(loaded <= 5 and loaded ~= 1  and scene.halt ~= true) then
										smallSprites[1].s_notgoods[index].isVisible = true
										smallSprites[1].s_notgoods[index].frame = 1
										smallSprites[1].s_notgoods[index]:play()
										table_insert_timers(500,function()
											smallSprites[1].s_notgoods[index].isVisible = false
										end)
										replayCombo = 0
										replayScore = replayScore + badScore
										-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
									elseif(loaded <= 10 and loaded ~= 1  and scene.halt ~= true) then
										smallSprites[1].s_goods[index].isVisible = true
										smallSprites[1].s_goods[index].frame = 1
										smallSprites[1].s_goods[index]:play()
										table_insert_timers(500,function()
											smallSprites[1].s_goods[index].isVisible = false
										end)
										replayCombo = replayCombo + 1
										replayScore = replayScore + goodScore
										-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
									elseif(loaded <= 14 and loaded ~= 1  and scene.halt ~= true) then
										smallSprites[1].s_greats[index].isVisible = true
										smallSprites[1].s_greats[index].frame = 1
										smallSprites[1].s_greats[index]:play()
										table_insert_timers(500,function()
											smallSprites[1].s_greats[index].isVisible = false
										end)
										replayCombo = replayCombo + 1
										replayScore = replayScore + greatScore
										-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
									elseif(loaded <= 17 and loaded ~= 1  and scene.halt ~= true) then
										smallSprites[1].s_perfects[index].isVisible = true
										smallSprites[1].s_perfects[index].frame = 1
										smallSprites[1].s_perfects[index]:play()
										table_insert_timers(500,function()
											smallSprites[1].s_perfects[index].isVisible = false
										end)
										replayCombo = replayCombo + 1
										replayScore = replayScore + perfectScore
										-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
									elseif(loaded <= 19 and loaded ~= 1  and scene.halt ~= true) then
										smallSprites[1].s_greats[index].isVisible = true
										smallSprites[1].s_greats[index].frame = 1
										smallSprites[1].s_greats[index]:play()
										table_insert_timers(500,function()
											smallSprites[1].s_greats[index].isVisible = false
										end)
										replayCombo = replayCombo + 1
										replayScore = replayScore + greatScore
										-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
									elseif(loaded <= 22 and loaded ~= 1  and scene.halt ~= true) then
										smallSprites[1].s_goods[index].isVisible = true
										smallSprites[1].s_goods[index].frame = 1
										smallSprites[1].s_goods[index]:play()
										table_insert_timers(500,function()
											smallSprites[1].s_goods[index].isVisible = false
										end)
										replayCombo = replayCombo + 1
										replayScore = replayScore + goodScore
										-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
									else
										smallSprites[1].s_notgoods[index].isVisible = true
										smallSprites[1].s_notgoods[index].frame = 1
										smallSprites[1].s_notgoods[index]:play()
										table_insert_timers(500,function()
											smallSprites[1].s_notgoods[index].isVisible = false
										end)
										replayCombo = 0
										replayScore = replayScore + badScore
										-- combo2.text = "Rival Name : "..USER_NAME.." / Rival Combo : "..tostring(replayCombo).."\nRival Score: "..tostring(math_floor(replayScore+0.5)).." / Rival Song:" ..sName
									end
									scene.rivalSC[1].text = tostring(math_floor((replayScore)+0.5))
									combo3.text = "Rival : "..tostring(math_floor((replayScore - score)+0.5))
								end)
							end
						end
						sending[index] = 1
						----print("INDEX!!!",index,system.getTimer() - stime - delay,timers[k_][1])
						
						-- thunder[index] = display.newSprite(base,{name="base",start=1,count=24,time=900,loopCount=1})
						thunder[index].isVisible = true
						-- thunder[index].startTime = (timers[k_][1]) + scene.startedTime - scene.msFactor + delay + diff + syncD
						thunder[index].startTime = system.getTimer()
						-- thunder[index].startTime = system.getTimer() - syncDiff
						thunder[index].noteIndex = k_
						----print(thunder[index])
						-- thunder[index].x,thunder[index].y = coords[index],coords_[index]+10
						thunder[index]:play()
						-- thunder[index]
						thunder[index].frame = 1
						-- thunder[index].frame = 1 + math_floor(syncDiff/(scene.markerFactor))
						scene.panel:toFront()
						scene.panel2:toFront()
						-- thunder[index].isVisible = true
						thunder[index].dtime = timers[k_][1]
						if(started) then
							barcount = barcount + 1
						end
						if(isStimulate and isEasy) then
							rects[index] = _G.nr(coords[index],coords_[index],pHeight/4,pHeight/4)
							rects[index]:setFillColor(unpack(rectColor[rectCount%3+1]))
							rects[index].alpha = 0.2
							group:insert(rects[index])
							-- print(timers[k_][1],scene.lastRectTime)
							scene.lastRectTime = (timers[k_+1] or {})[1]
							if(((scene.lastRectTime or -65536) ~= timers[k_][1])) then
								rectCount = rectCount + 1
							end
							table_insert_timers(scene.markerFactor - syncDiff,function()
								display.remove(rects[index])
								rects[index] = nil
							end)
						end
						if(isAuto or isEasy) then
							-- if("Win" == system.getInfo("platformName")) then
								-- timer.performWithDelay((1/24)*15*900,function()
								-- end})
							-- end
							local t_number = _G.nt({text=tostring(s_number%16 + 1),x=coords[index],y=coords_[index],fontSize=130})
							t_number:setFillColor(1,0.3,0.3)
							group:insert(t_number)
							display.recalculateS(t_number)
							table_insert_timers(scene.markerFactor - syncDiff,function()
								display.remove(t_number)
								t_number = nil
							end)
						end
							-- table_insert_timers(900/24*16 - syncD,function()
								-- if(thunder[index].dtime ~= lastDT and clap) then
									-- -- if "Win" == system.getInfo("platformName") then
										-- ia = ia+1
										-- audio.play(ssclap,{channel=15+ia%17})
									-- -- end
									-- -- --print("CLAP!")
									-- lastDT = thunder[index].dtime
								-- end
							-- end)
						table_insert_timers(scene.markerFactor - syncDiff,function()
						end)
							-- thunder[index]:addEventListener( "sprite", function(event) listen(system.getTimer(),event,thunder[index]) end)
						-- scene.bgContainer:toFront()
						table_insert_timers(scene.markerSpeed,function()
							----------print(index.."!!!!!")
							if(thunder[index].isVisible == true and scene.halt ~= true and isAuto ~= true) then
								nCombo = 0
								bmsc = bmsc + 1
								msc = msc + 1
								updateCombo()
								bscore = bscore + -4/noteCount
								if(bscore > 1) then
									bscore = 1
								end
								if(bscore<-1) then
									bscore = -1
								end
								thunder[index].isVisible = false
							end
						end)
						if(timers[k_] ~= nil and timers[k_+1] ~= nil and timers[k_+1][1] ~= nil) then
							if(timers[k_][1] - timers[k_ + 1][1] < 0) then
								if(isMultiPlayer == true) then
									local willsend = ""
									for k,v in pairs(sending) do
										if(v == 1) then
											willsend = willsend .. "1"
										else
											willsend = willsend .. "0"
										end
									end
									sending = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
									gameNetwork.request("sendMessage", 
									{
										playerIDs = scene.finalPlayers,
										roomID = scene.roomID,
										message =  tostring(math_floor(score+0.5)).."\n"..tostring(nCombo).."\n"..tostring(sName).."\n"..USER_NAME.."\n"..willsend.."\n"..tostring(scene.localPlayerID)
									})
								end
								k_ = k_ + 1
								break
							end
						end
						k_ = k_ + 1
					else
						k_ = k_ + 1
						break
					end
				end
				s_number = s_number + 1
			end
		end
	end
end
-- Called when scene is about to move offscreen:
function scene:hide( event )
	if(true) then
		--print("VARS!")
		media.stopSound()
		audio.stop()
		if(scene.timebar ~= nil) then
			--print("TIMEBAR")
			timer.cancel(scene.timebar)
		else
			--print("ERR","TIMBEAR")
		end
		if(scene.timeUpdate ~= nil) then
			timer.cancel(scene.timeUpdate)
		end
		scene.bgmPlay = nil
		audio.dispose(scene.bgm)
		scene.bgm = nil
		transition.cancel()
		scene.halt = true
		scene.halted = true
		display.remove(scene.panel)
		display.remove(scene.panel2)
		delayFuncs = {}
		-- for k,v in pairs(scene.timers) do
			-- if(v ~= nil) then
				-- timer.cancel(v)
			-- end
		-- end
		Runtime:removeEventListener( "key", scene.onKeyEvent )
		Runtime:removeEventListener("enterFrame",scene.chktime)
		Runtime:removeEventListener("touch", scene.touched)
		-- Runtime:removeEventListener("enterFrame", performLater)
	end
	-- local i
	-- for i = 1,group.numChildren do
		-- group:remove(i)
	-- end
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	-- halt = true
	-- for k,v in pairs(timers) do
		-- timer.cancel(v)
		-- --------print("TT:"..k)
	-- end
	-- timers = {}
	-- display.remove(self.view)	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	local group = self.view
	transition.cancel()
	for ik=1,group.numChildren do
		-- -- print(ik,"REM",group[ik])
		display.remove(group[ik])
		group[ik] = nil
	end	
	display.remove(group)
	group = nil
	scene = nil
	--------print("HALT3")
	-- halt = true
	-- group:removeSelf()
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

return scene