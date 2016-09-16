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
local Colors = require( 'ui.colors' )
local UI = require( 'ui.factory' )
local json = require( 'json' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}
local data



-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view

	ui.bg = UI:setBg({
		parent 		= group,
		image 			= 'assets/images/bgs/bg3.png',
		--imgWidth 		= ,
		--imgHeight 	= ,
		y 		= centerY + Theme.headerHeight
		})

	ui.header = UI:setHeader({
		parent 	= group,
		title 	= 'Movements',
		backTo 	= Composer.getSceneName( 'previous' )
		})

	ui.overview_bg = display.newRect( group, centerX, 50, screenWidth, screenHeight )
	ui.overview_bg.anchorY = 0
	ui.overview_bg.fill = { 0, 0, 0, 0.5 }

	local options = {
		text = '',
		x = centerX,
		y = 80,
		width = screenWidth,
		height = 0,
		fontSize = 24,
		font 	= Theme.fonts.black,
		align = "center",
		
	}
	ui.overview_title = display.newText( options )
	ui.overview_title.anchorY = 0
	group:insert( ui.overview_title )
	ui.overview_title:setFillColor( 1 )

	local options = {
		text = '',
		x = centerX,
		y = 120,
		width = screenWidth-100,
		height = screenHeight-250,
		font 	= Theme.fonts.light,
		fontSize = 22,
		align = "center"
	}

	ui.overview_content = display.newText( options )
	group:insert( ui.overview_content )
	ui.overview_content.anchorY = 0
	ui.overview_content:setFillColor( 0.95, 0.95, 0.95, 1 )

	ui.header.border = display.newLine( ui.header, 0, 50, screenWidth, 50 )
	--ui.header.border.stroke = {type="image", filename="assets/images/brushes/blur_brush1x4.png"}
	ui.header.border:setStrokeColor( 0.95, 0.95, 0.95 )
	ui.header.border.strokeWidth = 1

	group:insert( ui.header )

end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then

		local slug = Composer.getVariable( 'objSlug' )
		
		local function getData( e )
			if e.isError then
				--native.showAlert( 'Connection Error', e.response .. "\nUsing local data.", { 'Ok' } )
				local response = require( 'local_data.workouts.' .. slug )
				data = json.decode( response )
			else
				data =  json.decode( e.response )
			end

			ui.header.title.text = data.title

			ui.overview_title.text = data.overview_title

			ui.overview_content.text = data.overview_content
			ui.overview_content.y = ui.overview_title.y + ui.overview_title.contentHeight + 25

			display.remove( ui.bg )

			if data.cover_img then 
				local name = data.cover_img:match( "([^/]+)$" )
				display.loadRemoteImage( data.cover_img, 'GET', function(e) ui.bg = e.target; ui.bg.anchorY=0; group:insert( ui.bg ); ui.bg:toBack(); end, name, centerX, 50 )
			else
				ui.bg = display.newImageRect( group, 'assets/images/bgs/bg3.png', screenWidth, screenHeight )
				ui.bg.x = centerX
				ui.bg.anchorY = 0
				ui.bg.y = 50
				ui.bg:toBack()
			end
			

		end


		local url = 'http://localhost:3003/workouts/' .. slug .. '.json'
		network.request( url, 'GET', getData )


		ui.go_btn = Btn:new({
			group 	= group,
			x 	= centerX,
			y 	= screenHeight - 100,
			label 	= "Ready! Ready!",
			bgColor 	= Colors.green,
			bgColorPressed 	= Colors.dkGreen,
			onRelease 	= function() Composer.gotoScene( "scenes.workout_run" ) end
			})

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

