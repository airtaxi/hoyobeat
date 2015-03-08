module(..., package.seeall)
PerformanceOutput = {};
PerformanceOutput.mt = {};
PerformanceOutput.mt.__index = PerformanceOutput;
 
 
local prevTime = 0;
local maxSavedFps = 30;
 
local function createLayout(self)
        local group = display.newGroup();
 
        self.memory = display.newText("0/10",0,20, Helvetica, 15);
        
        self.memory:setTextColor(255,0,0);
        
        group:insert(self.memory);
 
        return group;
end
 
local function minElement(table)
        local min = 10000;
        for i = 1, #table do
                if(table[i] < min) then min = table[i]; end
				sum = table[i]
        end
		
        return min;
end
 
local function avrElement(table)
	local sum = 0
	for i = 1, #table do
		sum = sum + table[i]
	end
	return sum/#table;
end
local function getLabelUpdater(self)
        local lastFps = {};
        local lastFpsCounter = 1;
        return function(event)
                local curTime = system.getTimer();
                local dt = curTime - prevTime;
                prevTime = curTime;
        
                local fps = math.floor(1000/dt);
                
                lastFps[lastFpsCounter] = fps;
                lastFpsCounter = lastFpsCounter + 1;
                if(lastFpsCounter > maxSavedFps) then lastFpsCounter = 1; end
                local minLastFps = minElement(lastFps);
				local avrFps = avrElement(lastFps)
                if(fps<100) then
					self.memory.text = "FPS: "..(avrFps - avrFps%1).."\n".."Mem: "..(system.getInfo("textureMemoryUsed")/1000000).." mb";
					self.memory:toFront()
				end
        end
end
 
 
local instance = nil;
-- Singleton
function PerformanceOutput.new()
        if(instance ~= nil) then return instance; end
        local self = {};
        setmetatable(self, PerformanceOutput.mt);
        
        self.group = createLayout(self);
        Runtime:addEventListener("enterFrame", getLabelUpdater(self));
 
        instance = self;
        return self;
end