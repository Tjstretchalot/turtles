dofile('inventory.lua')
dofile('pathfinding.lua')

local function placeFloor()
	inventory.selectItem('minecraft:cobblestone')
	turtle.placeDown()
end

local function doLayer()
	placeFloor()
	
	move.face(position.WEST)
	turtle.dig()
	move.forward()
	placeFloor()
	move.back()
	move.face(position.EAST)
	turtle.dig()
	move.forward()
	placeFloor()
	move.back()
	turtle.digUp()
	move.up()
	turtle.dig()
	move.face(position.WEST)
	turtle.dig()
	turtle.digUp()
	move.up()
	turtle.dig()
	move.face(position.EAST)
	turtle.dig()
	pathfinding.gotoY(0)
end

local function nextLayer()
	move.face(position.NORTH)
	turtle.dig()
	move.forward()
end

pathfinding.goto(0, 0, 0)
move.face(position.NORTH)

for i=1, 20 do
	doLayer()
	nextLayer()
end
doLayer()

pathfinding.gotoXZY(0, 0, 0)
move.face(position.NORTH)


