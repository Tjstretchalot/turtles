if tunnel then return end
dofile('pathfinding.lua')
dofile('inventory.lua')

--[[
	This provides highly methods of creating tunnels / strip mines
	of arbitrary width and length
]]

tunnel = {}
tunnel.config = {
	floorType = 'minecraft:cobblestone',
	detectCeiling = false
}

tunnel.onNotEnoughFloor = function()
	while not inventory.haveItem(tunnel.config.floorType) do
		print('Not enough '..tunnel.config.floorType..' for floor!')
		os.sleep(5)
	end
end


--[[
	Mines blocks above the turtle, such that there
	is a clearing (including the turtle) of height
	
	height     - how tall the column is above the turtles current position
	placeFloor - if the floor should be placed below the turtle
]]
tunnel.doColumn = function(height, placeFloor) 
	if placeFloor then
		if not inventory.haveItem(tunnel.config.floorType) then
			tunnel.onNotEnoughFloor()
		end
		inventory.selectItem(tunnel.config.floorType)
		turtle.placeDown()
	end
	
	local startingY = position.y
	if tunnel.config.detectCeiling then
		while turtle.detectUp() do
			turtle.digUp()
			move.up()
		end
	else
		if height >= 2 then turtle.digUp() end
		for i=3, height do 
			move.up()
			turtle.digUp()
		end
	end
	
	pathfinding.gotoY(startingY)
end

--[[
	Mines <length> number of columns, including the turtles current column,
	in front of the turtle. Ends at the bottom of the last column
	
	length     - number of columns 
	height     - how tall each column is
	placeFloor - if the floor should be placed below the turtles current y in	
				 each column
]]
tunnel.doColumnsForward = function(length, height, placeFloor)
	tunnel.doColumn(height, placeFloor)
	for i=2, length do
		turtle.dig()
		move.forward()
		tunnel.doColumn(height, placeFloor)
	end
end

--[[
	Mines the entire tunnel, doing one layer of breadth at a time.
	Takes the turtles starting position into account such that the
	tunnel will be in the turtles current direction, and the turtle
	will begin mining the layer after the turtles current layer. In
	other words, the start is excluded and the end in included.
	
	width      - how wide (east/west) the tunnel is
	height     - how tall (up/down) the tunnel is
	length     - how long (north/south) the tunnel is
	placeFloor - if floor should be placed below the tunnel
]]
tunnel.doTunnel = function(width, height, length, placeFloor)
	if width == 1 then 
		tunnel.doColumnsForward(length, height, placeFloor)
		return
	end
	
	local startX = position.x
	local startY = position.y
	local startZ = position.z
	local startDir = position.dir
	
	local movementLeft = (width - 1) / 2
	local movementRight = (width - 1) / 2
	if width % 2 == 0 then
		movementLeft = (width / 2)
		movementRight = (width / 2) - 1
	end
	local leftDir = position.normalizeDir(startDir + position.COUNTERCLOCKWISE)
	local rightDir = position.normalizeDir(startDir + position.CLOCKWISE)
	local curDirBreadth = rightDir
	local curDirBreadthOpp = leftDir
	
	local offsetForDepth = position.getOffsetForDir(startDir)
	
	for i=1, length do
		-- Preparations:
		local offsetForBreadthStart = position.getOffsetForDir(curDirBreadthOpp)
		local offsetForBreadth = position.getOffsetForDir(curDirBreadth)
		-- Get 1 depth behind the starting position for this tunnels layer, facing towards increasing depth
		pathfinding.goto(startX + offsetForDepth.x * (i-1) + offsetForBreadthStart.x * movementLeft, startY, startZ + offsetForDepth.z * (i-1) + offsetForBreadthStart.z * movementLeft)
		move.face(startDir)
		
		-- Get into the starting spot facing the right way
		turtle.dig()
		move.forward()
		move.face(curDirBreadth)
		
		-- Mine the breadth
		tunnel.doColumnsForward(width, height, placeFloor)
		
		-- Reverse direction of breadths
		local tmpDir = curDirBreadth
		curDirBreadth = curDirBreadthOpp
		curDirBreadthOpp = tmpDir
	end
end