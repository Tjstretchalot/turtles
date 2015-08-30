dofile('tunnel.lua')

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

if position.x ~= 0 or position.y ~= 0 or position.z ~= 0 or position.dir ~= position.NORTH then
	print('Reset old position information? (1)')
	print('  0 - No, pretend I did not notice that (WARNING: unpredictable)')
	print('  1 - Yes, delete old position information')
	print('  2 - No, but take me back to 0, 0, 0 and face north.')
	local choice = readNum(1)
	
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
	detectCeiling = 0
}

if fs.exists('manualtunnel.dat') then
	local f = fs.open('manualtunnel.dat', 'r')
	config = textutils.unserialize(f.readAll())
	f.close()
end

print('How wide? ('..config.width..')')
config.width = readNum(config.width)
print('How tall? ('..config.height..')')
config.height = readNum(config.height)
print('How long? ('..config.length..')')
config.length = readNum(config.length)
print('Come back afterward? ('..tostring(config.comeback)..')')
print('  0 - No, just shut down after I am done')
print('  1 - Yes, return to 0, 0, 0 and face north after I am done')
config.comeback = readNum(config.comeback)
print('Place floor? ('..tostring(config.placeFloor)..')')
config.placeFloor = readNum(config.placeFloor)
print('Floor type? ('..config.floorType..')')
config.floorType = readStr(config.floorType)
print('Detect ceiling? ('..config.detectCeiling..')')
print('  0 - No, use the height from earlier')
print('  1 - Yes, keep going up until theres empty space')
config.detectCeiling = readNum(config.detectCeiling)

local f = fs.open('manualtunnel.dat', 'w')
f.write(textutils.serialize(config))
f.close()

-- Truthiness in lua is bad
if config.comeback == 0 then config.comeback = false end
if config.placeFloor == 0 then config.placeFloor = false end
if config.detectCeiling == 0 then config.detectCeiling = false end

tunnel.config.floorType = config.floorType
tunnel.config.detectCeiling = config.detectCeiling
tunnel.doTunnel(config.width, config.height, config.length, config.placeFloor)

if config.comeback then
	pathfinding.goto(0, 0, 0)
	move.face(position.NORTH)
end