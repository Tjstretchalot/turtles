--[[
	Scans the floor for ores
]]

dofile('tunnel.lua')
dofile('common.lua')
dofile('ore.lua')

local config = {
	width = 32,
	length = 32,
	avoidTorches = 1,
	placeFloor = 1,
	floorType = 'minecraft:cobblestone',
	ensureFloorType = 0,
	comeback = 1
}

config = common.unserializeFromFile('floor_scanner.dat', config)

print('Width: ('..config.width..')')
config.width = io.readNum(config.width)
print('Length: ('..config.length..')')
config.length = io.readNum(config.length)
print('Avoid torches? ('..config.avoidTorches..')')
config.avoidTorches = io.readNum(config.avoidTorches)
print('Place floor? ('..config.placeFloor..')')
config.placeFloor = io.readNum(config.placeFloor)
print('Floor type? ('..config.floorType..')')
config.floorType = io.readStr(config.floorType)
print('Ensure floor type? ('..config.ensureFloorType..')')
config.ensureFloorType = io.readNum(config.ensureFloorType)
print('Come home after? ('..config.comeback..')')
config.comeback = io.readNum(config.comeback)

common.serializeToFile('floor_scanner.dat', config)

if config.avoidTorches == 0 then config.avoidTorches = false end
if config.placeFloor == 0 then config.placeFloor = false end
if config.comeback == 0 then config.comeback = false end
if config.ensureFloorType == 0 then config.ensureFloorType = false end

local startPos = {x = position.x, y = position.y, z = position.z, dir = position.dir}

local avoidedLast = false
local function handleNextSpot(i)
	local xz = common.getNextXZInSquareRoom(startPos, config.width, i)
	if position.x == xz.x and position.z == xz.z then
		return
	end
	
	local isTorchAndShouldAvoid = false
	if config.avoidTorches and not avoidedLast then
		move.face(position.dirTowards(xz.x, xz.z))
		local succ, data = turtle.inspect()
		if succ then
			isTorchAndShouldAvoid = data.name == 'minecraft:torch'
		end
	end
	
	if isTorchAndShouldAvoid then
		pathfinding.gotoYXZ(xz.x, startPos.y + 1, xz.z)
	else
		pathfinding.gotoXZY(xz.x, startPos.y, xz.z)
		ore.digOutOre(turtle.inspectDown, turtle.digDown, move.down)
		
		if config.ensureFloorType then
			local succ, data = turtle.inspectDown()
			
			if succ then
				if data.name ~= config.floorType then
					turtle.digDown()
				end
			end
		end
		
		if config.placeFloor then
			inventory.selectItem(config.floorType)
			turtle.placeDown()
		end
	end
	avoidedLast = isTorchAndShouldAvoid
end

for i = 1, (config.width * config.length) do
	handleNextSpot(i)
end

if config.comeback then
	pathfinding.gotoXZY(startPos.x, startPos.y, startPos.z)
	move.face(startPos.dir)
end