local device = require( 'utilities.device' )
local Theme = require( 'ui.theme' )

local width = screenHeight
local height = screenWidth

local home = {
	titleY = 40,
	buttons = {
		{
			label = 'Workouts',
			target 	= 'scenes.workouts_index',
			x 		= width * 0.25,
			y 		= 100,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Quick Workout',
			target 	= 'scenes.workout_setup' ,
			x 		= width * 0.25,
			y 		= 160,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Movemements',
			target 	= 'scenes.movements_index' ,
			x 		= width * 0.25,
			y 		= 220,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Tools',
			target 	= 'scenes.tools_index' ,
			x 		= width * 0.75,
			y 		= 100,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Results',
			target 	= 'scenes.results_index' ,
			x 		= width * 0.75,
			y 		= 160,
			height 	= 36,
			fontSize = 14,
		},

		{
			label = 'Settings',
			target 	= 'scenes.settings' ,
			x 		= width * 0.75,
			y 		= 220,
			height 	= 36,
			fontSize = 14,
		},

	}
}

local workoutsIndex = {
	bgFill = { type = 'image', filename = 'assets/images/bgs/workouts_index_land.png' }
}

local workoutsShow = {
	titleX 		= width * 0.33,
	titleY 		= 70,
	titleWidth 	= width * 0.66,

	overviewX 	= width * 0.33,
	overViewY 	= 100,
	overviewWidth 	= width * 0.66,

	goBtnX 		= width * 0.85,
	goBtnY 		= height * 0.25 + 50,
	goBtnWidth 	= width * 0.25,
	goBtnHeight = height * 0.25

}

local workoutSummary = {
	titleX			= width * 0.25,
	titleY			= 70,
	dateX			= width * 0.66,
	dateY			= 70,

	totalX			= width * 0.25,
	totalY			= 100,
	sepStartX 		= 25,
	sepStartY  		= 125,
	sepEndX 		= width - 25,
	sepEndY  		= 125,

	rxSwitchX		= (width * 0.5 ),
	rxSwitchY		= 100,
	rxSwitchLabelX 	= (width * 0.5 ) + 70,
	rxSwitchLabelY 	= 100,

	resultsBoxX 	= width * 0.33,
	resultsBoxY 	= 140,
	resultsBoxWidth = (width*0.45 ),
	resultsBoxHeight = height - 180,

	segResultsDispX 	= 20,
	



	rxReminderX 	= (width * 0.5 ) + 5,
	rxReminderY 	= 140,
	rxReminderWidth = (width * 0.5 ) - 10,

	noteBoxX 		= width * 0.75,
	noteBoxY 		= 200,
	noteBoxWidth 	= (width * 0.45 ),
	noteBoxHeight 	= height - 160 - 70,

	submitX 		= width * 0.75,
	submitY  		= height - 30,
	submitWidth		= (width * 0.33 ),
	submitHeight 	= 40

}

local workout = {
	headerY 				= 0,
	headerHeight 			= 50,

	clockX 					= width * 0.33,
	clockY 					= 62,
	clockFontSize 			= width / 5,

	infoDisplayX 			= 25,
	infoDisplayY 			= 62 + ( width / 5 ),
	infoDisplayFontSize 	= 32,
	

	segClockX 				= (width*0.66) - 25,
	segClockY 				= 62 + ( width / 5 ),
	segClockFontSize 		= 30,

	infoSepStartY	 		= 62 + ( width / 5 ) + 18,
	infoSepEndY	 			= 62 + ( width / 5 ) + 18,
	infoSepStartX			= 25,
	infoSepEndX				= (width * 0.66) - 25,


	activeSegmentY 			= 62 + ( width / 5 ) + 32,


	segmentsDisplayFontSize = 24,
	segmentsDisplayYOffset 	= 10,

	segmentsDisplayActiveFont 	= Theme.fonts.regular,
	segmentsDisplayPendingFont 	= Theme.fonts.hairline,

	actionBtnX 				= width * 0.85,
	actionBtnY 				= height * 0.25 + 50,
	actionBtnHeight 		= height * 0.25,
	actionBtnWidth			= width * 0.25,
	
}



local L = {
	width 	= width,
	height 	= height,
	centerX = width * 0.5,
	centerY = height * 0.5,

	headerHeight 	= 50,
	dataTableHpad 	= 40,

	home 	= home,
	workouts_index 	= workoutsIndex,
	workouts_show 	= workoutsShow,
	workout 		= workout,
	workout_summary = workoutSummary,
}


return L