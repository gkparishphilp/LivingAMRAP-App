---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local mFloor = math.floor  

local Btn = require( 'ui.btn' )
local Theme = require( 'ui.theme' )
local UI = require( 'ui.factory' )
local Clock = require( 'objects.clock' )
local json = require( 'json' )
local FileUtils = require( "utilities.file" )

local Debug = require( 'utilities.debug' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}
local summaryGroup

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
		title 	= 'All Results'
		})
end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then

		local all_results = FileUtils.loadTable( "all_results.json" )
		-- have to initialize settings in case file doesn't exist
		all_results = all_results or {}

		print( "here are all the results... " )
		Debug.printTable( all_results )

		local y = 70

		for i=1, #all_results do 
			local row = display.newGroup()
			group:insert( row )
			row.bg = display.newRect( row, centerX, y, screenWidth+5, 30 )
			row.bg.fill = {0.1}
			row.bg.strokeWidth =1 
			row.lines = {}

			local summary = table.remove( all_results[i] )

			print( "here are the summary results... " )
			Debug.printTable( summary )

			local titleTxt = display.newText({
				parent = group,
				x 	= 10,
				y 	= y,
				text = summary.summary_title,
				font 	= 'Lato.ttf',
				fontSize = 10
				})
			titleTxt.anchorX = 0


			local dateTxt = display.newText({
				parent = group,
				x 	= centerX,
				y 	= y,
				text = summary.started_at,
				font 	= 'Lato.ttf',
				fontSize = 10
				})
			dateTxt.anchorX = 0

			local result = Clock.humanizeTime( { time = summary.total_time } )

			if summary.workout_type == 'amrap' then 
				result = summary.total_rounds .. ' Rds'
			end

			local resultTxt = display.newText({
				parent = group,
				x 	= screenWidth - 10,
				y 	= y,
				text = result,
				font 	= 'Lato.ttf',
				fontSize = 10
				})
			resultTxt.anchorX = 1


			y = y + 31
		end

	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		
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

