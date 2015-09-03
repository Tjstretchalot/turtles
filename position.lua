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

position.CLOCKWISE = 1
position.COUNTERCLOCKWISE = -1

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
	posFile.close()
end

position.directionToString = function(dir)
	if dir == position.NORTH then return 'NORTH'
	elseif dir == position.EAST then return 'EAST'
	elseif dir == position.SOUTH then return 'SOUTH'
	elseif dir == position.WEST then return 'WEST'
	else return tostring(dir) end
end

position.forget = function()
	position.x = 0
	position.y = 0
	position.z = 0
	position.dir = position.NORTH
	position.save()
end

--[[
	Returns a table containing the x offset and z offset caused
	by moving in a particular direction
]]
position.getOffsetForDir = function(dir)
	if dir == position.NEGATIVE_Z then
		return {x = 0, z = -1}
	elseif dir == position.POSITIVE_Z then
		return {x = 0, z = 1}
	elseif dir == position.NEGATIVE_X then
		return {x = -1, z = 0}
	elseif dir == position.POSITIVE_X then
		return {x = 1, z = 0}
	end
	print('position.getOffsetForDir unexpected direction \''..tostring(dir)..'\'')
end

position.normalizeDir = function(dir)
	if dir < 1 then 
		return position.normalizeDir(dir + 4)
	elseif dir > 4 then 
		return position.normalizeDir(dir - 4) 
	end
	
	return dir
end

position.description = function()
	return '(' .. position.x .. ', ' .. position.y .. ', ' .. position.z .. ') dir: ' .. position.directionToString(position.dir)
end

--[[
	Gets the direction towards the specified x, z.
	
	Only unique if the block is only 1 movement away.
	Returns nil if its the same spot.
]]
position.dirTowards = function(towardsX, towardsZ)
	if towardsX < position.x then return position.NEGATIVE_X
	elseif towardsX > position.x then return position.POSITIVE_X
	elseif towardsZ < position.z then return position.NEGATIVE_Z
	elseif towardsZ > position.z then return position.POSITIVE_Z end
end

position.load()