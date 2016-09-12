-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local device = require( 'utilities.device' )

centerX = display.contentCenterX
centerY = display.contentCenterY
screenWidth = display.contentWidth
screenHeight = display.contentHeight

default_settings = {
	audio		= true,
	audioVolume = 0.5,
	countIn 	= 3,
}

local Composer = require "composer"

print ( "Physical Device Width: " .. device.physicalW )
print ( "Physical Device Height: " .. device.physicalH ) 

print( "Screen Height: " .. screenHeight )
print( "Screen Width: " .. screenWidth )

print( "Scale Factor: " .. display.pixelWidth / display.actualContentWidth )

display.setStatusBar( display.HiddenStatusBar )

-- handle android key events
local function onKeyPress( event )

	local phase = event.phase
	local key_name = event.keyName

	-- nest these crazy ifs so we always return true s oAndroid doesn't grab the 'down' phase
	if key_name == "back" then
		if phase == 'up' then
			if Composer.getVariable( 'overlay' ) then
					Composer.hideOverlay( 'slideRight' )
			else
				if Composer.getSceneName( 'current' ) == 'scenes.home' then
					native.requestExit()
				elseif ( Composer.getSceneName( 'previous' ) ) then
					Composer.gotoScene( Composer.getSceneName( 'previous' ) )
				else
					native.requestExit()
				end
			end
		end
		return true
	else
		return false
	end
end
--add the key callback
Runtime:addEventListener( "key", onKeyPress )

Composer.gotoScene( "scenes.home" )

