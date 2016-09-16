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
		title 	= 'Workout Summary'
		})
end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then

		local all_results = FileUtils.loadTable( "all_results.json" )
		-- have to initialize settings in case file doesn't exist
		all_results = all_results or {}

		results = Composer.getVariable( 'workoutResults' )

		table.insert( all_results, results )
		FileUtils.saveTable( all_results, "all_results.json" )

		-- print( "here are your results... " )
		-- Debug.printTable( results )


		summaryGroup = display.newGroup()
		group:insert( summaryGroup )

		local summaryData = table.remove( results )

		if summaryData.cover_img then 
			display.remove( ui.bg )
			local name = summaryData.cover_img:match( "([^/]+)$" )
			display.loadRemoteImage( summaryData.cover_img, 'GET', function(e) ui.bg = e.target;ui.bg.anchorY=0;group:insert( ui.bg );ui.bgDimmer=display.newRect( summaryGroup, centerX, 50, screenWidth, screenHeight );ui.bgDimmer.anchorY=0;ui.bgDimmer.fill={ 0, 0, 0, 0.5 };ui.bgDimmer:toBack(); ui.bg:toBack(); end, name, centerX, 50 )
		end

		local y = 80
		local yPad = 40

		ui.workoutTitle = display.newText({
			parent 	= summaryGroup,
			text 	= summaryData.summary_title,
			x 		= centerX,
			y 		= y,
			font 	= 'Lato-Bold.ttf',
			fontSize 	= 24
			})

		y = y + yPad

		ui.dateDisp = display.newText({
			parent 	= summaryGroup,
			text 	= "Performed at: " .. summaryData.started_at,
			x 		= centerX,
			y 		= y,
			font 	= 'Lato.ttf',
			fontSize = 20
			})

		y = y + yPad

		local totalTime = string.format( "%02d", Clock.getMinutes( summaryData.total_time ) ) .. ':' .. string.format( "%02d", Clock.getSeconds( summaryData.total_time ) ) .. '.' .. string.format( "%02d", Clock.getHundredths( summaryData.total_time ) )

		ui.totalDisp = display.newText({
			parent 	= summaryGroup,
			text 	= "Total Time: " .. totalTime,
			x 		= centerX,
			y 		= y,
			font 	= 'Lato.ttf',
			fontSize = 20
			})

		y = y + yPad

		ui.sep = display.newLine( summaryGroup, 50, y, screenWidth-50, y )
		ui.sep.alpha = 0.5

		y = y + yPad

		ui.segResultsDisp = {}

		for i=1, #results do 
			if not( results[i].segment_type == 'rest' ) then

				local formattedTime = string.format( "%02d", Clock.getMinutes( results[i].time ) ) .. ':' .. string.format( "%02d", Clock.getSeconds( results[i].time ) ) .. '.' .. string.format( "%02d", Clock.getHundredths( results[i].time ) )
				if i > 1 then 
					formattedTime = string.format( "%02d", Clock.getMinutes( results[i].time - results[i-1].time ) ) .. ':' .. string.format( "%02d", Clock.getSeconds( results[i].time - results[i-1].time ) ) .. '.' .. string.format( "%02d", Clock.getHundredths( results[i].time - results[i-1].time ) )
				end
				
				lbl = results[i].segment_content

				if results[i].segment_type == 'rft' then 
					lbl = lbl .. "(round " .. results[i].round ..')'
				end

				if not( results[i].round == 0 ) then 
					lbl = lbl .. "(round " .. results[i].round ..')'
				end

				ui.segResultsDisp[i] = display.newText({
					parent 	= summaryGroup,
					text 	= lbl .. ":  " .. formattedTime,
					x 		= centerX,
					y 		= y,
					font 	= 'Lato.ttf',
					fontSize = 18
					})
				y = y + yPad / 1.5

			end

		end

		
		local function urlResp( e )
			--native.showAlert( 'posted', 'Results posted', { 'Ok' } )
		end
		local jsonResults = {}
		jsonResults.workout_id = summaryData.workout_id
		jsonResults.started_at = summaryData.started_at

		if summaryData.workout_type == 'amrap' then
			jsonResults.value = summaryData.total_rounds
			jsonResults.unit = 'rounds'
		else
			jsonResults.value = summaryData.total_time
			jsonResults.unit = 'ms'
		end

		jsonResults.segment_results = results

		--print( "Json Reuslts: " .. json.prettify( jsonResults ) )

		jsonResults = json.encode( jsonResults )

		local url = "http://localhost:3003/measurements"
		network.request( url, 'POST', urlResp, { body="measurement="..jsonResults } )


	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		display.remove( summaryGroup )
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

