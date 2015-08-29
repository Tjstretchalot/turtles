if position then return end
position = {}

-- These go clockwise
position.NEGATIVE_Z = 1 -- North
position.NORTH = position.NEGATIVE_Z
position.POSITIVE_X = 2 -- East
position.EAST = position.POSITIVE_X
position.POSITIVE_Z = 3 -- South
position.SOUTH = position.POSITVE_Z
position.NEGATIVE_X = 4 -- West
position.WEST = position.NEGATIVE_X

position.x = 0
position.y = 0
position.z = 0
position.dir = position.NORTH

local POSITION_FILE = 'position.pos'
position.load = function()
	print('Loading position...')
	if not fs.exists(POSITION_FILE) then
		print('Position file not found')
		return
	end
	
	local posFile = fs.open(POSITION_FILE, 'r')
	position.x = tonumber(posFile.readLine())
	position.y = tonumber(posFile.readLine())
	position.z = tonumber(posFile.readLine())
	position.dir = tonumber(posFile.readLine())
	posFile.close()
	print('Loaded position:')
	print('  (' .. position.x .. ', ' .. position.y .. ', ' .. position.z .. ') dir: ' .. position.directionToString(position.dir))
end

position.save = function()
	print('Saving position...')
	local posFile = fs.open(POSITION_FILE, 'w')
	posFile.writeLine(tostring(position.x))
	posFile.writeLine(tostring(position.y))
	posFile.writeLine(tostring(position.z))
	posFile.writeLine(tostring(position.dir))
	print('Done')
end

position.directionToString = function(dir)
	if dir == position.NORTH then return 'NORTH'
	elseif dir == position.EAST then return 'EAST'
	elseif dir == position.SOUTH then return 'SOUTH'
	elseif dir == position.WEST then return 'WEST'
	else return tostring(dir) end
end

position.load()