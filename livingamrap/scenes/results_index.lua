
---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local Composer = require( "composer" )
local scene = Composer.newScene()

local Widget = require( "widget" )
Widget.setTheme( "widget_theme_android_holo_dark" )

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
local summaryGroup, data_table

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
			title 	= 'Results',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight
			})


		local all_results = FileUtils.loadTable( "all_results.json" )
		-- have to initialize settings in case file doesn't exist
		all_results = all_results or {}

		print( "here are all the results... " )
		Debug.printTable( all_results )


		local function onRowTouch( e )
			local slug = e.target.params.slug
			Composer.setVariable( 'objType', 'result' )
			Composer.setVariable( 'objSlug', slug )
			Composer.gotoScene( "scenes.results_show" )
		end

		local function onRowRender( e )
			local row = e.row
			-- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			
			local rowTitle = display.newText( row, row.params.label, 0, 0, Theme.font, 10 )
			rowTitle:setFillColor( 0.75, 0.75, 0.75 )
			-- Align the label left and vertically centered
			rowTitle.anchorX, rowTitle.x  = 0, 10
			rowTitle.y = rowHeight * 0.5

			local rowStarted = display.newText( row, row.params.started_at, 0, 0, Theme.font, 10 )
			rowStarted:setFillColor( 0.75, 0.75, 0.75 )
			-- Align the label left and vertically centered
			rowStarted.anchorX, rowStarted.x  = 0, Layout.width*0.45
			rowStarted.y = rowHeight * 0.5


			local result = Clock.humanizeTime( { time = row.params.total_time } )

			if row.params.workout_type == 'amrap' then 
				result = row.params.total_rounds .. ' Rds'
			end

			local rowResult = display.newText( row, result, 0, 0, Theme.font, 10 )
			rowResult:setFillColor( 0.75, 0.75, 0.75 )
			-- Align the label left and vertically centered
			rowResult.anchorX, rowResult.x  = 0, Layout.width * 0.75
			rowResult.y = rowHeight * 0.5

			row.name = row.params.slug
		end

		data_table = Widget.newTableView({
			left 			= Layout.dataTableHpad,
			top 			= Layout.headerHeight,
			height 			= Layout.height - Layout.headerHeight,
			width 			= Layout.width - 2*Layout.dataTableHpad,
			hideBackground  = true,
			onRowRender 	= onRowRender,
			onRowTouch 		= onRowTouch,
			listener 		= scrollListener
		})

		group:insert( data_table )


		for i = 1, #all_results do
			local summary = all_results[i][#all_results[i]]
			-- Insert a row into the tableView
			data_table:insertRow({
				rowColor = { default={ 0, 0, 0, 0.5}, over={1, 0.5, 0 ,0.8} },
				params = { 
					slug 	= summary.tmp_id,
					label	= summary.summary_title,
					started_at = summary.started_at,
					total_time = summary.total_time,
					workout_type = summary.workout_type,
					total_rounds = summary.total_rounds
				}
			})
		end	

	end
	
end

function scene:hide( event )
	local group = self.view

	if event.phase == "will" then
		display.remove( data_table )
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

