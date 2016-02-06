dofile('pathfinding.lua')
dofile('inventory.lua')
local config = {
rowCount = 3,
colCount = 3,
gapBetweenTrees = 3,
desiredSaplingCount = 16,
logName == 'minecraft:log'
saplingName == 'minecraft:sapling'
}
local logChestLoc = {-1, 0, 1}
local saplingChestLoc = {-3, 0, 1}

if fs.exists('manualtreefarm.dat') then
	local f = fs.open('manualtreefarm.dat', 'r')
	config = textutils.unserialize(f.readAll())
	f.close()
end
local function isTree()
	local success, data = turtle.inspect()
	if success then
		if data.name == logName then return true end
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
local function gotoTree(i, k, gapBetweenTrees)
	local desiredX = i * (gapBetweenTrees + 1) - (gapBetweenTrees + 1)
	local desiredZ = -k * (gapBetweenTrees + 1)
	pathfinding.gotoXZY(desiredX + 1, position.y, desiredZ + 1)
	pathfinding.gotoXZY(desiredX, position.y, desiredZ + 1)
	move.face(position.NORTH)
end
local function returnLogs()
	pathfinding.goto(logChestLoc[1], logChestLoc[2], logChestLoc[3])
	inventory.dumpInventory(logName, nil, turtle.dropDown)
end
local function plantSapling()
	inventory.selectItem(saplingName, nil)
	turtle.place()
end
local function getSaplings(desiredCount)
	pathfinding.goto(saplingChestLoc[1], saplingChestLoc[2], saplingChestLoc[3])
	inventory.acquireItem(saplingName, 2, desiredCount, turtle.suckDown, turtle.dropDown)
end

while true do
	for i = 1, config.rowCount do
		for j = 1, config.colCount do
			gotoTree(i, j, config.gapBetweenTrees)
			cutTree()
			plantSapling()
		end
	end
	returnLogs()
	getSaplings(config.desiredSaplingCount)
	pathfinding.goto(0, 0, 0)
	move.face(position.NORTH)
	os.sleep(30)
end
