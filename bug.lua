----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
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
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view
	
	if(event.phase == "will") then
		local coords,coords_ = {},{}
		local bg = display.newImageRect("background.png",720,1020)
		bg.x,bg.y = 360,510
		group:insert(bg)
		coords[1],coords_[1] = (720/4)*1-90,(660/4)*1-90+360
		coords[2],coords_[2] = (720/4)*2-90,(660/4)*1-90+360
		coords[3],coords_[3] = (720/4)*3-90,(660/4)*1-90+360
		coords[4],coords_[4] = (720/4)*4-90,(660/4)*1-90+360
		coords[5],coords_[5] = (720/4)*1-90,(660/4)*2-90+360
		coords[6],coords_[6] = (720/4)*2-90,(660/4)*2-90+360
		coords[7],coords_[7] = (720/4)*3-90,(660/4)*2-90+360
		coords[8],coords_[8] = (720/4)*4-90,(660/4)*2-90+360
		coords[9],coords_[9] = (720/4)*1-90,(660/4)*3-90+360
		coords[10],coords_[10] = (720/4)*2-90,(660/4)*3-90+360
		coords[11],coords_[11] = (720/4)*3-90,(660/4)*3-90+360
		coords[12],coords_[12] = (720/4)*4-90,(660/4)*3-90+360
		coords[13],coords_[13] = (720/4)*1-90,(660/4)*4-90+360
		coords[14],coords_[14] = (720/4)*2-90,(660/4)*4-90+360
		coords[15],coords_[15] = (720/4)*3-90,(660/4)*4-90+360
		coords[16],coords_[16] = (720/4)*4-90,(660/4)*4-90+360
		local pt_entities = {}
		local math_abs = math.abs
		function touch(index,event)
			local target = pt_entities[index]
			local realTarget = pt_entities[index+16]
			local phase = event.phase
			if(index == 1) then
				print(1)
			end
			if(phase == "began") then
				target.isVisible = true
				print(event.id)
				display.getCurrentStage():setFocus(realTarget,event.id)
			elseif(phase == "moved") then
				if(math_abs(event.x - target.x) > target.width/2 or math_abs(event.y - target.y) > target.height/2) then
					print("OVER")
					target.isVisible = false
					display.getCurrentStage():setFocus(realTarget,nil)
				else
					target.isVisible = true
					display.getCurrentStage():setFocus(realTarget,event.id)
				end
			else
				target.isVisible = false
				display.getCurrentStage():setFocus(realTarget,nil)
			end
		end
		for k,v in pairs(coords) do 	
			-- local touchPos = widget.newButton({x=coords[k],y=coords_[k],defaultFile="panel_unselected.png",overFile="panel_selected.png"
			-- ,onPress=function() touch(k,"began") print("BEGAN") end})
			-- touchPos.isVisible = false
			-- touchPos.isHitTestable = true
			pt_entities[k+16] = display.newImageRect("panel_unselected.png",175,162.5)
			pt_entities[k] = display.newImageRect("panel_selected.png",175,162.5)
			group:insert(pt_entities[k])
			group:insert(pt_entities[k+16])
			pt_entities[k].x,pt_entities[k].y = coords[k],coords_[k]+10
			pt_entities[k+16].x,pt_entities[k+16].y = coords[k],coords_[k]+10
			-- pt_entities[k].xScale,pt_entities[k].yScale = 0.7,0.65
			pt_entities[k].isVisible = false
			pt_entities[k].id = k
			pt_entities[k+16].id = k
			if(isAuto ~= true) then
				pt_entities[k+16]:addEventListener("touch",function(event) touch(k,event) end)
			end
		end
		local panel = display.newImageRect("panel_4x4.png",720,660)
		panel.x,panel.y = 360,330+360
		group:insert(panel)
	end
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