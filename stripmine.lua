dofile('tunnel.lua')

local function goToColumn(colNum)
	local neededDir = false
	if colNum%2 == 1 then
		neededDir = position.NORTH
		local desiredZ = 0
	else
		neededDir = position.SOUTH
		desiredZ = 12
	end
	local desiredX = 4 * (colNum - 1)
	pathfinding.gotoXZY(desiredX, desiredZ, 0)
	move.face(desiredDir)
end
local function goToRow(rowNum)
	if rowNum%2 = 1 then
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
	for i = 0, colNumTotal - 1 do
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
doColumns(1, 3, 9)