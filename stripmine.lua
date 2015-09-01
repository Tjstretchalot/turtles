dofile('tunnel.lua')

local function goToColumn(colNum, rowNumTotal)
	local neededDir = false
	local desiredZ = 0
	if colNum%2 == 1 then
		neededDir = position.NORTH
		desiredZ = 0
	else
		neededDir = position.SOUTH
		desiredZ = -4 * (rowNumTotal - 1)
	end
	local desiredX = 4 * (colNum - 1)
	pathfinding.gotoXZY(desiredX, 0, desiredZ)
	move.face(neededDir)
end
local function goToRow(rowNum, colNumTotal)
	if rowNum % 2 == 1 then
		desiredDir = position.WEST
		desiredX = 4 * (colNumTotal - 1)
	else
		desiredDir = position.EAST
		desiredX = 0
	end
	desiredZ = -4 * (rowNum)
	pathfinding.gotoZXY(desiredX, 0, desiredZ)
	move.face(desiredDir)
end
local function doColumns(colNumTotal, rowNumTotal, height)
	for i = 1, colNumTotal do
		goToColumn(i, rowNumTotal)
		tunnel.doTunnel(1, height, 4 * (rowNumTotal - 1))
	end
end
local function doRows(rowNumTotal, colNumTotal, height)
	for i = 1, rowNumTotal do
		goToRow(i, colNumTotal)
		tunnel.doTunnel(1, height, 4 * (colNumTotal - 1))
	end
end
print('How many rows of pillars?')
local totalRowNumber = tonumber(io.read())
print('How many columns of pillars?')
local totalColNumber = tonumber(io.read())
print('Doing a '..totalRowNumber * 4 ..' by '..totalColNumber * 4 ..' room')
doColumns(totalColNumber + 1, totalRowNumber, 3)
doRows(totalRowNumber, totalColNumber + 1, 3)
pathfinding.goto(0, 0, 0)
move.face(position.NORTH)