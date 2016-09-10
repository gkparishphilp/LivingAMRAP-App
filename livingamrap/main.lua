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
	countIn 	= true,
}

local Composer = require "composer"

print ( "Physical Device Width: " .. device.physicalW )
print ( "Physical Device Height: " .. device.physicalH ) 

print( "Screen Height: " .. screenHeight )
print( "Screen Width: " .. screenWidth )

print( "Scale Factor: " .. display.pixelWidth / display.actualContentWidth )

display.setStatusBar( display.HiddenStatusBar )

Composer.gotoScene( "scenes.home" )

