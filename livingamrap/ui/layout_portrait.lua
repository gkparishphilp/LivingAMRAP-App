local device = require( 'utilities.device' )
local Theme = require( 'ui.theme' )

local width = screenWidth
local height = screenHeight

local home = {
	titleY = 40,
	buttons = {
		{
			label = 'Workouts',
			target 	= 'scenes.workouts_index',
			y 		= 100,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Quick Workout',
			target 	= 'scenes.workout_setup' ,
			y 		= 160,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Movemements',
			target 	= 'scenes.movements_index' ,
			y 		= 220,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Tools',
			target 	= 'scenes.tools_index' ,
			y 		= 280,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Results',
			target 	= 'scenes.results_index' ,
			y 		= 340,
			height 	= 36,
			fontSize = 14,
		},

		{
			label = 'Settings',
			target 	= 'scenes.settings' ,
			y 		= 400,
			height 	= 36,
			fontSize = 14,
		},

	}
}

local tools = {
	buttons = {
		{
			label = '% Max Calculator',
			target 	= 'scenes.home',
			y 		= 100,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Max Rep Calculator',
			target 	= 'scenes.home' ,
			y 		= 160,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Calorie Calculator',
			target 	= 'scenes.home' ,
			y 		= 220,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Manual Entry',
			target 	= 'scenes.home' ,
			y 		= 280,
			height 	= 36,
			fontSize = 14,
		}
	}
}

local workoutsIndex = {
	bgFill = { type = 'image', filename = 'assets/images/bgs/workouts_index_port.png' }
}


local workoutSetup = {
	buttons = {
		{
			label = 'AMRAP',
			target 	= 'scenes.home',
			y 		= 100,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'For Time',
			target 	= 'scenes.home' ,
			y 		= 160,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Interval',
			target 	= 'scenes.home' ,
			y 		= 220,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'Rounds for Time',
			target 	= 'scenes.home' ,
			y 		= 280,
			height 	= 36,
			fontSize = 14,
		},
		{
			label = 'TABATA',
			target 	= 'scenes.home' ,
			y 		= 340,
			height 	= 36,
			fontSize = 14,
		}
	}
}


local workoutsShow = {
	titleX 		= width * 0.5,
	titleY 		= 70,
	overviewX 	= width * 0.5,
	overviewY 	= 100,
	goBtnX 		= width * 0.5,
	goBtnY 		= height - 70
}

local workoutSummary = {
	titleX			= width * 0.5,
	titleY			= 70,
	dateX			= width * 0.5,
	dateY			= 100,
	totalX			= width * 0.5,
	totalY			= 130,
	sepStartX 		= 25,
	sepStartY  		= 145,
	sepEndX 		= width-25,
	sepEndY  		= 145,

	resultsBoxTitleX = width * 0.5,
	resultsBoxTitleY = 160,

	resultsBoxX 	= width * 0.5,
	resultsBoxY 	= 175,
	resultsBoxWidth = width - 25,
	resultsBoxHeight = height - ( 175 + 220 ),

	segResultsContDispX = 20,
	segResultsValDispX = width-40,

	rxSwitchX		= 20,
	rxSwitchY		= height - 200,
	rxSwitchLabelX 	= 70,
	rxSwitchLabelY 	= height - 200,

	valueLabelX 		= width - 150,
	valueLabelY		= height - 200,
	valueFieldX 		= width - 50,
	valueFieldY		= height - 200,

	rxReminderX 	= 25,
	rxReminderY 	= height - 175,
	rxReminderWidth = width - 50,
	noteBoxX 		= width * 0.5,
	noteBoxY 		= height - 120,
	noteBoxWidth 	= width - 50,
	submitX 		= width * 0.5,
	submitY  		= height - 40,
	submitWidth		= nil,
	submitHeight 	= nil

}

local workout = {
	headerY 				= 0,
	headerHeight 			= 50,

	clockX 					= width * 0.5,
	clockY 					= 62,
	clockFontSize 			= width / 3,

	infoDisplayX 			= 25,
	infoDisplayY 			= 62 + ( width / 3 ) + 12,
	infoDisplayFontSize 	= 32,
	

	segClockX 				= width - 25,
	segClockY 				= 62 + ( width / 3 ) + 12,
	segClockFontSize 		= 30,

	infoSepStartY	 		= 62 + ( width / 3 ) + 12 + 18,
	infoSepEndY	 			= 62 + ( width / 3 ) + 12 + 18,
	infoSepStartX			= 25,
	infoSepEndX				= width - 25,


	activeSegmentY 			= 62 + ( width / 3 ) + 12 + 32,


	segmentsDisplayFontSize = 28,
	segmentsDisplayYOffset 	= 10,

	segmentsDisplayActiveFont 	= Theme.fonts.regular,
	segmentsDisplayPendingFont 	= Theme.fonts.hairline,

	actionBtnHeight 		= height * 0.16,
	actionBtnWidth			= width * 0.75,
	actionBtnX 				= width * 0.5,
	actionBtnY 				= height - ( screenHeight * 0.125 ),
}


local L = {
	width 	= width,
	height 	= height,
	centerX = width * 0.5,
	centerY = height * 0.5,

	headerHeight 	= 50,
	dataTableHpad 	= 10,

	home 	= home,
	tools 	= tools,
	workouts_index 	= workoutsIndex,
	workout_setup 	= workoutSetup,
	workouts_show 	= workoutsShow,
	workout 		= workout,
	workout_summary = workoutSummary,
}


return L