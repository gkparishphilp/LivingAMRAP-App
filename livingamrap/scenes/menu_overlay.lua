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

		panel.frame = display.newRoundedRect( group, screenWidth, 50, screenWidth * 0.66, 300, 6 )
		panel.frame.anchorX, panel.frame.anchorY = 1, 0
		panel.frame.fill = { 0.15 }
		panel.frame.alpha = 0.85

		panel.frame.stroke = {type="image", filename="assets/images/brushes/blur_brush1x4.png"}
		panel.frame.strokeWidth = 6
		panel.frame:setStrokeColor( 0.25, 0.25, 0.25, 0.5 )
		
		local y = 80

		ui.home_link = display.newText({
			parent 	= panel,
			text 	= 'Home',
			font 	= 'Lato.ttf',
			fontSize 	= 16,
			x 		= screenWidth * 0.33 + 40,
			y 		= y
			})
		ui.home_link.anchorX = 0

		y = y + 20 
		ui.sep = display.newLine( panel, screenWidth * 0.33 + 40, y, screenWidth-40, y )
		ui.sep:setStrokeColor( 0.33 )
		y = y + 20 

		ui.results_link = display.newText({
			parent 	= panel,
			text 	= 'Results',
			font 	= 'Lato.ttf',
			fontSize 	= 16,
			x 		= screenWidth * 0.33 + 40,
			y 		= y
			})
		ui.results_link.anchorX = 0

		y = y + 20 
		ui.sep = display.newLine( panel, screenWidth * 0.33 + 40, y, screenWidth-40, y )
		ui.sep:setStrokeColor( 0.33 )
		y = y + 20 

		ui.settings_link = display.newText({
			parent 	= panel,
			text 	= 'Settings',
			font 	= 'Lato.ttf',
			fontSize 	= 16,
			x 		= screenWidth * 0.33 + 40,
			y 		= y
			})
		ui.settings_link.anchorX = 0

		y = y + 20 
		ui.sep = display.newLine( panel, screenWidth * 0.33 + 40, y, screenWidth-40, y )
		ui.sep:setStrokeColor( 0.33 )
		y = y + 20 

		ui.workouts_link = display.newText({
			parent 	= panel,
			text 	= 'Workouts',
			font 	= 'Lato.ttf',
			fontSize 	= 16,
			x 		= screenWidth * 0.33 + 40,
			y 		= y
			})
		ui.workouts_link.anchorX = 0

		y = y + 20 
		ui.sep = display.newLine( panel, screenWidth * 0.33 + 40, y, screenWidth-40, y )
		ui.sep:setStrokeColor( 0.33 )
		y = y + 20 

		ui.movements_link = display.newText({
			parent 	= panel,
			text 	= 'Movements',
			font 	= 'Lato.ttf',
			fontSize 	= 16,
			x 		= screenWidth * 0.33 + 40,
			y 		= y
			})
		ui.movements_link.anchorX = 0

		y = y + 20 
		ui.sep = display.newLine( panel, screenWidth * 0.33 + 40, y, screenWidth-40, y )
		ui.sep:setStrokeColor( 0.33 )
		y = y + 20 

		ui.account_link = display.newText({
			parent 	= panel,
			text 	= 'Account',
			font 	= 'Lato.ttf',
			fontSize 	= 16,
			x 		= screenWidth * 0.33 + 40,
			y 		= y
			})
		ui.account_link.anchorX = 0

		y = y + 20 
		ui.sep = display.newLine( panel, screenWidth * 0.33 + 40, y, screenWidth-40, y )
		ui.sep:setStrokeColor( 0.33 )
		y = y + 20 

		ui.logout_link = display.newText({
			parent 	= panel,
			text 	= 'Logout',
			font 	= 'Lato.ttf',
			fontSize 	= 16,
			x 		= screenWidth * 0.33 + 40,
			y 		= y
			})
		ui.logout_link.anchorX = 0

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