dofile('pathfinding.lua')

local function doLayer()
	move.face(position.WEST)
	turtle.dig()
	turtle.digUp()
	move.up()
	turtle.dig()
	turtle.digUp()
	move.up()
	turtle.dig()
	turtle.digUp()
	move.up()
	turtle.dig()
	move.face(position.EAST)
	turtle.dig()
	move.down()
	turtle.dig()
	move.down()
	turtle.dig()
	move.down()
	turtle.dig()
	turtle.digDown()
	move.down()
	turtle.dig()
	move.face(position.WEST)
	turtle.dig()
	move.face(position.NORTH)
	turtle.dig()
	move.forward()
end

for i=1,64 do doLayer() end

move.face(position.SOUTH)

for i=1,64 do 
	move.forward()
	move.up()
end
