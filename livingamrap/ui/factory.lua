
-- General UI convenience methods for things like setting background, 
-- creating headers, keypads, native textboxes, etc...

local Composer = require( 'composer' )
local Btn = require( 'ui.btn' )
local Theme = require( 'ui.theme' )
local Colors = require( 'ui.colors' ) 

local bgDefaults = {
	x 			= centerX,
	y 			= centerY,
	width 		= screenWidth,
	height 		= screenHeight,
	fill 		= Colors.ltGray,
}

local headerDefaults = {
	backTo 		= 'scenes.home',
	width 		= screenWidth,
	height 		= Theme.headerHeight,
	backBtn 	= true,
	fontSize 	= 26,
	fontColor 	= { 0.95, 0.95, 0.95, 1 },
	bgColor 	= Colors.mdGrey,
	btnColor 	= Colors.green,
	borderColor = Colors.dkGrey
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
		labelColor  	= { 0 } ,
		bgColor 		= Colors.red,
		bgColorPressed 	= Colors.dkRed,
		width			= 30,
		height			= 30,
		strokeWidth 	= 1,
		x				= 20,
		y				= opts.height/2,
		font 			= 'Lato.ttf',
		fontSize		= 12,
		onRelease 		= function() Composer.gotoScene( opts.backTo ) end
	})

	header.menu_btn = Btn:new({
		parent 			= header,
		imageIcon 		= '/assets/images/menu-icon.png',
		labelColor  	= opts.fontColor,
		bgColor 		= Colors.blue,
		bgColorPressed 	= Colors.dkBlue,
		width			= 30,
		height			= 30,
		strokeWidth 	= 1,
		x				= screenWidth-20,
		y				= opts.height/2,
		fontSize		= 14,
		onRelease 		= function() if Composer.getVariable( 'overlay' ) then transition.to( header.menu_btn.imageIcon, { rotation = 0 } ); Composer.hideOverlay( 'slideRight' ) else transition.to( header.menu_btn.imageIcon, { rotation = 90 } ); Composer.showOverlay( "scenes.menu_overlay", { effect='fromRight', time=800 } ) end end
	})


	header.title = display.newText({
		parent 		= header, 
		text 		= opts.title,
		x 			= screenWidth - 50, 
		y 			= opts.height/2,
		font 		= 'Lato-Light.ttf',
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
