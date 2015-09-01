dofile('tunnel.lua')

local function goToColumn(colNum)
	local neededDir = false
	local desiredZ = 0
	if colNum%2 == 1 then
		neededDir = position.NORTH
		desiredZ = 0
	else
		neededDir = position.SOUTH
		desiredZ = -12
	end
	local desiredX = 4 * (colNum - 1)
	print('Going to ' ..desiredX .. ', ' ..desiredZ)
	pathfinding.gotoXZY(desiredX, 0, desiredZ)
	move.face(neededDir)
end
local function goToRow(rowNum)
	if rowNum % 2 == 1 then
		desiredDir = position.WEST
		desiredX = 12
	else
		desiredDir = position.EAST
		desiredX = 0
	end
	desiredZ = 4 * (rowNum - 1)
	pathfinding.gotoZXY(desiredZ, desiredX, 0)
	move.face(desiredDir)
end
local function doColumns(colNumTotal, height, length)
	for i = 1, colNumTotal do
		goToColumn(i)
		tunnel.doTunnel(1, height, length)
	end
end
local function doRows(rowNumTotal, height, length)
	for i = 1, rowNumTotal do
		gotoRow(i)
		tunnel.doTunnel(1, height, length)
	end
end
doColumns(2, 3, 9)
pathfinding.goto(0, 0, 0)