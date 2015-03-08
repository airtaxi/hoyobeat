--THIS IS WORK AND CODE CREATED BY LERG FOR CORONA SDK/ LUA USE. I DID NOT ADD ANYTHING TO THIS BUT TO UPDATE THE MODULE FOR GFX2. ALL CREDIT GOES TO LERG FOR CREATING THE ORIGINAL CODE.


local _M = {}
 
local mFloor = math.floor
local mMin = math.min
local sGetInfo = system.getInfo
local sGetTimer = system.getTimer
 
local prevTime = 0
_M.added = true
local function createText()
    local memory = display.newText({text='00 00.00 000',fontSize=22});
	memory:setFillColor(1,53/255,53/255)
	-- memory:setFillColor(1)
    memory.anchorY = 0
    memory.x, memory.y = display.contentCenterX, display.screenOriginY+40
    function memory:tap ()
        collectgarbage('collect')
        if _M.added then
            -- Runtime:removeEventListener('enterFrame', _M.labelUpdater)
            _M.added = false
		-- memory.alpha = .01
        else
            -- Runtime:addEventListener('enterFrame', _M.labelUpdater)
            _M.added = true
		-- memory.alpha = 1
        end
    end
    memory:addEventListener('tap', memory)
    return memory
end
local rate = 1
local cnt = 0
-- local rate = (50/(1000/60))
function _M.labelUpdater(event)
    local curTime = sGetTimer()
	cnt = cnt + 1
	if(cnt > 10) then
		cnt = 0
		_M.text.text = 'fps : ' .. tostring(mMin(mFloor( 1000 / ((curTime - prevTime)/rate)),65)) .. ' / Texture : ' ..
				tostring(mFloor(sGetInfo('textureMemoryUsed') * 0.0001) * 0.01) .. 'Mb / Logical : ' ..
				tostring(mFloor(collectgarbage('count'))*0.001) .. 'Mb'
	end
    -- _M.text:toFront()
    prevTime = curTime
end
 
function _M:newPerformanceMeter()
    self.text = createText(self)
    Runtime:addEventListener('enterFrame', _M.labelUpdater)
	-- timer.performWithDelay(50,_M.labelUpdater,-1)
end
 
return _M
