dofile('pathfinding.lua')

local function isTree()
	return true
end
local function cutTree()
	if not isTree() then return end
	turtle.dig()
	move.forward()
	local curY = position.y
	while turtle.detectUp() do
		turtle.digUp()
		move.up()
	end
	pathfinding.gotoY(curY)
end


cutTree()