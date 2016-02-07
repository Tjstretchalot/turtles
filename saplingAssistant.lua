dofile('inventory.lua')
dofile('pathfinding.lua')
local function deliverSaplings()
	pathfinding.gotoYXZ(0, 4, -1)
	inventory.dumpInventory()
	pathfinding.gotoYXZ(0, 0, 0)
	move.face(position.NORTH)
end
while true do
	turtle.suck()
	turtle.suckUp()
	deliverSaplings()
	os.sleep(5)
end