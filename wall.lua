dofile('pathfinding.lua')
dofile('inventory.lua')

local finalHeight = 9

local function doColumn(height, colNum)
	colNum = colNum or 1
	local desiredZ = colNum - 1
	pathfinding.gotoZXY(desiredZ, 0, 0)
	move.face('position.NORTH')
	for i = 1, colNum do
		inventory.selectItem('minecraft:stonebrick')
		turtle.place()
		move.up()
	end
end
doColumn(4, 1)
