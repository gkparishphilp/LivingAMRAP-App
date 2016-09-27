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
local TextToSpeech = require( 'plugin.texttospeech' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}
local data



-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then
		Composer.setVariable( 'prevScene', 'scenes.workouts_index' )
		local Layout = require( 'ui.layout_' .. screenOrient )

		-- ui.bg = UI:setBg({
		-- 	parent 		= group,
		-- 	width 		= Layout.width,
		-- 	height 		= Layout.height - Layout.headerHeight,
		-- 	x 			= Layout.width * 0.5,
		-- 	y 			= Layout.centerY + Layout.headerHeight,
		-- 	fillScale 	= 1,
		-- 	fill 		= { type = 'image', filename = 'assets/images/bgs/bg3.png' },
		-- 	})

		ui.dimmer = display.newRect( group, Layout.centerX, Layout.centerY, Layout.width, Layout.height )
		ui.dimmer.fill = { 0, 0, 0, 0.5 }

		ui.header = UI:setHeader({
			parent 	= group,
			title 	= 'Workouts',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight,
			backTo 	= Composer.getSceneName( 'previous' )
			})


		ui.overview_title = display.newText({
			parent 		= group,
			text 		= '',
			x 			= Layout.workouts_show.titleX,
			y 			= Layout.workouts_show.titleY,
			width 		= Layout.workouts_show.titleWidth,
			fontSize 	= 24,
			font 		= Theme.fonts.black,
			align 		= "center",
			})
		ui.overview_title.anchorY = 0

		ui.overview_content = display.newText({
			parent 		= group,
			text 		= '',
			x 			= Layout.workouts_show.overviewX,
			y 			= Layout.workouts_show.overviewY,
			width 		= Layout.workouts_show.overviewWidth,
			height 		= Layout.workouts_show.overviewHeight,
			font 		= Theme.fonts.light,
			fontSize 	= 22,
			align 		= "center"
			})
		ui.overview_content.anchorY = 0

		ui.go_btn = Btn:new({
			group 	= group,
			x 		= Layout.workouts_show.goBtnX,
			y 		= Layout.workouts_show.goBtnY,
			width 	= Layout.workouts_show.goBtnWidth,
			height 	= Layout.workouts_show.goBtnHeight,
			fontSize 	= 20,
			label 	= "Ready! Ready!",
			bgColor 	= Theme.colors.dkGreen,
			bgColorPressed 	= Theme.colors.green,
			onRelease 	= function() TextToSpeech.speak( 'Ready. Ready.', { pitch = 0.9, volume = 0.98 } ); Composer.gotoScene( "scenes.workout_run", { effect='fade', time=1000 } ) end
			})



		local slug = Composer.getVariable( 'objSlug' )
		
		local function getData( e )
			
			connectionStatus = 'online'
			ui.header:updateConnectionIndicator()
			data =  json.decode( e.response )

			if e.isError or data == nil then
				connectionStatus = 'offline'
				ui.header:updateConnectionIndicator()

				local response = require( 'local_data.workouts.' .. slug )
				data = json.decode( response )
			end

			ui.header.title.text = data.title

			ui.overview_title.text = data.overview_title

			ui.overview_content.text = data.overview_content
			ui.overview_content.y = ui.overview_title.y + ui.overview_title.contentHeight + 25

			display.remove( ui.bg )

			if data.cover_img then 
				local name = data.cover_img:match( "([^/]+)$" )
				display.loadRemoteImage( data.cover_img, 'GET', function(e) ui.bg = e.target; ui.bg.anchorY=0; group:insert( ui.bg ); ui.bg:toBack(); end, name, Layout.centerX, Layout.headerHeight )
			else
				ui.bg = display.newImageRect( group, 'assets/images/bgs/bg3.png', Layout.width, Layout.height )
				ui.bg.x = Layout.centerX
				ui.bg.anchorY = 0
				ui.bg.y = 50
				ui.bg:toBack()
			end
		end


		local url = 'http://localhost:3003/workouts/' .. slug .. '.json'
		network.request( url, 'GET', getData )


	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		display.remove( ui.overview_title )
		display.remove( ui.overview_content )
		display.remove( ui.bg )
		display.remove( ui.dimmer )
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

