dofile('pathfinding.lua')
dofile('inventory.lua')
print('How many columns are there? (Including water)')
local colNumTotal = tonumber(io.read())
print('How many rows?')
local rowNumTotal = tonumber(io.read())
local caneChest = {0, 0, 1}
local function farmSugarColumn(colNum)
	desiredX = colNum
	pathfinding.gotoX(desiredX)
	for i = 1, rowNumTotal do
		turtle.dig()
		move.forward()
		turtle.digDown()
	end
end
local function returnSugarCane()
	pathfinding.goto(0, 0, 0)
	move.face(position.SOUTH)
	inventory.dumpInventory()
end
while true do
	for i = 1, colNumTotal do
		farmSugarColumn(i)
	end
	returnSugarCane()
end