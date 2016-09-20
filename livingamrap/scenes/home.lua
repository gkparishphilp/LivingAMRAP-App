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

local Debug = require( 'utilities.debug' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}

-- Called when the scene's view does not exist:
function scene:create( event )
end

function scene:show( event )
	local group = self.view

	if event.phase == 'will' then
		local Layout = require( 'ui.layout_' .. screenOrient )

		ui.bg = UI:setBg({
			parent 		= group,
			width 		= Layout.width,
			height 		= Layout.height,
			x 			= Layout.width * 0.5,
			y 			= Layout.height * 0.5,
			wrapX 		= 'repeat',
			wrapY 		= 'repeat',
			fillScale 	= 1,
			fill 		= { type = 'image', filename = 'assets/images/bgs/bg6.jpg' },
			})
		-- local function repeatTrans()
		-- 	transition.to( bg.fill, { time=4000, x=bg.fill.x+0.5, onComplete=repeatTrans })
		-- end
		-- repeatTrans()

		ui.bgDim = display.newRect( group, Layout.centerX, Layout.centerY, Layout.width, Layout.height )
		ui.bgDim.fill = { 0, 0, 0, 0.5 }

		ui.title1 = display.newText({
			parent 	= group,
			text 		= 'Living',
			font 		= 'NothingYouCouldDo.ttf',
			fontSize 	= 36,
			x 			= Layout.centerX - 80,
			y 			= Layout.home.titleY
			})
		ui.title1.fill = Theme.colors.whiteGrey

		ui.title2 = display.newText({
			parent 	= group,
			text 		= 'AMRAP',
			font 		= Theme.fonts.black,
			fontSize 	= 36,
			x 			= Layout.centerX - 80 + ui.title1.contentWidth + 30,
			y 			= Layout.home.titleY
			})
		ui.title2.fill = Theme.colors.whiteGrey

		local width = ui.title1.contentWidth + ui.title2.contentWidth + 10
		ui.title1.anchorX = 0
		ui.title2.anchorX = 0
		ui.title1.x = Layout.centerX - ( width * 0.5 )
		ui.title2.x = ui.title1.x + ui.title1.contentWidth + 10

		ui.btns = {}
		for i = 1, #Layout.home.buttons do 
			ui[i] = Btn:new({
				group 			= group,
				label			= Layout.home.buttons[i].label,
				x				= Layout.home.buttons[i].x,
				y				= Layout.home.buttons[i].y,
				width			= Layout.home.buttons[i].width,
				height			= Layout.home.buttons[i].height,
				fontSize		= Layout.home.buttons[i].fontSize,
				onRelease 		= function() Composer.gotoScene( Layout.home.buttons[i].target ) end
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

