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

local function calcPercent()
	local percent = ( tonumber( ui.percentTxt.text ) / 100 ) * tonumber( ui.amountTxt.text )
	ui.resultTxt.text = percent
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then
		Composer.setVariable( 'prevScene', 'scenes.tools' )
		local Layout = require( 'ui.layout_' .. screenOrient )

		-- ui.bg = UI:setBg({
		-- 	parent 		= group,
		-- 	width 		= Layout.width,
		-- 	height 		= Layout.height * 3,
		-- 	x 			= Layout.width * 0.5,
		-- 	y 			= Layout.centerY,
		-- 	fillScale 	= 1,
		-- 	fill 		= Theme.colors.coal,
		-- 	})

		ui.header = UI:setHeader({
			parent 	= group,
			title 	= '% Calculator',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight,
			backTo 	= Composer.getSceneName( 'previous' )
			})


		ui.percentTxt = display.newText({
			parent 	= group,
			text 	= '50',
			x 		= Layout.centerX - 30,
			y 		= 120,
			font 	= Theme.font,
			fontSize = 32,
			})
		ui.percentTxt.anchorX = 1
		ui.percentTxt:addEventListener( 'tap', function(e) ui.keypad.bindTo=e.target; ui.keypad.digits=2; ui.keypad.label = "%"; ui.keypad:show() end )

		ui.percentLabel = display.newText({
			parent 	= group,
			text 	= "%  of",
			Font 	= Theme.fonts.light,
			x 		= Layout.centerX,
			y 		= 120,
			fontSize 	= 24
			})

		ui.amountTxt = display.newText({
			parent 	= group,
			text 	= '0',
			x 		= Layout.centerX + 30,
			y 		= 120,
			font 	= Theme.font,
			fontSize = 32
			})
		ui.amountTxt.anchorX = 0
		ui.amountTxt:addEventListener( 'tap', function(e) ui.keypad.bindTo=e.target; ui.keypad.digits=3; ui.keypad.label=''; ui.keypad:show() end )

		ui.resultTxt = display.newText({
			parent 	= group,
			text 	= '0',
			x 		= Layout.centerX,
			y 		= 180,
			font 	= Theme.font,
			fontSize = 40
			})
		

		ui.keypad = Keypad:new({
			bindTo 		= ui.percentTxt,
			onComplete = calcPercent
			})
		
	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		display.remove( ui.keypad )
		display.remove( ui.percentTxt )
		display.remove( ui.amountTxt )
		display.remove( ui.resultTxt )
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

