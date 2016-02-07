if wall then return end
wall = {}

dofile('inventory.lua')
dofile('pathfinding.lua')
dofile('common.lua')

wall.config = {
	wallType = 'minecraft:stonebrick'
}


--[[
	Determines if a column should be skipped due to a gap
]]
local function isGapInColumn(colNum, gapSize, distGap)
	if not distGap then return false end
	if not gapSize then return false end
	if colNum <= distGap then return false end
	if colNum > distGap + gapSize then return false end
	return true
end

local function placeWallBlock()
	while not inventory.selectItem(wall.config.wallType) do
		print('Not enough ' .. wall.config.wallType .. ' for wall!')
		os.sleep(5)
	end
	
	turtle.place()
end

--[[
	By using the 2d walking method from common as x-y rather than x-z,
	can efficiently place wall blocks by index rather than row and column
	
	startPos - the starting x,y,z e.g. {x=0,y=0,z=0}
	width - how wide (x-direction) the wall is
	height - how tall (y-direction) the wall is
	index - the index of the wall block 
]]
local function getWallBlockLoc(startPos, width, height, index)
	-- We will only use common for acquiring offsets, since we need to do
	-- other conversions anyway.
	
	-- depth is in the positive x (east), so breadth will be positive z (south)
	local floorStartPos = {x=0, y=0, z=0, dir=position.POSITIVE_X}
	
	-- Imagine a rectangle wall, going up. We will be on the bottom-right corner. 
	-- Lay the wall flat, as xz represents. We want to walk height first, so imagine 
	-- the height becomes our width, and we're on the bottom-left corner for
	-- the purposes of common, exactly what we want.
	local floorOffsets = common.getNextXZInSquareRoom(floorStartPos, height, index)
	
	local desiredLoc = {}
	-- Now, floorOffsets.x is the depth for common, and the breadth for us. We want
	-- to have breadth to be eastward, or positive x. Well that's convenient!
	desiredLoc.x = floorOffsets.x + startPos.x
	-- floorOffsets.z is the breadth for common, the height for us. It will be positive,
	-- and we want y to be positive. Also convenient!
	desiredLoc.y = floorOffsets.z + startPos.y
	desiredLoc.z = startPos.z
	
	return desiredLoc
end



wall.doWall = function(height, length, isGap, gapSize, distToGap, gapHeight)
	local startPos = {x=position.x, y=position.y, z=position.z}
	for i = 1, (length*height) do
		local wallBlockLoc = getWallBlockLoc(startPos, length, height, i)
		local column = wallBlockLoc.x - startPos.x
		local heightOffGround = wallBlockLoc.y - startPos.y
		
		if heightOffGround > gapHeight or (not isGap or not isGapInColumn(column, gapSize, distToGap)) then
			pathfinding.goto(wallBlockLoc.x, wallBlockLoc.y, wallBlockLoc.z)
			move.face(position.NORTH)
			placeWallBlock()
		end
	end
end