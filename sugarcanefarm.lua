dofile('pathfinding.lua')
dofile('inventory.lua')
dofile('common.lua')


local startPosSugarcane = {x = -3, y = 3, z = -1, dir = position.NORTH}

local sugarcaneChest = {x = 0, y = -1, z = 1}

local function handleSugarcaneBelowMe()
	for i=1, 2 do
		turtle.digDown()
		move.down()
	end
	
	if not turtle.detectDown() then
		inventory.selectItem('minecraft:reeds')
		turtle.placeDown()
	end
end

local function handleInventory()
	pathfinding.gotoXZY(sugarcaneChest.x, sugarcaneChest.y + 1, sugarcaneChest.z)
	inventory.dumpInventory('minecraft:reeds', nil, turtle.dropDown)
end

local width = 8
local length = 9

while true do
	for i=1, (width*length) do
		local xz = common.getNextXZInSquareRoom(startPosSugarcane, width, i)
		pathfinding.gotoYXZ(xz.x, startPosSugarcane.y, xz.z)
		handleSugarcaneBelowMe()
	end
	handleInventory()
	os.sleep(30)
end