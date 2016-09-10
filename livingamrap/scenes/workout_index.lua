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

	ui.bg = UI:setBg({
		parent 		= group,
		fill 		= { type = 'image', filename = 'assets/images/bgs/bg5.png' },
		y 			= centerY + Theme.headerHeight
		})

	ui.header = UI:setHeader({
		parent 	= group,
		title 	= 'Workouts'
		})

end

function scene:show( event )
	local group = self.view

	if event.phase == "will" then

		local function getData( e )
			if e.isError then
				--native.showAlert( 'Connection Error', e.response .. "\nUsing local data.", { 'Ok' } )
				local response = require( 'local_data.workouts' )
				data = json.decode( response )
			else
				data =  json.decode( e.response )
			end

			for i = 1, #data do
				-- Insert a row into the tableView
				data_table:insertRow({
					rowColor = { default={ 0, 0, 0, 0.5}, over={1, 0.5, 0 ,0.8} },
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
			Composer.gotoScene( "scenes.workout_preview" )
		end

		data_table = Widget.newTableView({
			left 			= 0,
			top 			= 80,
			height 			= screenHeight - 80,
			width 			= screenWidth,
			hideBackground  = true,
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
		data_table:removeSelf()
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

