if tunnel then return end
dofile('pathfinding.lua')
dofile('inventory.lua')

--[[
	This provides highly methods of creating tunnels / strip mines
	of arbitrary width and length
]]

tunnel = {}
tunnel.config = {
}


--[[
	Mines blocks above the turtle, such that there
	is a clearing (including the turtle) of height
	
	height - how tall the column is above the turtles
			 current position
]]
tunnel.doColumn = function(height) 
	local startingY = position.y
	if height >= 2 then turtle.digUp() end
	for i=3, height do 
		move.up()
		turtle.digUp()
	end
	pathfinding.gotoY(startingY)
end

--[[
	Mines one layer of "breadth" (east/west) of the tunnel. Assumes the turtle
	starts at 0, 0, 0 and the tunnel is equally far to the west as to the east for
	breadth (breaking ties by going 1 extra west). 
	
	breadthIndex - The current index of breadth (or row) that we are currently on.
	width        - How wide the tunnel is (size of the breadth)
	height       - How tall the tunnel is
]]
tunnel.doBreadth = function(breadthIndex, width, height)
	if width == 1 then
		pathfinding.goto(0, 0, -breadthIndex)
		doColumn(height)
		return
	end
	
	local distanceFromCenter = width / 2
	if width % 2 == 1 then 
		distanceFromCenter = (width - 1) / 2
	end
	pathfinding.gotoXYZ(-distanceFromCenter, 0, -breadthIndex)
	
	move.face(position.EAST)
	for i=2, width do 
		doColumn(height)
		move.forward()
	end
	doColumn(height)
end

--[[
	Mines the entire tunnel, doing one layer of breadth at a time.
	Assumes the turtle starts at 0, 0, 0, and the tunnel is equally
	far to the west as to the east for breadth (breaking ties by going
	1 extra west).
	
	width  - how wide (east/west) the tunnel is
	height - how tall (up/down) the tunnel is
	length - how long (north/south) the tunnel is
]]
tunnel.doTunnel = function(width, height, length) 
	for i=1, length do
		doBreadth(i, width, height)
	end
end