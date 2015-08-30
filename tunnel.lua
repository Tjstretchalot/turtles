dofile('inventory.lua')
dofile('pathfinding.lua')

print('How tall? (it will be 3 wide)')
local height = tonumber(io.read())
print('How long?')
local length = tonumber(io.read())
print('Come back afterward? 0 or 1')
local comeback = tonumber(io.read())

local function placeFloor()
	inventory.selectItem('minecraft:cobblestone')
	turtle.placeDown()
end

local function doLayerHeight(height)
	move.face(position.EAST)
	
	for i=1, height do
		turtle.digUp()
		move.up()
		turtle.dig()
	end
	
	move.face(position.WEST)
	for i=1, height do
		turtle.dig()
		move.down()
	end
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
	
	doLayerHeight(height - 1)
	pathfinding.gotoY(0)
end

local function nextLayer()
	move.face(position.NORTH)
	turtle.dig()
	move.forward()
end

pathfinding.goto(0, 0, 0)
move.face(position.NORTH)

for i=1, length do
	doLayer()
	nextLayer()
end
doLayer()

if comeback == 1 then
	pathfinding.gotoXZY(0, 0, 0)
	move.face(position.NORTH)
end


