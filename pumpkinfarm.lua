dofile('pathfinding.lua')
dofile('inventory.lua')
print('How many columns are there? (Including water)')
local colNumTotal = tonumber(io.read())
print('How many rows?')
local rowNumTotal = tonumber(io.read())
local pumpkinChest = {x=0, y=0, z=1}
local function farmSugarColumn(colNum)
	desiredX = colNum
	pathfinding.gotoXZY(desiredX, 0, 0)
	move.face(position.NORTH)
	move.up(1)
	for i = 1, rowNumTotal do
		move.forward()
		local success, blockName = turtle.inspectDown()
		if success then
			if blockName == 'minecraft:pumpkin' then
			turtle.digDown()
			elseif blockName == 'minecraft:melon' then
			turtle.digDown()
			end
		end
	end
end
local function returnSugarCane()
	pathfinding.goto(pumpkinChest.x, pumpkinChest.y, pumpkinChest.z)
	inventory.dumpInventory(nil, nil, turtle.dropDown)
end
while true do
	for i = 1, colNumTotal do
		farmSugarColumn(i)
	end
	returnSugarCane()
end