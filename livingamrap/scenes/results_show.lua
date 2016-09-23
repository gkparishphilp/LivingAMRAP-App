---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local Widget = require( "widget" )
Widget.setTheme( "widget_theme_android_holo_dark" )

local Btn = require( 'ui.btn' )
local Theme = require( 'ui.theme' )
local Clock = require( 'objects.clock' )
local UI = require( 'ui.factory' )
local json = require( 'json' )
local FileUtils = require( 'utilities.file' )
local Debug = require( 'utilities.debug' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}
local data

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then
		local Layout = require( 'ui.layout_' .. screenOrient )

		ui.bg = UI:setBg({
			parent 		= group,
			width 		= Layout.width,
			height 		= Layout.height - Layout.headerHeight,
			x 			= Layout.width * 0.5,
			y 			= Layout.centerY + Layout.headerHeight,
			fill 		= { 0 },
			})

		ui.header = UI:setHeader({
			parent 	= group,
			title 	= 'Workout Result',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight,
			backTo 	= Composer.getSceneName( 'previous' )
			})

		
		ui.workoutTitle = display.newText({
			parent 	= group,
			text 	= "Title",
			x 		= Layout.centerX,
			y 		= 80,
			font 	= 'Lato-Bold.ttf',
			fontSize 	= 24
			})

		ui.dateDisp = display.newText({
			parent 	= group,
			text 	= "Performed at: ",
			x 		= Layout.centerX,
			y 		= 120,
			font 	= 'Lato.ttf',
			fontSize = 14
			})


		ui.totalDisp = display.newText({
			parent 	= group,
			text 	= "Score: ",
			x 		= Layout.centerX,
			y 		= 180,
			font 	= 'Lato.ttf',
			fontSize = 20
			})

		ui.sep = display.newLine( group, 0, 200, Layout.width, 200 )
		ui.sep.alpha = 0.5


		local slug = Composer.getVariable( 'objSlug' )

		local function getData( e )
			
			connectionStatus = 'online'
			ui.header:updateConnectionIndicator()
			data =  json.decode( e.response )

			if e.isError or data == nil then
				connectionStatus = 'offline'
				ui.header:updateConnectionIndicator()

				local all_results = FileUtils.loadTable( "all_results.json" )
				-- have to initialize settings in case file doesn't exist
				all_results = all_results or {}
				-- loop through all results until result tmp_id key
				for i=1, #all_results do
					print( "results[" .. i .."] is: " )
					Debug.printTable( all_results[i] )

					-- the last entry contains the summary data
					if all_results[i][#all_results[i]].tmp_id == slug then 
						data = all_results[i]
					end
				end
			end

			ui.workoutTitle.text = data[#data].summary_title
			ui.dateDisp.text = ui.dateDisp.text .. data[#data].started_at

			local totalTxt = "Total Time: " .. Clock.humanizeTime( { time = data[#data].value, secs = true } )
			if data[#data].workout_type == 'amrap' then 
				totalTxt = "Rounds: " .. data[#data].value 
				if data[#data].sub_value then 
					totalTxt = totalTxt .. ' & ' .. data[#data].sub_value .. ' reps'
				end
			end
			ui.totalDisp.text = totalTxt

		end

		local url = 'http://localhost:3003/workout_results/' .. slug .. '.json'
		network.request( url, 'GET', getData )
	end
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		display.remove( ui.workoutTitle )
		display.remove( ui.bg )
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

