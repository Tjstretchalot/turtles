if pathfinding then return end
dofile('move.lua')

pathfinding = {}

pathfinding.gotoX = function(desiredX)
	if position.x == desiredX then return end
	
	if position.x < desiredX then 
		move.face(position.POSITIVE_X) 
	else
		move.face(position.NEGATIVE_X) 
	end
	
	local times = desiredX - position.x
	if times < 0 then times = -times end
	move.forward(times)
end

pathfinding.gotoY = function(desiredY) 
	if position.y == desiredY then return end
	
	local times = desiredY - position.y
	if times > 0 then 
		move.up(times)
	else
		move.down(-times)
	end
end

pathfinding.gotoZ = function(desiredZ)
	if position.z == desiredZ then return end
	
	if position.z < desiredZ then
		move.face(position.POSITIVE_Z)
	else
		move.face(position.NEGATIVE_Z)
	end
	
	local times = desiredZ - position.z
	if times < 0 then times = -times end
	move.forward(times)
end

pathfinding.gotoXYZ = function(desiredX, desiredY, desiredZ)
	pathfinding.gotoX(desiredX)
	pathfinding.gotoY(desiredY)
	pathfinding.gotoZ(desiredZ)
end

pathfinding.gotoXZY = function(desiredX, desiredY, desiredZ)
	pathfinding.gotoX(desiredX)
	pathfinding.gotoZ(desiredZ)
	pathfinding.gotoY(desiredY)
end

pathfinding.gotoYXZ = function(desiredX, desiredY, desiredZ)
	pathfinding.gotoY(desiredY)
	pathfinding.gotoX(desiredX)
	pathfinding.gotoZ(desiredZ)
end

pathfinding.gotoYZX = function(desiredX, desiredY, desiredZ)
	pathfinding.gotoY(desiredY)
	pathfinding.gotoZ(desiredZ)
	pathfinding.gotoX(desiredX)
end

pathfinding.gotoZXY = function(desiredX, desiredY, desiredZ)
	pathfinding.gotoZ(desiredZ)
	pathfinding.gotoX(desiredX)
	pathfinding.gotoY(desiredY)
end

pathfinding.gotoZYX = function(desiredX, desiredY, desiredZ)
	pathfinding.gotoZ(desiredX)
	pathfinding.gotoY(desiredY)
	pathfinding.gotoX(desiredZ)
end

pathfinding.goto = pathfinding.gotoXZY