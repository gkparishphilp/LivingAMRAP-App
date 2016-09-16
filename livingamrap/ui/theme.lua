local device = require( 'utilities.device' )
local colors = require( 'ui.colors' )

local T = {

	buttons 	= {
		width 		= screenWidth * 0.66,
		height 		= 60,
		fontSize 	= 24,
		iconHeight 	= 18,
		cornerRadius = 4,
		colors 		= {
			label				= { 0.8, 0.8, 0.8 },
			labelPressed		= { 1, 1, 1 },
			bg 			= colors.purple,
			bgPressed 	= colors.dkPurple,
		},
	},
	
	headerHeight 	= 50,
	clockFontSize 	= screenWidth / 3,

	font 		= 'Lato',
	fonts 		= { 
		regular 	= 'Lato',
		light 		= 'Lato-Light',
		bold 		= 'Lato-Bold',
		black 		= 'Lato-Black',
		hairline 		= 'Lato-Hairline',
	},
	
}



function T.colorize( color )
	return color / 255
end

return T