
local Btn = require( 'ui.btn' )
local Theme = require( 'ui.theme' )

local M = {}

M.defaults = {
	x 				= display.contentCenterX,
	y 				= display.contentHeight,
	width 			= 220,
	height 			= 310,
	cornerRadius 	= 8,
	digits 			= 2,
	onComplete = function() print( 'Keypad is done' ) end
}


function M:new( opts )
	if opts == nil then opts = M.defaults end
	
	-- fill in any missing opts from module defaults
	for key, value in pairs( M.defaults ) do
		if opts[key] == nil then 
			opts[key] = M.defaults[key]
		end
	end


	local keypad = display.newGroup()
	if opts.group then
		opts.parent = opts.group
	end
	if opts.parent then 
		opts.parent:insert( keypad )
	end
	

	if opts.onComplete and type( opts.onComplete ) == "function" then
		keypad.onComplete = opts.onComplete
	else 
		keypad.onComplete = M.defaults.onComplete
	end

	if opts.bindTo then 
		keypad.bindTo = opts.bindTo 
	end

	keypad.digits = opts.digits

	keypad.state = 'initialized'
	keypad.value = '0'



	keypad.bg = display.newRoundedRect( keypad, opts.x, opts.y, opts.width, opts.height, opts.cornerRadius )
	keypad.bg.fill = Theme.colors.dkGrey
	keypad.bg.anchorY = 0
	keypad.bg:setStrokeColor( 0.5, 0.5, 0.5 )
	keypad.bg.stroke = {type="image", filename="assets/images/brushes/brush1x2.png"}
	keypad.bg.strokeWidth = 1

	keypad.toggler = display.newRect( keypad, opts.x, opts.y+20, opts.width, 40 )
	keypad.toggler.fill = { 0, 0.01 }
	keypad.toggler:addEventListener( 'tap', function(e) keypad:show() end )


	keypad.display = display.newText({
		parent 	= keypad,
		text 	= '0',
		x 		= display.contentCenterX,
		y 		= opts.y + 20,
		font 	= Theme.font,
		fontSize 	= 32
		})


	local startX = opts.x - opts.width * 0.33
	local x = startX
	local y = opts.y + 70
	keypad.btns = {}

	for i=1, 9 do
		keypad.btns[i] = Btn:new({ 
			parent 			= keypad,
			label 			= i, 
			x 				= x, 
			y 				= y,  
			width 			= 40, 
			height 			= 40, 
			cornerRadius 	= 20,
			font 			= Theme.fonts.hairline,
			strokeWidth 	= 1,
			strokeColor 	= Theme.colors.whiteGrey,
			bgColor 		= { 1, 0.1 },
			bgColorPressed 	= { 1, 0.5 },
			onRelease 		= function() 
								keypad:update( i ) 
							end 
		})

		x = x + ( opts.width * 0.33 )
		if i % 3 == 0 then
			y = y + 60
			x = startX
		end
	end

	keypad.btns['x'] = Btn:new({ parent=keypad, label='undo', x = x, y = y, strokeWidth=1, strokeColor=Theme.colors.whiteGrey, bgColor={ 1, 0.1 }, bgColorPressed={ 1, 0.5 }, width=40, height=40, font = Theme.fonts.hairline, fontSize=12, onRelease=function() keypad:undo() end } )

	x = x + ( opts.width * 0.33 )
	keypad.btns['0'] = Btn:new({ parent=keypad, label = '0', x = x, y = y, cornerRadius=20, strokeWidth=1, strokeColor= Theme.colors.whiteGrey, bgColor={ 1, 0.1 }, bgColorPressed={ 1, 0.5 }, width=40, height=40, font = Theme.fonts.hairline, fontSize=12, onRelease=function() keypad:update( '0' ) end } )

	x = x + ( opts.width * 0.33 )
	keypad.btns['go'] = Btn:new({ parent=keypad, label = 'done', x = x, y = y, strokeWidth=1, strokeColor = Theme.colors.whiteGrey, bgColor={ 1, 0.1 }, bgColorPressed = { 1, 0.5 }, width=40, height=40, font = Theme.fonts.hairline, fontSize=12, onRelease=function() keypad:go() end })

	function keypad:go()
		self.onComplete()
		self:hide()
	end

	function keypad:hide()
		transition.to( self, { y=opts.y, time=1000 })
		self.value = 0
		self.display.text = self.value
		self.state = 'locked'
	end

	function keypad:show()
		transition.to( self, { y = -self.bg.contentHeight+33, time=1000, transition=easing.outElastic })
		self.value = '0'
		self.state = 'initialized'
	end

	function keypad:undo()
		self.value = string.gsub( self.value, ".$", '' )
		self.display.text = self.value
	end

	function keypad:update( str )
		str = tostring( str )
		if self.state == 'initialized' then
			self.value = ''
			self.state = 'editing'
		end
		local tmp_str = self.value .. str
		if string.len( tmp_str ) > self.digits then
			tmp_str = string.sub( tmp_str, -self.digits )
		end
		self.value = tmp_str
		self.display.text = self.value
		if self.bindTo then 
			self.bindTo.text = self.value
		end
		self:dispatchEvent( { name = 'keyPress', target = self } )
	end

	return keypad

end


return M

