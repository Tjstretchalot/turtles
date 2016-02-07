dofile('inventory.lua')
dofile('pathfinding.lua')
local logChestLoc = {-1, 0, 1} --left 1, back 1
local saplingChestLoc = {-3, 0, 1} --left 3, back 1
if position.x ~= 0 or position.y ~= 0 or position.z ~= 0 or position.dir ~= position.NORTH then
	print('Disclaimer - this is not mine')
	print('Reset old position information?')
	print('  0 - No, pretend I did not notice that (WARNING: unpredictable)')
	print('  1 - Yes, delete old position information')
	print('  2 - No, but take me back to 0, 0, 0 and face north.')
	local choice = tonumber(io.read())
	
	if choice == 1 then
		position.forget()
	elseif choice == 2 then
		pathfinding.goto(0, 0, 0)
		move.face(position.NORTH)
	elseif choice ~= 0 then
		return
	end
end
local function readStr(default)
	local choice = io.read()
	if string.len(choice) > 0 then
		return choice
	end
	return default
end

local function readNum(default)
	return tonumber(readStr(default))
end
local config = {
rowCount = 3,
colCount = 3,
gapBetweenTrees = 3,
desiredSaplingCount = 16,
logName = 'minecraft:log',
saplingName = 'minecraft:sapling'
}

if fs.exists('manualtreefarm.dat') then
	local f = fs.open('manualtreefarm.dat', 'r')
	config = textutils.unserialize(f.readAll())
	f.close()
end
print('How many rows of trees?('..config.rowCount..')')
config.rowCount = readNum(config.rowCount)
print('How many columns?('..config.colCount..')')
config.colCount = readNum(config.colCount)
print('How many blocks between trees? ('..config.gapBetweenTrees..')')
config.gapBetweenTrees = readNum(config.gapBetweenTrees)
print('How many saplings should be maintained? ('..config.desiredSaplingCount..')')
config.desiredSaplingCount = readNum(config.desiredSaplingCount)
print('What type of log should be farmed? Use IDs, like minecraft:log ('..tostring(config.logName)..')')
config.logName = readStr(config.logName)
print('What is the ID of the sapling? Again, use IDs ('..tostring(config.saplingName)..')')
config.saplingName = readStr(config.saplingName)

local f = fs.open('manualtreefarm.dat', 'w')
f.write(textutils.serialize(config))
f.close()


local function isTree()
	local success, data = turtle.inspect()
	if success then
		if data.name == config.logName then return true end
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
local function gotoTree(i, k, gapBetweenTrees) --Assumes the turtle is in the bottom left corner
	local desiredX = i * (gapBetweenTrees + 1) - (gapBetweenTrees + 1)
	local desiredZ = -k * (gapBetweenTrees + 1)
	pathfinding.gotoXZY(desiredX + 1, position.y, desiredZ + 1)
	pathfinding.gotoXZY(desiredX, position.y, desiredZ + 1)
	move.face(position.NORTH)
end
local function returnLogs()
	pathfinding.goto(logChestLoc[1], logChestLoc[2], logChestLoc[3])
	inventory.dumpInventory(config.logName, nil, turtle.dropDown)
end
local function plantSapling()
	inventory.selectItem(config.saplingName, nil)
	turtle.place()
end
local function getSaplings(desiredCount)
	pathfinding.goto(saplingChestLoc[1], saplingChestLoc[2], saplingChestLoc[3])
	inventory.acquireItem(config.saplingName, nil, desiredCount, turtle.suckDown, turtle.dropDown)
end
local f = fs.open('startup', 'w')
f.write("dofile('treefarm.lua')")
f.close()
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