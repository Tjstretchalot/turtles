dofile('inventory.lua')
dofile('move.lua')

while true do
	turtle.dig()
	if inventory.isFull() then
		move.face(position.SOUTH)
		inventory.dumpInventory()
		move.face(position.NORTH)
	end
end
