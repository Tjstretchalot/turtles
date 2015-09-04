if wall then return end
wall = {}

dofile('inventory.lua')
dofile('pathfinding.lua')
dofile('common.lua')

local function isGapInColumn(colNum, gapSize, distGap)
	if not distGap then return false end
	if not gapSize then return false end
	if colNum <= distGap then return false end
	if colNum > distGap + gapSize then return false end
	return true
end
local function doColumn(height, colNum, distGap, gapHeight, gapSize)
	local startPos = {x = position.x, y = position.y, z = position.z}
	local desiredX = colNum - 1
	pathfinding.gotoZXY(desiredX + position.x, position.y, position.z)
	move.face(position.NORTH)
	if isGapInColumn(colNum, distGap, gapSize) then
		for i = 1, gapHeight do
			move.up()
		end
		for i = 1, height - gapHeight do
			inventory.selectItem('minecraft:stonebrick')
			turtle.place()
			move.up()
		end
	else
		for i = 1, height do
			inventory.selectItem('minecraft:stonebrick')
			turtle.place()
			move.up()
		end
	end
	pathfinding.gotoXZY(startPos.x, startPos.y, startPos.z)
end

wall.doWall = function(height, length, gapSize, distToGap, gapHeight)
	for i = 1, length do
		doColumn(height, i, distToGap, gapHeight, gapSize)
	end
end