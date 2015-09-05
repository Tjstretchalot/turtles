if common then return end
dofile('position.lua')

common = {}

if not string.split then 
	-- https://github.com/StuartIanRoss/ComputerCraft/blob/master/packages/lib/String.lua
	string.split = function(str, delim, maxNb)
		delim = delim or ' '
		-- Eliminate bad cases...
		if string.find(str, delim) == nil then
			return { str }
		end
		
		if maxNb == nil or maxNb < 1 then
			maxNb = 0 -- No limit
		end
		
		local result = {}
		local pat = "(.-)" .. delim .. "()"
		local nb = 0
		local lastPos
		for part, pos in string.gmatch(str, pat) do
			nb = nb + 1
			result[nb] = part
			lastPos = pos
			if nb == maxNb then break end
		end
		
		-- Handle the last field
		if nb ~= maxNb then
			result[nb + 1] = string.sub(str, lastPos)
		end
		
		return result
		
	end
end

common.splitCommandAndArgsFromString = function(str)
	local exploded = string.split(str)
	
	local args = {}
	
	for i=2, #exploded do
		args[i-1] = exploded[i]
	end
	
	return exploded[1], args
end

common.serializeToFile = function(fileName, tab) 
	local f = fs.open(fileName, 'w')
	f.write(textutils.serialize(tab))
	f.close()
end

common.unserializeFromFile = function(fileName, defaults)
	local result = {}
	if not fs.exists(fileName) then
		for key, value in pairs(defaults) do
			result[key] = value
		end
		return result
	end
	
	local f = fs.open(fileName, 'r')
	local saved = textutils.unserialize(f.readAll())
	f.close()
	
	for key, value in pairs(defaults) do
		result[key] = value
	end
	for key, value in pairs(saved) do
		result[key] = value
	end
	return result
end


io.readStr = function(default)
	local choice = io.read()
	if string.len(choice) > 0 then
		return choice
	end
	return default
end

io.readNum = function(default)
	return tonumber(io.readStr(default))
end

--[[
	This can be used as a method of acquiring the <index> block from a square room
	with the startPos being on the bottom - left of the square, depth going in the 
	direction of the startPos.dir, and the width going in the direction clockwise
	of startPos.dir
	
	This increments in a manner that is useful for positioning turtles - i.e. the next block will
	be 1 block away from the turtle.
	
	Starts going width, then 1 depth and returning in the opposite direction. E.g.
	
	|--|--|--|
	|->|->|EN|
	|--|--|--|
	|^^|<-|<-|
	|--|--|--|
	|ST|->|^^|
	|--|--|--|
	
	startPos - Starting position info. Ex: {x = 0, y = 0, z = 0, dir = position.NORTH}
	width - the width of the square room.
	index - Starts at 1, increment to get next position
	
	returns - x,z tupple. e.g. {x = 0, z = 0}
]]
common.getNextXZInSquareRoom = function(startPos, width, index)
	-- Break down index to get the row
	
	local row = math.floor((index - 1) / width)
	local colOffset = (index - 1) % width 
	
	local distanceDepth = row
	local distanceBreadth = -1
	if row % 2 == 0 then
		-- Started on left heading right.
		distanceBreadth = colOffset
	else
		-- Started on right heading left.
		distanceBreadth = width - colOffset - 1 
	end
	
	local depthOffset = position.getOffsetForDir(startPos.dir)
	local breadthOffset = position.getOffsetForDir(position.normalizeDir(startPos.dir + position.CLOCKWISE))
	
	return {x = startPos.x + breadthOffset.x * distanceBreadth + depthOffset.x * distanceDepth, z = startPos.z + breadthOffset.z * distanceBreadth + depthOffset.z * distanceDepth}
end
