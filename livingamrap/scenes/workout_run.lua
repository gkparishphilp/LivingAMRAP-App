---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local Btn = require( 'ui.btn' )
local Theme = require( 'ui.theme' )
local UI = require( 'ui.factory' )
local Workout = require( 'objects.workout' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}
local workout

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view

end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then
		-- can't change device orientation & force redraw/restart of workout
		reOrientEnabled = false

		local slug = Composer.getVariable( 'objSlug' )
		workout = Workout:new({
			parent 	= group,
			slug 	= slug
			})

		-- ui.go_btn = Btn:new({
		-- 	parent 	= group,
		-- 	label 	= 'Go',
		-- 	width 	= 50,
		-- 	height 	= 50,
		-- 	bgColor = { 0, 1, 0 },
		-- 	y 	= screenHeight - 50,
		-- 	x 	= screenWidth - 50,
		-- 	onRelease = function() timer.cancel( workout.countInTimer ); workout:start(); display.remove( ui.go_btn ) end
		-- 	})
	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		workout:cleanup()
		reOrientEnabled = true
	end
	
end

function scene:destroy( event )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene

