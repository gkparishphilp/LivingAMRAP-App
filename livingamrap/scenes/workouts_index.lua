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
local UI = require( 'ui.factory' )

local json = require( 'json' )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local ui = {}
local data, data_table


-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then
		Composer.setVariable( 'prevScene', 'scenes.home' )
		local Layout = require( 'ui.layout_' .. screenOrient )

		-- ui.bg = UI:setBg({
		-- 	parent 		= group,
		-- 	width 		= Layout.width,
		-- 	height 		= Layout.height - Layout.headerHeight,
		-- 	x 			= Layout.width * 0.5,
		-- 	y 			= Layout.centerY,
		-- 	fillScale 	= 1,
		-- 	fill 		= Layout.workouts_index.bgFill,
		-- 	})

		ui.header = UI:setHeader({
			parent 	= group,
			title 	= 'Workouts',
			x 		= Layout.centerX,
			y 		= 0,
			width 	= Layout.width,
			height 	= Layout.headerHeight
			})

		local function getData( e )
			
			connectionStatus = 'online'
			ui.header:updateConnectionIndicator()
			data =  json.decode( e.response )

			if e.isError or data == nil then
				connectionStatus = 'offline'
				ui.header:updateConnectionIndicator()
				
				local response = require( 'local_data.workouts' )
				data = json.decode( response )
			end

			for i = 1, #data do
				-- Insert a row into the tableView
				data_table:insertRow({
					rowColor = { default={0, 0.1}, over={0 ,0.25} },
					params = { 
						slug 	= data[i].slug,
						label	= data[i].title 
					}
				})
			end
		end

		local url = 'http://localhost:3003/workouts.json'
		network.request( url, 'GET', getData )

		local function onRowRender( e )
			local row = e.row
			-- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			local rowTitle = display.newText( row, row.params.label, 0, 0, Theme.font, 20 )
			rowTitle:setFillColor( 0.75, 0.75, 0.75 )


			-- Align the label left and vertically centered
			rowTitle.anchorX, rowTitle.x  = 0, 25
			rowTitle.y = rowHeight * 0.5
			row.slug = row.params.slug
		end

		local function onRowTouch( e )
			local slug = e.target.params.slug
			Composer.setVariable( 'objType', 'workout' )
			Composer.setVariable( 'objSlug', slug )
			Composer.gotoScene( "scenes.workouts_show" )
		end

		data_table = Widget.newTableView({
			left 			= Layout.dataTableHpad,
			top 			= Layout.totalHeaderHeight,
			height 			= Layout.height - Layout.headerHeight,
			width 			= Layout.width - 2*Layout.dataTableHpad,
			hideBackground  = true,
			rowTouchDelay 	= 500,
			onRowRender 	= onRowRender,
			onRowTouch 		= onRowTouch,
			listener 		= scrollListener
		})

		group:insert( data_table )

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

