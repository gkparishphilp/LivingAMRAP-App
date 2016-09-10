
-- General UI convenience methods for things like setting background, 
-- creating headers, keypads, native textboxes, etc...

local Composer = require( 'composer' )
local Btn = require( 'ui.btn' )
local Theme = require( 'ui.theme' )

local bgDefaults = {
	x 			= centerX,
	y 			= centerY,
	width 		= screenWidth,
	height 		= screenHeight,
	fill 		= { 0.2, 0, 0.2, 1 },
}

local headerDefaults = {
	backTo 		= 'scenes.home',
	width 		= screenWidth,
	height 		= Theme.headerHeight,
	backBtn 	= true,
	fontSize 	= 26,
	fontColor 	= { 0.95, 0.95, 0.95, 1 },
	bgColor 	= { 0, 0, 0, 1 },
	btnColor 	= { 0.5, 0.5, 0.5 },
	borderColor = { 0.5, 0.5, 0.5, 1 }
}

local M = {}




function M:setBg( opts )
	-- uses fills for images, etc. see: 
	-- https://coronalabs.com/blog/2013/11/07/tutorial-repeating-fills-in-graphics-2-0/
	
	if opts == nil then opts = bgDefaults end
	
	-- fill in any missing opts from module defaults
	for key, value in pairs( bgDefaults ) do
		if opts[key] == nil then 
			opts[key] = bgDefaults[key]
		end
	end

	bg = display.newRect( opts.x, opts.y, opts.width, opts.height )
	bg.x = opts.x
	bg.y = opts.y

	if opts.group then
		opts.group:insert( bg )
	elseif opts.parent then 
		opts.parent:insert( bg )
	end

	if opts.wrapX then 
		display.setDefault( "textureWrapX", opts.wrapX )
	end
	if opts.wrapY then 
		display.setDefault( "textureWrapY", opts.wrapY )
	end

	bg.fill = opts.fill

	if opts.fillScale then

		local xFactor = 1 ; local yFactor = 1
		if ( bg.width > bg.height ) then
			yFactor = bg.width / bg.height
		else
			xFactor = bg.height / bg.width
		end
		bg.fill.scaleX =  xFactor * opts.fillScale
		bg.fill.scaleY =  yFactor * opts.fillScale
	end

	if opts.fillX then bg.fill.x = opts.fillX end
	if opts.fillY then bg.fill.y = opts.fillY end
	if opts.fillRotation then bg.fill.rotation = opts.fillRotation end


	return bg
end

function M:setHeader( opts )
	if opts == nil then opts = headerDefaults end
	
	-- fill in any missing opts from module defaults
	for key, value in pairs( headerDefaults ) do
		if opts[key] == nil then 
			opts[key] = headerDefaults[key]
		end
	end

	local header = display.newGroup()
	if opts.group then
		opts.group:insert( header )
	elseif opts.parent then 
		opts.parent:insert( header )
	end

	header.bg = display.newRect( header, centerX, opts.height/2, screenWidth, opts.height )
	header.bg.fill = opts.bgColor

	header.back_btn = Btn:new({
		parent 			= header,
		label 			= 'Back',
		labelColor  	= opts.fontColor,
		bgColor 		= opts.btnColor,
		width			= 60,
		height			= 30,
		strokeWidth 	= 1,
		x				= 40,
		y				= opts.height/2,
		fontSize		= 14,
		onRelease 		= function() Composer.gotoScene( opts.backTo ) end
	})

	header.title = display.newText({
		parent 		= header, 
		text 		= opts.title,
		x 			= screenWidth - 10, 
		y 			= opts.height/2,
		font 		= 'Lato-Bold.ttf',
		fontSize 	= opts.fontSize 
	})
	header.title.fill = opts.fontColor
	header.title.anchorX = 1

	header.border = display.newLine( header, 0, opts.height, screenWidth, opts.height )
	--ui.header.border.stroke = {type="image", filename="assets/images/brushes/blur_brush1x4.png"}
	header.border:setStrokeColor( unpack( opts.borderColor ) )
	header.border.strokeWidth = 1

	return header
end



return M
