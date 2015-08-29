if position then return end
position = {}

-- These go clockwise
position.NEGATIVE_Z = 1 -- North
position.NORTH = position.NEGATIVE_Z
position.POSITIVE_X = 2 -- East
position.EAST = position.POSITIVE_X
position.POSITIVE_Z = 3 -- South
position.SOUTH = position.POSITIVE_Z
position.NEGATIVE_X = 4 -- West
position.WEST = position.NEGATIVE_X

position.x = 0
position.y = 0
position.z = 0
position.dir = position.NORTH

local POSITION_FILE = 'position.pos'
position.load = function()
	if not fs.exists(POSITION_FILE) then
		return
	end
	
	local posFile = fs.open(POSITION_FILE, 'r')
	position.x = tonumber(posFile.readLine())
	position.y = tonumber(posFile.readLine())
	position.z = tonumber(posFile.readLine())
	position.dir = tonumber(posFile.readLine())
	posFile.close()
end

position.save = function()
	local posFile = fs.open(POSITION_FILE, 'w')
	posFile.writeLine(tostring(position.x))
	posFile.writeLine(tostring(position.y))
	posFile.writeLine(tostring(position.z))
	posFile.writeLine(tostring(position.dir))
end

position.directionToString = function(dir)
	if dir == position.NORTH then return 'NORTH'
	elseif dir == position.EAST then return 'EAST'
	elseif dir == position.SOUTH then return 'SOUTH'
	elseif dir == position.WEST then return 'WEST'
	else return tostring(dir) end
end

position.description = function()
	return '(' .. position.x .. ', ' .. position.y .. ', ' .. position.z .. ') dir: ' .. position.directionToString(position.dir)
end

position.load()