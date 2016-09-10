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
local Clock = require( 'objects.clock' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view

	ui.bg = UI:setBg({
		parent 		= group,
		fill 		= { type = 'image', filename = 'assets/images/bgs/bg5.png' },
		y 		= centerY + Theme.headerHeight
		})

	ui.bgDimmer = display.newRect( group, centerX, centerY, screenWidth, screenHeight )
	ui.bgDimmer.fill = { 0, 0, 0, 0.6 }

	ui.header = UI:setHeader({
		parent 	= group,
		title 	= 'Clock Test',
		})

end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then

		ui.clock = Clock:new({
			parent 		= group,
			startAt 	= 0,
			startAt 	= 5000,
			endAt   	= 0,
			showHunds 	= true,
			fontSize 	= Theme.clockFontSize
			--showHours 	= true
			})

		ui.start = Btn:new({
			parent 	= group,
			label 	= 'start',
			width 	= 80,
			x 		= centerX - screenWidth * 0.3,
			y 	 	= centerY + screenHeight * 0.3,
			bgColor = { 0, 0.33, 0 },
			onRelease = function() ui.clock:start() end
			})

		ui.pause = Btn:new({
			parent 	= group,
			label 	= 'pause',
			width 	= 80,
			x 		= centerX,
			y 	 	= centerY + screenHeight * 0.3,
			bgColor = { 0.33, 0.33, 0 },
			onRelease = function() ui.clock:pause() end
			})

		ui.reset = Btn:new({
			parent 	= group,
			label 	= 'reset',
			width 	= 80,
			x 		= centerX + screenWidth * 0.3,
			y 	 	= centerY + screenHeight * 0.3,
			bgColor = { 0.33, 0, 0 },
			onRelease = function() ui.clock:reset( 3000, 0 ) end
			})

		-- ui.clock:addEventListener( 'timesUp', function() ui.clock:reset( 10000, 0 ) end )
		ui.clock:addEventListener( 'timesUp', function() print( "Time's up!!!!!!!!" ); ui.clock:reset( 3000, 0 ); ui.clock:start() end )

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

