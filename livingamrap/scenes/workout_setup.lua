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
local Keypad = require( 'ui.keypad' )
local json = require( 'json' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}

local function switchListener( e )
	local switch = e.target
	if switch.id == 'tabata' and switch.isOn then
		ui.userVal.isVisible = false
	elseif switch.id == 'rft' and switch.isOn then 
		ui.userVal.isVisible = true
		ui.userVal.text = '0 Rounds'
	else
		ui.userVal.isVisible = true
		ui.userVal.text = '0 mins'
	end
	print( "Switch with ID '"..switch.id.."' is: ".. tostring(switch.isOn) )
end

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
			height 		= Layout.height * 3,
			x 			= Layout.width * 0.5,
			y 			= Layout.centerY,
			fillScale 	= 1,
			fill 		= Theme.colors.coal,
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

		ui.title = display.newText({
			parent 		= group,
			text 		= 'Workout Type:',
			x 			= 20,
			y 			= 100,
			font 		= Theme.fonts.hairline,
			fontSize 	= 24
			})
		ui.title.anchorX = 0

		ui.switches = {}
		local switchGroup = display.newGroup()
		

		for i = 1, #Layout.workout_setup.switches do 
			ui.switches[i] = Widget.newSwitch({
				group 		= switchGroup,
				style		= 'radio',
				id 			= Layout.workout_setup.switches[i].id,
				left		= Layout.workout_setup.switches[i].x,
				top			= Layout.workout_setup.switches[i].y,
				initialSwitchState = Layout.workout_setup.switches[i].init,
				onPress = switchListener
			})

			ui.switches[i].label = display.newText({
				parent 	= switchGroup,
				text 	= Layout.workout_setup.switches[i].label,
				x 		= Layout.workout_setup.switches[i].x + 40,
				y 		= Layout.workout_setup.switches[i].y + 17,
				font 	= Theme.font,
				fontSize = 16
				})
			ui.switches[i].label.anchorX = 0
		end
		group:insert( switchGroup )

		ui.keypad = Keypad:new({
			onComplete 	= function() ui.userVal.text = ui.keypad.value .. ' mins' end
			})

		ui.userVal = display.newText({
			parent 	= group,
			text 	= '0 mins',
			x 		= display.contentCenterX,
			y 		= display.contentCenterY + 50,
			fontSize = 32,
			})
		ui.userVal:addEventListener( 'tap', function(e) ui.keypad:show() end )

	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		display.remove( ui.keypad )
		for i=1, #ui.switches do 
			display.remove( ui.switches[i] )
		end
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

