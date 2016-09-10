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

local Widget = require( 'widget' )
Widget.setTheme( "widget_theme_android_holo_dark" )

local FileUtils = require( "utilities.file" )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view

	ui.bg = UI:setBg({
		parent 		= group,
		fill 		= { 0 },
		y 			= centerY + Theme.headerHeight
		})

	ui.header = UI:setHeader({
		parent 	= group,
		title 	= 'Settings'
		})

end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then
		local settings = FileUtils.loadTable( "settings.json" )
		-- have to initialize settings in case file doesn't exist
		settings = settings or default_settings

		ui.audioLabel = display.newText( group, "Sound?", 50, 80, 'Lato.ttf', 18 )
		ui.audioLabel.anchorX, ui.audioLabel.anchorY = 0, 0
		-- Create a default on/off switch (using widget.setTheme)
		ui.audio_switch = Widget.newSwitch({
		    left = 230,
		    top = 75,
		    style = 'checkbox',
		    initialSwitchState = settings.audio,
		    -- onPress = audio_switch_handler,
		    -- onRelease = audio_switch_handler,
		})
		group:insert( ui.audio_switch )

		ui.volumeLabel = display.newText( group, "Volume", 50, 110, 'Lato.ttf', 18 )
		ui.volumeLabel.anchorX, ui.volumeLabel.anchorY = 0, 0
		-- Create a default on/off switch (using widget.setTheme)
		ui.volume_slider = Widget.newSlider({
		    left 	= 150,
		    top 	= 105,
		    width 	= 150,
		    value 	= settings.audioVolume,
		    -- onPress = audio_switch_handler,
		    -- onRelease = audio_switch_handler,
		})
		group:insert( ui.volume_slider )

		ui.countinLabel = display.newText( group, "Count In?", 50, 140, 'Lato.ttf', 18 )
		ui.countinLabel.anchorX, ui.countinLabel.anchorY = 0, 0
		-- Create a default on/off switch (using widget.setTheme)
		ui.countin_switch = Widget.newSwitch({
		    left = 230,
		    top = 135,
		    style = 'checkbox',
		    initialSwitchState = settings.countIn,
		    -- onPress = audio_switch_handler,
		    -- onRelease = audio_switch_handler,
		})
		group:insert( ui.countin_switch )
	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		local settings = {
			audio 			= ui.audio_switch.isOn,
			audioVolume 	= ui.volume_slider.value,
			countIn 		= ui.countin_switch.isOn
		}

		FileUtils.saveTable( settings, "settings.json" )

		display.remove( ui.audio_switch )
		display.remove( ui.volume_slider )
		display.remove( ui.countin_switch )

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

