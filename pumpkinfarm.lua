dofile('pathfinding.lua')
dofile('inventory.lua')
dofile('common.lua')

local rowNumTotal = 9
local colNumTotal = 7

local pumpkinChest = {x = -2, y = -1, z = 1}
local melonChest = {x = 2, y = -1, z = 1}

local startPosSquare = {x=-3, y=1, z=-1, dir=position.NORTH}
local function farmPumpkin(index)
	local xz = common.getNextXZInSquareRoom(startPosSquare, colNumTotal, index)
	pathfinding.gotoYXZ(xz.x, startPosSquare.y, xz.z)
	local success, data = turtle.inspectDown()
	if success then
		if data.name == 'minecraft:pumpkin' then
		turtle.digDown()
		elseif data.name == 'minecraft:melon_block' then
		turtle.digDown()
		end
	end
end
local function emptyInventory()
	pathfinding.goto(pumpkinChest.x, pumpkinChest.y + 1, pumpkinChest.z)
	inventory.dumpInventory('minecraft:pumpkin', nil, turtle.dropDown)
	pathfinding.goto(melonChest.x, melonChest.y + 1, melonChest.z)
	inventory.dumpInventory('minecraft:melon', nil, turtle.dropDown)
end

while true do
	for i = 1, (rowNumTotal * colNumTotal) do
		farmPumpkin(i)
	end
	emptyInventory()
	os.sleep(30)
end