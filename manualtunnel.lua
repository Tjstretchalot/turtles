dofile('tunnel.lua')
dofile('common.lua')

if position.x ~= 0 or position.y ~= 0 or position.z ~= 0 or position.dir ~= position.NORTH then
	print('Reset old position information? (1)')
	print('  0 - No, pretend I did not notice that (WARNING: unpredictable)')
	print('  1 - Yes, delete old position information')
	print('  2 - No, but take me back to 0, 0, 0 and face north.')
	local choice = io.readNum(1)
	
	if choice == 1 then
		position.forget()
	elseif choice == 2 then
		pathfinding.goto(0, 0, 0)
		move.face(position.NORTH)
	elseif choice ~= 0 then
		return
	end
end

local config = {
	width = 3,
	height = 3,
	length = 5,
	comeback = 1,
	placeFloor = 1,
	floorType = 'minecraft:cobblestone',
	detectCeiling = 0,
	detectOre = 1,
	dumpInventoryInChestWhenFull = 0
}

config = common.unserializeFromFile('manualtunnel.dat', config)

print('How wide? ('..config.width..')')
config.width = io.readNum(config.width)
print('How tall? ('..config.height..')')
config.height = io.readNum(config.height)
print('How long? ('..config.length..')')
config.length = io.readNum(config.length)
print('Come back afterward? ('..tostring(config.comeback)..')')
print('  0 - No, just shut down after I am done')
print('  1 - Yes, return to 0, 0, 0 and face north after I am done')
config.comeback = io.readNum(config.comeback)
print('If inventory fills, what should we do? ('..tostring(config.dumpInventoryInChestWhenFull)..')')
print('  0 - Hang until you empty it')
print('  1 - Dump it behind my current position')
config.dumpInventoryInChestWhenFull = io.readNum(config.dumpInventoryInChestWhenFull)
print('Place floor? ('..tostring(config.placeFloor)..')')
config.placeFloor = io.readNum(config.placeFloor)
print('Floor type? ('..config.floorType..')')
config.floorType = io.readStr(config.floorType)
print('Detect ceiling? ('..config.detectCeiling..')')
print('  0 - No, use the height from earlier')
print('  1 - Yes, keep going up until theres empty space')
config.detectCeiling = io.readNum(config.detectCeiling)
print('Detect ore? ('..config.detectOre..')')
print('  0 - No, do not inspect what we are mining. MUCH faster')
print('  1 - Attempt to detect and mine ore while tunneling. WARNING: May break detect ceiling')
config.detectOre = io.readNum(config.detectOre)

common.serializeToFile('manualtunnel.dat', config)

-- Truthiness in lua is bad
if config.comeback == 0 then config.comeback = false end
if config.placeFloor == 0 then config.placeFloor = false end
if config.detectCeiling == 0 then config.detectCeiling = false end
if config.detectOre == 0 then config.detectOre = false end
if config.dumpInventoryInChestWhenFull == 0 then config.dumpInventoryInChestWhenFull = false end

local startPosition = {x = position.x, y = position.y, z = position.z, dir = position.dir}

tunnel.config.floorType = config.floorType
tunnel.config.detectCeiling = config.detectCeiling
tunnel.config.scanForOre = config.detectOre

if config.dumpInventoryInChestWhenFull then
	tunnel.onInventoryFull = function()
		local curPos = {x = position.x, y = position.y, z = position.z, dir = position.dir}
		pathfinding.goto(startPosition.x, startPosition.y, startPosition.z)
		local chestDir = position.normalizeDir(startPosition.dir + 2)
		move.face(chestDir)
		inventory.dumpInventory()
		pathfinding.goto(curPos.x, curPos.y, curPos.z)
		move.face(curPos.dir)
	end
end

tunnel.doTunnel(config.width, config.height, config.length, config.placeFloor)

if config.comeback then
	pathfinding.goto(startPosition.x, startPosition.y, startPosition.z)
	move.face(startPosition.dir)
end
