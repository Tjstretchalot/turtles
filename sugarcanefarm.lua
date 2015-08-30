dofile('pathfinding.lua')
dofile('inventory.lua')
print('How many columns are there? (Including water)')
local colNumTotal = tonumber(io.read())
print('How many rows?')
local rowNumTotal = tonumber(io.read())
local caneChest = {x=0, y=0, z=1}
local function farmSugarColumn(colNum)
	desiredX = colNum
	pathfinding.gotoXZY(desiredX, 0, 0)
	move.face(position.NORTH)
	move.up(2)
	for i = 1, rowNumTotal do
		turtle.dig()
		move.forward()
		turtle.digDown()
	end
end
local function returnSugarCane()
	pathfinding.goto(caneChest.x, caneChest.y, caneChest.z)
	inventory.dumpInventory(nil, nil, turtle.dropDown)
end
while true do
	for i = 1, colNumTotal do
		farmSugarColumn(i)
	end
	returnSugarCane()
end