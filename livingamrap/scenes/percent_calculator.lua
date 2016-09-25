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

local function setPercent()
	
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
			title 	= '% Calculator',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight,
			backTo 	= Composer.getSceneName( 'previous' )
			})

		

		ui.keypad = Keypad:new({
			onComplete 	= function() ui.userVal.text = ui.keypad.value end
			})

		ui.userVal = display.newText({
			parent 	= group,
			text 	= '120',
			x 		= display.contentCenterX * 0.33,
			y 		= display.contentCenterY,
			fontSize = 32,
			})
		ui.userVal:addEventListener( 'tap', function(e) ui.keypad:show() end )

		-- Create two tables to hold data for days and years      
		local days = {}
		local years = {}

		-- Populate the "days" table
		for d = 1, 31 do
		    days[d] = d
		end

		-- Populate the "years" table
		for y = 1, 48 do
		    years[y] = 1969 + y
		end

		-- Configure the picker wheel columns
		local column_data = 
		{
		    -- Months
		    { 
		        align = "right",
		        width = 140,
		        startIndex = 5,
		        labels = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
		    },
		    -- Days
		    {
		        align = "center",
		        width = 60,
		        startIndex = 18,
		        labels = days
		    },
		    -- Years
		    {
		        align = "center",
		        width = 80,
		        startIndex = 10,
		        labels = years
		    }
		}
		ui.picker = Widget.newPickerWheel({
			parent 	= group,
			x 		= display.contentCenterX * 1.5,
			y 		= display.contentCenterY,
			columns = column_data
			})

	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		display.remove( ui.keypad )
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

