---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local Theme = require( 'ui.theme' )
local Btn = require( 'ui.btn' )
local UI = require( 'ui.factory' )
local Clock = require( 'objects.clock' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view



	local y = 120
	local btnPad = 20

	ui.bg = UI:setBg({
		parent 		= group,
		wrapX 		= 'repeat',
		wrapY 		= 'repeat',
		fillScale 	= 1,
		fill 		= { type = 'image', filename = 'assets/images/bgs/bg6.jpg' },
		})
	-- local function repeatTrans()
	-- 	transition.to( bg.fill, { time=4000, x=bg.fill.x+0.5, onComplete=repeatTrans })
	-- end
	-- repeatTrans()

	ui.bgDim = display.newRect( group, centerX, centerY, screenWidth, screenHeight )
	ui.bgDim.fill = { 0, 0, 0, 0.66 }

	ui.title1 = display.newText({
		parent 	= group,
		text 		= 'Living',
		font 		= 'NothingYouCouldDo.ttf',
		fontSize 	= 36,
		x 			= centerX - 80,
		y 			= 40
		})

	ui.title2 = display.newText({
		parent 	= group,
		text 		= 'AMRAP',
		font 		= Theme.fonts.black,
		fontSize 	= 36,
		x 			= centerX - 80 + ui.title1.contentWidth + 30,
		y 			= 40
		})

	local width = ui.title1.contentWidth + ui.title2.contentWidth + 10
	ui.title1.anchorX = 0
	ui.title2.anchorX = 0
	ui.title1.x = centerX - ( width * 0.5 )
	ui.title2.x = ui.title1.x + ui.title1.contentWidth + 10




	ui.select = Btn:new({
		label			= 'Workouts',
		y				= y,
		group 			= group,
		onRelease 		= function() Composer.gotoScene( "scenes.workout_index" ) end
	})

	y = y + Theme.buttons.height + btnPad 

	ui.movements = Btn:new({
		label			= 'Movements',
		y				= y,
		group 			= group,
		onRelease 		= function() Composer.gotoScene( "scenes.movement_index" ) end
	})

	y = y + Theme.buttons.height + btnPad 

	ui.msettigns = Btn:new({
		label			= 'Settings',
		y				= y,
		group 			= group,
		onRelease 		= function() Composer.gotoScene( "scenes.settings" ) end
	})



	ui.test_clock = Btn:new({
		label			= 'View All Results',
		y				= screenHeight - btnPad * 6,
		group 			= group,
		onRelease 		= function() Composer.gotoScene( "scenes.results" ) end
	})

	y = y + Theme.buttons.height + btnPad 

	ui.test_workout = Btn:new({
		label			= 'Test Workout',
		y				= screenHeight - btnPad * 2,
		group 			= group,
		onRelease 		= function() Composer.gotoScene( "scenes.test_workout" ) end
	})

end

function scene:show( event )
	local group = self.view

	if event.phase == 'will' then 

	end

	if event.phase == "did" then

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

