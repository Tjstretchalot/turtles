--[[
	Scans the floor for ores
]]

dofile('tunnel.lua')
dofile('common.lua')

local config = {
	width = 32,
	length = 32
}

config = common.unserializeFromFile('floor_scanner.dat', config)

print('Width: (' .. config.width .. ')')
config.width = io.readNum(config.width)
print('Length: (' .. config.length .. ')')
config.length = io.readNum(config.length)

common.serializeToFile('floor_scanner.dat', config)

local startDir = position.dir
local leftDir = position.normalizeDir(startDir + position.COUNTERCLOCKWISE)
local rightDir = position.normalizeDir(startDir + position.CLOCKWISE)

local depthOffset = position.getOffsetFromDir(startDir)
local curDir = leftDir

for depth = 1, config.length do
	local curDirOffset = position.getOffsetFromDir(curDir)
	pathfinding.goto(x + 
	for breadth = 1, config.width do
			
	end
end
