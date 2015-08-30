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


print('What should I do at the end?')
print('0 - Stay at the top of the last column')
print('1 - Go to the bottom of the last column')
print('2 - Go back to the start')
local endAction = tonumber(io.read())

local function gotoEndLoc(input, finalZ)
	if input == 0 then
		return
	elseif input == 1 then
		pathfinding.gotoZXY(finalZ, 0, 0)
	else
		pathfinding.goto(0, 0, 0)
		move.face(position.NORTH)
	end
end

for i = 1, wallLength do
	doColumn(wallHeight, i)
end
gotoEndLoc(endAction, wallLength - 1)