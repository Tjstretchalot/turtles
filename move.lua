if move then return end 

dofile('position.lua')
move = {}

local function myMove(times, moveFn, updatePosFn)
	local digFn = 0
	if moveFn == turtle.up then digFn = turtle.digUp
	elseif moveFn == turtle.forward then digFn = turtle.dig end
	
	times = times or 1
	
	for i=1, times do
		while not moveFn() do 
			if digFn then digFn() end
		end
		updatePosFn()
		position.save()
	end
end
move.up = function(times) 
	myMove(times, turtle.up, function()
		position.y = position.y + 1
	end)
end

move.down = function(times)
	myMove(times, turtle.down, function()
		position.y = position.y - 1
	end)
end

move.forward = function(times)
	myMove(times, turtle.forward, function()
		if position.dir == position.POSITIVE_X then position.x = position.x + 1
		elseif position.dir == position.POSITIVE_Z then position.z = position.z + 1
		elseif position.dir == position.NEGATIVE_X then position.x = position.x - 1
		elseif position.dir == position.NEGATIVE_Z then position.z = position.z - 1 end
	end)
end

move.back = function(times)
	myMove(times, turtle.back, function()
		if position.dir == position.POSITIVE_X then position.x = position.x - 1
		elseif position.dir == position.POSITIVE_Z then position.z = position.z - 1
		elseif position.dir == position.NEGATIVE_X then position.x = position.x + 1
		elseif position.dir == position.NEGATIVE_Z then position.z = position.z + 1 end
	end)
end

move.turnLeft = function(times) 
	myMove(times, turtle.turnLeft, function()
		position.dir = position.dir - 1
		if position.dir < 1 then position.dir = 4 end
	end)
end

move.turnRight = function(times)
	myMove(times, turtle.turnRight, function()
		position.dir = position.dir + 1
		if position.dir > 4 then position.dir = 1 end
	end)
end

move.west = function(times)
	move.face(position.WEST)
	move.forward(times)
end

move.east = function(times)
	move.face(position.EAST)
	move.forward(times)
end

move.north = function(times)
	move.face(position.NORTH)
	move.forward(times)
end

move.south = function(times)
	move.face(position.SOUTH)
	move.forward(times)
end

move.face = function(dir)
	if position.dir == dir then return end
	
	local turnsIfCounterClockwise = 0
	local simDir = position.dir
	while simDir ~= dir do
		simDir = simDir - 1
		if simDir < 1 then simDir = 4 end
		turnsIfCounterClockwise = turnsIfCounterClockwise + 1
	end
	
	local turnsIfClockwise = 0
	simDir = position.dir
	while simDir ~= dir do
		simDir = simDir + 1
		if simDir > 4 then simDir = 1 end
		turnsIfClockwise = turnsIfClockwise + 1
	end
	local turnFn = 1
	if turnsIfClockwise < turnsIfCounterClockwise then
		turnFn = move.turnRight
	else
		turnFn = move.turnLeft
	end
	
	while position.dir ~= dir do
		turnFn()
	end
end