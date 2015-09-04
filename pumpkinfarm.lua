dofile('pathfinding.lua')
dofile('inventory.lua')
print('How many columns are there? (Including water and roots)')
local colNumTotal = tonumber(io.read())
print('How many rows?')
local rowNumTotal = tonumber(io.read())
local pumpkinChest = {x = -1, y = 0, z = 1}
local melonChest = {x = 1, y = 0, z = 1}

local startPos = {x=0, y=0, z=0, dir=position.NORTH}
local function farmPumpkinColumn(index)
	for i = 1, rowNumTotal do
		local xz = common.getNextXZInSquareRoom(startPos, rowNumTotal, colNumTotal)
		pathfinding.gotoYXZ(xz.x, startPos.y + 1, xz.z)
		local success, data = turtle.inspectDown()
		if success then
			if data.name == 'minecraft:pumpkin' then
			turtle.digDown()
			elseif data.name == 'minecraft:melon_block' then
			turtle.digDown()
			end
		end
	end
end
local function emptyInventory()
	pathfinding.goto(pumpkinChest.x, pumpkinChest.y, pumpkinChest.z)
	inventory.dumpInventory('minecraft:pumpkin', nil, turtle.dropDown)
	pathfinding.goto(melonChest.x, melonChest.y, melonChest.z)
	inventory.dumpInventory('minecraft:melon', nil, turtle.dropDown)
end
while true do
	for i = 1, colNumTotal do
		farmPumpkinColumn(i)
	end
	emptyInventory()
end