dofile('pathfinding.lua')
dofile('inventory.lua')
dofile('common.lua')


local startPosFarm = {x = -4, y = 3, z = -1, dir = position.NORTH}

local cactusChest = {x = 0, y = -1, z = 1}

local function handleCactusBelowMe()
	if not turtle.detectDown() then return end
	
	turtle.digDown()
end

local function handleInventory()
	pathfinding.gotoXZY(cactusChest.x, cactusChest.y + 1, cactusChest.z)
	inventory.dumpInventory('minecraft:cactus', nil, turtle.dropDown)
end

local width = 9
local length = 9

while true do
	for i=1, (width*length) do
		local xz = common.getNextXZInSquareRoom(startPosFarm, width, i)
		pathfinding.gotoYXZ(xz.x, startPosFarm.y, xz.z)
		handleCactusBelowMe()
	end
	handleInventory()
	os.sleep(30)
end