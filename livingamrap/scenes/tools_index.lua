---------------------------------------------------------------------------------
--
-- scene1.lua
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
			height 		= Layout.height,
			x 			= Layout.width * 0.5,
			y 			= Layout.centerY,
			fill 		= Theme.colors.coal,
			})

		ui.header = UI:setHeader({
			parent 	= group,
			title 	= 'Tools',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight,
			backTo 	= Composer.getSceneName( 'previous' )
			})

		ui.btns = {}
		for i = 1, #Layout.tools.buttons do 
			ui[i] = Btn:new({
				group 			= group,
				label			= Layout.tools.buttons[i].label,
				x				= Layout.tools.buttons[i].x,
				y				= Layout.tools.buttons[i].y,
				width			= Layout.tools.buttons[i].width,
				height			= Layout.tools.buttons[i].height,
				fontSize		= Layout.tools.buttons[i].fontSize,
				onRelease 		= function() Composer.gotoScene( Layout.tools.buttons[i].target ) end
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

