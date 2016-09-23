---------------------------------------------------------------------------------
--
-- Used to setup a quik workout:
-- Quick AMRAP: enter total time, we add round/rep counter
-- Quick RFT: enter rounds to complete, we add round counter
-- Quick FT: we just run up a clock
-- Quick Interval (EotM): enter interval and total intervals
-- Quick TABATA
--
---------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local Widget = require( "widget" )
Widget.setTheme( "widget_theme_android_holo_dark" )

local Btn = require( 'ui.btn' )
local Theme = require( 'ui.theme' )
local UI = require( 'ui.factory' )
local json = require( 'json' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then
		local Layout = require( 'ui.layout_' .. screenOrient )

		ui.bg = UI:setBg({
			parent 		= group,
			width 		= Layout.width,
			height 		= Layout.height - Layout.headerHeight,
			x 			= Layout.width * 0.5,
			y 			= Layout.centerY + Layout.headerHeight,
			fillScale 	= 1,
			fill 		= { type = 'image', filename = 'assets/images/bgs/bg2.png' },
			})

		ui.header = UI:setHeader({
			parent 	= group,
			title 	= 'Quick Workout',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight,
			backTo 	= Composer.getSceneName( 'previous' )
			})

		ui.btns = {}
		for i = 1, #Layout.workout_setup.buttons do 
			ui[i] = Btn:new({
				group 			= group,
				label			= Layout.workout_setup.buttons[i].label,
				x				= Layout.workout_setup.buttons[i].x,
				y				= Layout.workout_setup.buttons[i].y,
				width			= Layout.workout_setup.buttons[i].width,
				height			= Layout.workout_setup.buttons[i].height,
				fontSize		= Layout.workout_setup.buttons[i].fontSize,
				onRelease 		= function() Composer.gotoScene( Layout.workout_setup.buttons[i].target ) end
			})
		end




	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
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

