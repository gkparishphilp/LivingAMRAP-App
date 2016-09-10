

-- add a small end-workout button -- user may not want to micro-manage rounds
-- fix results table (add rounds/reps)
-- add notes & rx to results
-- update font size in segment display?
-- add emom mode
-- create a separate tabata module
-- add an accumulated time mode


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
	workout.anims = {}
	workout.totalRoundCount = 0
	workout.roundCount = 0
	workout.roundsToComplete = 0


	local function countIn()
		local countTxt = display.newText({
			text = workout.countInCount,
			x 		= centerX,
			y 		= centerY,
			font 	= 'Lato-Black.ttf',
			fontSize = 1
			})


		local trxn = easing.outInExpo
		if workout.countInCount > 0 then 
			if settings.audio then audio.play( M.audio.count ) end 
			transition.to( countTxt, { size=500, time=900, transition=trxn, onComplete=function() display.remove( countTxt ) end } )
		else
			countTxt.text = 'Go!'
			transition.to( countTxt, { size=300, time=300, onComplete = function() display.remove( countTxt ); workout:start() end } )	
		end

		workout.countInCount = workout.countInCount - 1 
	end


	function workout:countRound()
		if settings.audio then audio.play( M.audio.round ) end
		
		if workout.lastActionTime and ( workout.clock.elapsedTime - workout.lastActionTime < 1000 ) then 
			--native.showAlert( 'Double Click', "That's too fast", { 'Ok' } )
			return false
		end
		workout.lastActionTime = workout.clock.elapsedTime

		workout.roundCount = workout.roundCount + 1
		workout.totalRoundCount = workout.totalRoundCount + 1

		table.insert( workout.results, { 
			segment_id		= workout.curSegment.id,
			segment_type 	= workout.curSegment.segment_type,
			segment_content = workout.curSegment.content,
			round 			= workout.roundCount,
			total_rounds	= workout.totalRoundCount,
			time 			= workout.clock.elapsedTime,
			})


		if not( workout.curSegment.duration ) then
			self.segClock:reset()
			self.segClock:start()
		end

		if workout.curSegment.segment_type == 'rft' then 
			if workout.roundCount >= workout.curSegment.repeat_count then 
				workout:advanceSegment()
			end
		end

		workout.roundCountDisp = display.newText({
			parent 	= workout,
			text 	= workout.roundCount,
			x 		= centerX ,
			y 		= workout.actionBtn.label.y - 100,
			--font 	= 'Lato-Black.ttf',
			font 	= 'digital-7-mono.ttf',
			fontSize = 1
			})
		workout.anims[#workout.anims+1] = transition.to( workout.roundCountDisp, { size=500, duration=1200, onComplete=function() transition.to( workout.roundCountDisp, { size=20, duration=1000, x=workout.roundDisp.x+workout.roundDisp.contentWidth, y=workout.roundDisp.y, onComplete=function() display.remove( workout.roundCountDisp ); workout.roundDisp.text=workout.roundDisp.preLabel .. workout.roundCount .. workout.roundDisp.postLabel end } ) end } )
	end

	function workout:start()
		if settings.audio then audio.play( M.audio.go ) end
		workout.startedAt = osDate( "%Y-%m-%d %H:%M" )
		self.isVisible = true
		self.clock:start()
		self.segClock:start()
		self.status = 'running'
	end

	function workout:finish()
		if settings.audio then audio.play( M.audio.finished ) end
		self.clock:pause()
		self.segClock:pause()
		workout.startedAt = osDate( "%Y-%m-%d %H:%M" )
		table.insert( workout.results, { 
			workout_id		= workout.slug,
			total_rounds	= workout.totalRoundCount,
			total_time		= workout.clock.elapsedTime,
			started_at		= workout.startedAt,
			ended_at		= workout.endedAt,
			summary_title	= workout.summaryTitle,
			workout_type	= workout.data.workout_type,
			cover_img		= workout.data.cover_img 
			})

		print( 'Workout Finished' )

		Composer.setVariable( 'workoutResults', workout.results )
		
		self.status = 'finished'

		-- ToDo... play some kind of animation here?
		-- for now, a slight delay to let the animations finish
		timer.performWithDelay( 1250, function() Composer.gotoScene( 'scenes.workout_summary' ) end )
	end

	function workout:advanceSegment()
		
		-- Can't double-click protect this cause it's called by code
		-- if workout.lastActionTime and ( workout.clock.elapsedTime - workout.lastActionTime < 1000 ) then 
		-- 	--native.showAlert( 'Double Click', "That's too fast", { 'Ok' } )
		-- 	return false
		-- end
		-- workout.lastActionTime = workout.clock.elapsedTime

		print( "advancing Segment" )

		workout.curSegmentIdx = workout.curSegmentIdx + 1
		
		if workout.curSegmentIdx > #workout.data.segments then 
			workout:finish()
		else
			table.insert( workout.results, { 
				segment_id		= workout.curSegment.id,
				segment_type 	= workout.curSegment.segment_type,
				segment_content = workout.curSegment.content,
				round 			= workout.roundCount,
				total_rounds	= workout.totalRoundCount,
				time 			= workout.clock.elapsedTime,
				})

			workout.curSegment = workout.data.segments[workout.curSegmentIdx]

			workout.roundCount = 0

			print( "Current Segment is now: " .. workout.curSegment.content )
		
			if workout.curSegment.segment_type == 'rest' then 
				workout.actionBtn.label.text = 'Resting'
				workout.actionBtn.onRelease = function() end
				workout.roundDisp.isVisible = false

			elseif workout.curSegment.segment_type == 'amrap' or workout.curSegment.segment_type == 'rft' then 
				workout.actionBtn.label.text = 'Count Round'
				workout.actionBtn.onRelease = function() workout:countRound() end
	
				workout.roundDisp.isVisible = true

				if workout.curSegment.segment_type == 'rft' then 
					workout.roundDisp.preLabel = "Round: "
					workout.roundDisp.postLabel = "/" .. workout.curSegment.repeat_count
				elseif workout.curSegment.segment_type == 'amrap' then
					workout.roundDisp.preLabel = "Rounds: "
					workout.roundDisp.postLabel = ""
				end
				workout.roundDisp.text = workout.roundDisp.preLabel .. workout.roundCount .. workout.roundDisp.postLabel
			else 
				workout.actionBtn.label.text = 'Advance'
				workout.actionBtn.onRelease = function() workout:advanceSegment() end
				workout.roundDisp.isVisible = false

			end

			-- load curSegment clock stuff
			local segStart, segEnd = 0, -1
			if workout.curSegment.duration and workout.curSegment.duration > 0 then 
				segStart = workout.curSegment.duration * 1000
				segEnd = 0 
			end
			self.segClock:reset( segStart, segEnd )
			self.segClock:start()
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
				workout.segmentsDisplay[i].isVisible = false
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

			if workout.data.cover_img then 
				local name = workout.data.cover_img:match( "([^/]+)$" )
				display.loadRemoteImage( workout.data.cover_img, 'GET', function(e) workout.bg = e.target;workout.bg.anchorY=0;workout:insert( workout.bg );workout.bgDimmer=display.newRect( workout, centerX, 50, screenWidth, screenHeight );workout.bgDimmer.anchorY=0;workout.bgDimmer.fill={ 0, 0, 0, 0.5 };workout.bgDimmer:toBack(); workout.bg:toBack(); end, name, centerX, 50 )
			else
				workout.bg = display.newRect( workout, centerX, 50, screenWidth, screenHeight )
				workout.bg.fill = { type = 'image', filename = "assets/images/bgs/bg" .. math.random(1,6) .. ".png" }
				workout.bg.anchorY = 0
				workout.bgDimmer = display.newRect( workout, centerX, 50, screenWidth, screenHeight )
				workout.bgDimmer.anchorY = 0
				workout.bgDimmer.fill = { 0, 0, 0, 0.5 }
				workout.bgDimmer:toBack()
				workout.bg:toBack()
			end

			-- primary clock pretty much always runs up
			-- because we're disabling screen-lock, we'll cap all workouts out 
			-- at 2hrs max for now....
			local clockStart, clockEnd = 0, ( 1000*120*60 )

			-- Run primary clock down if we have a one-segment amrap (e.g. cindy)
			if #workout.data.segments == 1 and workout.curSegment.segment_type == 'amrap' then 
				clockStart = workout.curSegment.duration * 1000
				workout.curSegment.duration = nil
				clockEnd = 0 
			end

			workout.clock = Clock:new({
				parent 		= workout,
				y 			= 60,
				fontSize 	= Theme.clockFontSize,
				startAt 	= clockStart,
				endAt 		= clockEnd,
				showHunds 	= true
				})
			workout.clock.anchorY = 0

			workout.sep = display.newLine( workout, 25, workout.clock.y + workout.clock.contentHeight, screenWidth-25, workout.clock.y + workout.clock.contentHeight )
			workout.sep.alpha = 0.0005

			workout.roundDisp = display.newText({
				parent 	= workout,
				text  	= "Round: " .. workout.roundCount,
				x 		= 25,
				y 		= workout.sep.y + 18,
				font 	= 'digital-7-mono.ttf',
				fontSize = 32,
				})
			workout.roundDisp.anchorX = 0
			workout.roundDisp.isVisible = false
			
			if workout.curSegment.segment_type == 'rft' then 
				workout.roundDisp.isVisible = true
				workout.roundDisp.preLabel = "Round: "
				workout.roundDisp.postLabel = "/" .. workout.curSegment.repeat_count
				workout.roundDisp.text = workout.roundDisp.preLabel .. workout.roundCount .. workout.roundDisp.postLabel
			elseif workout.curSegment.segment_type == 'amrap' then
				workout.roundDisp.isVisible = true
				workout.roundDisp.preLabel = "Rounds: "
				workout.roundDisp.postLabel = ""
				workout.roundDisp.text = workout.roundDisp.preLabel .. workout.roundCount
			end

			-- similar to primary clock, but we'll let segment clock run forever
			-- since workout clock will terminate workout, and user may not want
			-- to micro-manage rounds
			local segStart, segEnd = 0, -1
			if workout.curSegment.duration and workout.curSegment.duration > 0 then 
				segStart = workout.curSegment.duration * 1000
				segEnd = 0 
			end
			workout.segClock = Clock:new({
				parent 		= workout,
				y 			= workout.sep.y + 18,
				fontSize 	= 32,
				startAt 	= segStart,
				endAt 		= segEnd,
				fontFill 	= { 1 },
				showHunds 	= true
				})
			workout.segClock.x = screenWidth - 25
			workout.segClock.anchorX = 1

			-- single-segment for time (e.g. Fran) doesn't need a segment clock
			if #workout.data.segments == 1 and workout.curSegment.segment_type == 'ft' then 
				workout.segClock.isVisible = false 
			end

			workout.sep = display.newLine( workout, 25, workout.segClock.y + 18, screenWidth-25, workout.segClock.y + 18 )
			workout.sep.alpha = 0.5

			workout.overview = display.newText({
				parent 	= workout,
				text 	= workout.data.overview_title,
				width 	= screenWidth-20,
				x 		= centerX,
				y 		= workout.sep.y + 11,
				font 	= 'Lato-Black.ttf',
				fontSize 	= 25,
				align 		= 'center'
				})
			workout.overview.anchorY = 0

			workout.activeSegY =  workout.overview.y + workout.overview.contentHeight + 10
			local curY = workout.activeSegY

			-- show all the segments in te middle

			workout.segmentsDisplay = {}
			
			for i=1, #workout.data.segments do
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
					fontSize = 25
					})

				workout.segmentsDisplay[i].fill = { 1, 1, 1}
				workout.segmentsDisplay[i].anchorY = 0
				
				curY = curY + workout.segmentsDisplay[i].contentHeight + 10

			end

			workout.actionBtn = Btn:new({
				parent 		= workout,
				label 		= 'Action',
				height  	= screenHeight * 0.15,
				x 			= centerX,
				y 			= screenHeight - ( screenHeight * 0.125 ),
				bgColor = { 0, 0.33, 0 },
				})

			-- if workout is one-segment AMRAP and time is up
			-- or if primary clock caps-out
			-- kill the workout
			workout.clock:addEventListener( 'timesUp', function() workout:finish() end )
			
			-- if segment has a duration, advance when segment expires
			workout.segClock:addEventListener( 'timesUp', function() workout:advanceSegment() end )


			if workout.curSegment.segment_type == 'amrap' or workout.curSegment.segment_type == 'rft' then
				workout.actionBtn.label.text = 'Count Round'
				workout.actionBtn.onRelease = function() workout:countRound() end
			else
				workout.actionBtn.label.text = 'Advance'
				workout.actionBtn.onRelease = function() workout:advanceSegment() end
			end

			workout.isVisible = false

			-- now, we can make the count in a setting: 0, 3, 5, 10
			workout.countInCount = 3
			if settings.countIn then
				timer.performWithDelay( 1000, countIn, workout.countInCount + 1 )
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
		-- ToDo: dispose of any audio....
		for i=1, #workout.anims do 
			transition.cancel( workout.anims[i] )
		end
		display.remove( self )
	end

	return workout 
end


return M