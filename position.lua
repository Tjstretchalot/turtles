if position then return end
position = {}

-- These go clockwise
position.NEGATIVE_Z = 1 -- North
position.NORTH = position.NEGATIVE_Z
position.POSITIVE_X = 2 -- East
position.EAST = position.POSITIVE_X
position.POSITIVE_Z = 3 -- South
position.SOUTH = position.POSITVE_Z
position.NEGATIVE_X = 4 -- West
position.WEST = position.NEGATIVE_X

position.x = 0
position.y = 0
position.z = 0
position.dir = position.NORTH


position.load = function()
	print('Loading position...')
	
	print('Done')
end

position.save = function()
	print('Saving position...')
	
	print('Done')
end

position.load()