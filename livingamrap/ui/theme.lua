local device = require( 'utilities.device' )


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
			bg 			= { 0, 0, 0, 0.5 },
			bgPressed 	= { 0, 0, 0, 0.8 },
			--bg 			= { 149/255, 100/255, 158/255, 0.5 },
			--bgPressed 	= { 99/255, 50/255, 108/255, 0.8 },
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