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
local server_data

local function getServerData( e )
	server_data =  json.decode( e.response )

	ui.header.title.text = server_data.title
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view

		ui.bg = UI:setBg({
		parent 		= group,
		image 			= 'assets/images/bgs/bg1.png',
		--imgWidth 		= ,
		--imgHeight 	= ,
		y 		= centerY + Theme.headerHeight
		})

	ui.header = UI:setHeader({
		parent 	= group,
		title 	= 'Movement',
		backTo 	= Composer.getSceneName( 'previous' )
		})

end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then

		local url = 'http://localhost:3003/movements/' .. event.params.slug .. '.json'
		network.request( url, 'GET', getServerData )



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

