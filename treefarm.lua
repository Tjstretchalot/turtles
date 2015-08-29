dofile('pathfinding.lua')

local function isTree()
	local success, data = turtle.inspect()
	if success then
		if data.name == 'minecraft:log' then return true end
	end
	return false
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
	move.back()
end


cutTree()