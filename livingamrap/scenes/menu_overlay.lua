---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Libraries & Modules
---------------------------------------------------------------------------------
local Composer = require( "composer" )
local scene = Composer.newScene()

local Btn = require( 'ui.btn' )


---------------------------------------------------------------------------------
-- Scene Variables
---------------------------------------------------------------------------------
local panel = display.newGroup()
local ui = {}

---------------------------------------------------------------------------------
-- Scene Functions
---------------------------------------------------------------------------------
function scene:create( event )
	local group = self.view

end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then

		panel.frame = display.newRoundedRect( group, screenWidth, 50, 200, 300, 6 )
		panel.frame.anchorX, panel.frame.anchorY = 1, 0
		panel.frame.fill = { 0.15 }
		panel.frame.alpha = 0.85

		panel.frame.stroke = {type="image", filename="assets/images/brushes/blur_brush1x4.png"}
		panel.frame.strokeWidth = 6
		panel.frame:setStrokeColor( 0.25, 0.25, 0.25, 0.5 )
		
		ui.title = display.newText( panel, "Hello!", 0, 0, 'Lato.ttf', 28 )
		ui.title.anchorY, ui.title.anchorX = 0, 0.5
		ui.title.y = 70
		ui.title.x = screenWidth * 0.66

		ui.info = display.newText( panel, "This is just some text blah blah blah", 0, 0, panel.frame.width-40, panel.height-80, 'Lato-Bold.ttf', 16 )
		ui.info.anchorY, ui.info.anchorX = 0, 0.5
		ui.info.y = 130
		ui.info.x = screenWidth * 0.66


		ui.close_btn = Btn:new({
			group 	= panel,
			label 	= 'Close',
			width		= 60,
			height		= 30,
			x			= screenWidth * 0.66,
			y			= panel.frame.height,
			onRelease = function() Composer.hideOverlay( 'slideRight' ) end
		})

		group:insert( panel )

	elseif event.phase == "did" then
		Composer.setVariable( 'overlay', true )
	end
	
end

function scene:hide( event )
	if event.phase == "will" then

	elseif event.phase == "did" then
		Composer.setVariable( 'overlay', false )
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