dofile('pathfinding.lua')
dofile('inventory.lua')
local desiredCount = 16 --The number of saplings the turtle maintains
local logChestLoc = {-1, 0, 1}
local saplingChestLoc = {-3, 0, 1}
local rowCount = 4
local colCount = 3
local function isTree()
	local success, data = turtle.inspect()
	if success then
		if data.name == 'minecraft:log' then return true end
	end
	return false
end
local function cutTree()
	if not isTree() then return end
	turtle.dig()
	move.forward()
	local curY = position.y
	while turtle.detectUp() do
		turtle.digUp()
		move.up()
	end
	pathfinding.gotoY(curY)
	move.back()
end
local function gotoTree(i, k)
	local desiredX = i * 4 - 4
	local desiredZ = -k * 4
	pathfinding.gotoXZY(desiredX + 1, position.y, desiredZ + 1)
	pathfinding.gotoXZY(desiredX, position.y, desiredZ + 1)
	move.face(position.NORTH)
end
local function returnLogs()
	pathfinding.goto(logChestLoc[1], logChestLoc[2], logChestLoc[3])
	inventory.dumpInventory('minecraft:log', nil, turtle.dropDown)
end
local function plantSapling()
	inventory.selectItem('minecraft:sapling', nil)
	turtle.place()
end
local function getSaplings()
	pathfinding.goto(saplingChestLoc[1], saplingChestLoc[2], saplingChestLoc[3])
	inventory.acquireItem('minecraft:sapling', 2, desiredCount, turtle.suckDown, turtle.dropDown)
end

while true do
	for i = 1, rowCount do
		for j = 1, colCount do
			gotoTree(i, j)
			cutTree()
			plantSapling()
		end
	end
	returnLogs()
	getSaplings()
	pathfinding.goto(0, 0, 0)
	move.face(position.NORTH)
	os.sleep(30)
end

