dofile('pathfinding.lua')
dofile('inventory.lua')
local function doColumn(height, colNum)
	local desiredZ = colNum - 1
	pathfinding.gotoZXY(desiredZ, 0, 0)
	move.face(position.NORTH)
	for i = 1, height do
		inventory.selectItem('minecraft:stonebrick')
		turtle.place()
		move.up()
	end
end
print('How long should the wall be?')
local wallLength = tonumber(io.read())
print('How High?')
local wallHeight = tonumber(io.read())
for i = 1, wallLength do
	doColumn(wallHeight, i)
end