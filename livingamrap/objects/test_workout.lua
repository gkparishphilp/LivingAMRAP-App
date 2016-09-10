
-- accumulated time
-- segment/round sub timer where round counter is

local osDate = os.date

local Clock = require( 'objects.clock' )
local Composer = require( 'composer' )
local Theme = require( 'ui.theme' )
local UI = require( 'ui.factory' )
local Btn = require( 'ui.btn' )
local json = require( 'json' )

local Debug = require( 'utilities.debug' )


local FileUtils = require( "utilities.file" )

local M = {}

M.audio = {}
M.audio.count = audio.loadSound( 'assets/audio/count_tone.mp3' )
M.audio.go = audio.loadSound( 'assets/audio/go_tone.wav' )
M.audio.round = audio.loadSound( 'assets/audio/powerup.wav' )
M.audio.finished = audio.loadSound( 'assets/audio/buzzer.mp3' )

M.defaults = {
	slug 	= 'cindy'
}

-- ToDo:
-- Need to cleanup
-- need to reset
-- need to record segment results
-- add custom workouts & emom / tabata...tabata
--     auto-advance on timer expiration


function M:new( opts )
	if opts == nil then opts = M.defaults end
	
	-- fill in any missing opts from module defaults
	for key, value in pairs( M.defaults ) do
		if opts[key] == nil then 
			opts[key] = M.defaults[key]
		end
	end

	local workout = display.newGroup()

	local settings = FileUtils.loadTable( "settings.json" )
	-- have to initialize settings in case file doesn't exist
	settings = settings or default_settings

	if opts.group then 
		opts.group:insert( workout )
	elseif opts.parent then 
		opts.parent:insert( workout )
	end

	workout.status = 'initialized'
	workout.slug = opts.slug
	workout.curSegmentIdx = 1

	workout.results = {}
	workout.roundCount = 0
	workout.roundsToComplete = 0


	local function threeTwoOneGo()
		local three = display.newText({
			text = '3',
			x 		= centerX,
			y 		= centerY,
			font 	= 'Lato-Black.ttf',
			fontSize = 1
			})

		local two = display.newText({
			text = '2',
			x 		= centerX,
			y 		= centerY,
			font 	= 'Lato-Black.ttf',
			fontSize = 1
			})

		local one = display.newText({
			text = '1',
			x 		= centerX,
			y 		= centerY,
			font 	= 'Lato-Black.ttf',
			fontSize = 1
			})

		local go = display.newText({
			text = 'Go!',
			x 		= centerX,
			y 		= centerY,
			font 	= 'Lato-Black.ttf',
			fontSize = 1
			})

		local trxn = easing.outInExpo
		transition.to( three, { size = 500, time=1000, transition=trxn, onComplete = function()
				display.remove( three ); if settings.audio then audio.play( M.audio.count ) end; transition.to( two, { size = 500, time=1000, transition=trxn, onComplete = function() 
					display.remove( two ); if settings.audio then audio.play( M.audio.count ) end; transition.to( one, { size = 500, time=1000, transition=trxn, onComplete = function() 
						display.remove( one ); if settings.audio then audio.play( M.audio.count ) end; transition.to( go, { size=300, time=800, transition=trxn, onComplete = function() display.remove( go ); workout:start() end } )
						
						end } )
					end } )
			 end } )
	end

	function workout:countRound()
		if settings.audio then audio.play( M.audio.round ) end
		
		if workout.lastActionTime and ( workout.clock.elapsedTime - workout.lastActionTime < 2000 ) then 
			native.showAlert( 'Double Click', "That's too fast", { 'Ok' } )
			return false
		end
		workout.lastActionTime = workout.clock.elapsedTime

		workout.roundCount = workout.roundCount + 1

		table.insert( workout.results, { segment_id=workout.curSegment.id, round=workout.roundCount, time=workout.clock.elapsedTime } )

		if workout.data.workout_type == 'rft' then 
			if workout.curSegment.repeat_count <= workout.roundCount then 
				workout:finish()
			end
		end
		workout.roundCountDisp = display.newText({
			parent 	= workout,
			text 	= workout.roundCount,
			x 		= centerX ,
			y 		= workout.actionBtn.label.y - 100,
			font 	= 'Lato-Black.ttf',
			fontSize = 1
			})
		transition.to( workout.roundCountDisp, { size=500, duration=1200, onComplete=function() transition.to( workout.roundCountDisp, { size=20, duration=1000, x=workout.roundDisp.x+15, y=workout.roundDisp.y, onComplete=function() display.remove( workout.roundCountDisp ); workout.roundDisp.text="Round: " .. workout.roundCount end } ) end } )
	end

	function workout:start()
		if settings.audio then audio.play( M.audio.go ) end
		workout.startedAt = osDate( "%Y-%m-%d %H:%M" )
		self.isVisible = true
		self.clock:start()
		self.status = 'running'
	end

	function workout:finish()
		if settings.audio then audio.play( M.audio.finished ) end
		self.clock:pause()
		workout.startedAt = osDate( "%Y-%m-%d %H:%M" )
		table.insert( workout.results, { 
			workout_id		= workout.slug,
			total_rounds	= workout.roundCount,
			total_time		= workout.clock.elapsedTime,
			started_at		= workout.startedAt,
			ended_at		= workout.endedAt,
			summary_title	= workout.summaryTitle,
			workout_type	= workout.data.workout_type,
			cover_img		= workout.data.cover_img 
			})

		print( 'Workout Finished' )
		Debug.printTable( workout.results )

		Composer.setVariable( 'workoutResults', workout.results )
		
		self.status = 'finished'
		self.actionBtn.label.text = 'Done'
		self.actionBtn.onRelease = function() Composer.gotoScene( 'scenes.workout_summary' ) end
	end

	function workout:advanceSegment()

		if workout.lastActionTime and ( workout.clock.elapsedTime - workout.lastActionTime < 2000 ) then 
			native.showAlert( 'Double Click', "That's too fast", { 'Ok' } )
			return false
		end
		workout.lastActionTime = workout.clock.elapsedTime

		workout.curSegmentIdx = workout.curSegmentIdx + 1
		table.insert( workout.results, { 
			segment_id		= workout.curSegment.id,
			round 			= workout.roundCount,
			time 			= workout.clock.elapsedTime,
			segment_content = workout.curSegment.content
			})
		
		if workout.curSegmentIdx > #workout.data.segments then 
			workout:finish()
		else
			workout.curSegment = workout.data.segments[workout.curSegmentIdx]
		end

		if settings.audio then audio.play( M.audio.round ) end

		for i=1, #workout.data.segments do 
			local curDisplay = workout.segmentsDisplay[i]
			curDisplay.isVisible = false
			local font = 'Lato-Hairline.ttf'
			if i == workout.curSegmentIdx then 
				font = 'Lato.ttf'
			end
			workout.segmentsDisplay[i] = display.newText({
				parent 	= workout,
				text 	= curDisplay.text,
				x 		= curDisplay.x,
				y 		= curDisplay.y,
				font 	= font,
				fontSize = curDisplay.size
				})
			
			workout.segmentsDisplay[i].y = workout.segmentsDisplay[i].y - workout.segmentsDisplay[i].contentHeight 
			

			if i <= workout.curSegmentIdx - 1 then 
				workout.segmentsDisplay[i].alpha = 0.25
			end
			if i <= workout.curSegmentIdx - 2 then 
				workout.segmentsDisplay[i].alpha = 0.001 
			end

			if i >= workout.curSegmentIdx + 3 then 
				workout.segmentsDisplay[i].alpha = 0.001 
			end

			curDisplay:removeSelf()
			curDisplay = nil
		end
		
	end

	function M:loadData( slug )
		local function getData( e )
			if e.isError then
				--native.showAlert( 'Connection Error', e.response .. "\nUsing local data.", { 'Ok' } )
				local response = require( 'local_data.workouts.' .. workout.slug )
				M.data = json.decode( response )
			else
				M.data =  json.decode( e.response )
			end
			workout.data = M.data
			table.sort( workout.data.segments, function(a,b) return a.seq < b.seq end )

			workout.summaryTitle = workout.data.title 

			workout.curSegment = workout.data.segments[workout.curSegmentIdx]

			workout.header = UI:setHeader({
				parent 		= workout,
				title 		= workout.data.title
				})

			if workout.data.cover_img and settings.timerBgs then 
				local name = workout.data.cover_img:match( "([^/]+)$" )
				display.loadRemoteImage( workout.data.cover_img, 'GET', function(e) workout.bg = e.target;workout.bg.anchorY=0;workout:insert( workout.bg );workout.bgDimmer=display.newRect( workout, centerX, 50, screenWidth, screenHeight );workout.bgDimmer.anchorY=0;workout.bgDimmer.fill={ 0, 0, 0, 0.5 };workout.bgDimmer:toBack(); workout.bg:toBack(); end, name, centerX, 50 )
			end

			local startAt, endAt
			if workout.data.workout_type == 'ft' or workout.data.workout_type == 'rft' then 
				startAt = 0
				endAt = -1
			else 
				startAt = workout.curSegment.duration
				endAt = 0 
			end

			workout.clock = Clock:new({
				parent 		= workout,
				y 			= 60,
				fontSize 	= Theme.clockFontSize,
				startAt 	= startAt,
				endAt 		= endAt,
				showHunds 	= true
				})
			workout.clock.anchorY = 0

			workout.overview = display.newText({
				parent 	= workout,
				text 	= workout.data.overview_title,
				width 	= screenWidth-20,
				x 		= centerX,
				y 		= workout.clock.y + workout.clock.contentHeight + 15,
				font 	= 'Lato.ttf',
				fontSize 	= 22,
				align 		= 'center'
				})
			workout.overview.anchorY = 0

			workout.overSep = display.newLine( workout, 50, workout.overview.y + workout.overview.contentHeight+5, screenWidth-50, workout.overview.y + workout.overview.contentHeight+5 )
			workout.overSep.alpha = 0.5

			workout.activeSegY =  centerY -- workout.overview.y + workout.overview.contentHeight + 10
			local curY = workout.activeSegY

			if workout.data.workout_type == 'rft' or workout.data.workout_type == 'amrap' then
				workout.roundDisp = display.newText({
					parent 	= workout,
					text  	= "Round: " .. workout.roundCount,
					x 		= centerX,
					y 		= workout.overSep.y + 25,
					font 	= 'Lato.ttf',
					fontSize = 18,

					})
			end
		
			workout.segmentsDisplay = {}
			
			for i=1, #workout.data.segments do
				print( workout.data.segments[i].content )
				local font = 'Lato-Hairline.ttf'
				if i == workout.curSegmentIdx then 
					font = 'Lato.ttf'
				end
				local selectedFont = 'Lato.ttf'
				workout.segmentsDisplay[i] = display.newText({
					parent 	= workout,
					text 	= workout.data.segments[i].content,
					width 	= screenWidth-20,
					align 		= 'center',
					y 		= curY,
					x 		= centerX,
					font 	= font,
					fontSize = 28
					})

				workout.segmentsDisplay[i].fill = { 1, 1, 1}
				workout.segmentsDisplay[i].anchorY = 0
				

				curY = curY + workout.segmentsDisplay[i].contentHeight + 5

			end



			workout.actionBg = display.newRect( workout, centerX, screenHeight * 0.75, screenWidth, screenHeight * 0.25 )
			workout.actionBg.fill = { 0, 0, 0.1, 0.1 }
			workout.actionBg.anchorY = 0

			workout.actionBtn = Btn:new({
				parent 		= workout,
				label 		= 'Action',
				height  	= screenHeight * 0.15,
				x 			= centerX,
				y 			= screenHeight - ( screenHeight * 0.125 ),
				bgColor = { 0, 0.33, 0 },
				})

			if #workout.data.segments > 1 then
				workout.actionBtn.onRelease = function() workout:advanceSegment() end
				workout.actionBtn.label.text = 'Next!'
			elseif #workout.data.segments == 1 and workout.data.workout_type == 'ft' then
				workout.actionBtn.label.text = 'Time!'
				workout.actionBtn.onRelease = function() workout:finish() end
			elseif #workout.data.segments == 1 and workout.data.workout_type == 'amrap' then
				workout.actionBtn.label.text = 'Round!'
				workout.actionBtn.onRelease = function() workout:countRound() end
				workout.clock:addEventListener( 'timesUp', function() workout:finish() end )
			elseif workout.data.workout_type == 'rft' then 
				workout.actionBtn.label.text = 'Round!'
				workout.actionBtn.onRelease = function() workout:countRound() end
			else
				workout.actionBtn.onRelease = function() native.showAlert( 'hello', "whatsup?", { 'Ok' } ) end
			end

			workout.isVisible = false

			if settings.countIn then
				threeTwoOneGo()
			else
				workout:start()
			end
		end




		local url = 'http://localhost:3003/workouts/' .. workout.slug .. '.json'
		network.request( url, 'GET', getData )
	end

	self:loadData( slug )


	function workout:cleanup()
		workout.clock:pause()
		workout.clock:cleanup()
		display.remove( self )
	end

	return workout 
end


return M