if pathfinding then return end
dofile('move.lua')

pathfinding = {}

pathfinding.gotoX = function(desiredX)
	if position.x == desiredX then return end
end