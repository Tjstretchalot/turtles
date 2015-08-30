dofile('pathfinding.lua')
dofile('inventory.lua')
local function doColumn(height, colNum)
	print('Function started')
	local desiredZ = colNum - 1
	print('Going to ' .. desiredZ)
	pathfinding.gotoZXY(desiredZ, 0, 0)
	print('Facing North')
	move.face(position.NORTH)
	print('Starting Column')
	for i = 1, height do
		inventory.selectItem('minecraft:stonebrick')
		turtle.place()
		move.up()
	end
	print('Done with column ' .. colNum)
end
print('How long should the wall be?')
local wallLength = tonumber(io.read())
print('How High?')
local wallHeight = tonumber(io.read())
for i = 1, wallLength do
	doColumn(wallHeight, i)
end
pathfinding.goto(0, 0, 0)
move.face(position.NORTH)