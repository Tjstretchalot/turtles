dofile('pathfinding.lua')
dofile('inventory.lua')
dofile('wall.lua')
local config = {
	wallLength = 0,
	wallHeight = 0,
	isGap = 0,
	distGap = 0,
	gapHeight = 0,
	gapSize = 0,
	homeAtEnd = 1,
	forgetPos = 0,
	buildMaterial = 'minecraft:stonebrick'
}
config = common.unserializeFromFile('wall.dat', config)

print('How long should the wall be? ('..tostring(config.wallLength)..')')
config.wallLength = io.readNum(config.wallLength)
print('How High? ('..tostring(config.wallHeight)..')')
config.wallHeight = io.readNum(config.wallHeight)

print('Any gaps in the wall?(1 or 0) ('..tostring(config.isGap)..')')
config.isGap = io.readNum(config.isGap)
if config.isGap == 1 then
	print('How far to the first empty column? ('..tostring(config.distGap)..')')
	config.distGap = io.readNum(config.distGap)
	print('How wide is the gap? ('..tostring(config.gapSize)..')')
	config.gapSize = io.readNum(config.gapSize)
	print('How tall is the gap? ('..tostring(config.gapHeight)..')')
	config.gapHeight = io.readNum(config.gapHeight)
end

print('Return home after? ('..tostring(config.homeAtEnd)..')')
config.homeAtEnd = io.readNum(config.homeAtEnd)
print('Forget position after? 1 or 0 ('..tostring(config.forgetPos)..')')
config.forgetPos = io.readNum(io.forgetPos)
print('What should it be made with? ('..config.buildMaterial..')')
config.buildMaterial = io.readStr(config.buildMaterial)

common.serializeToFile('wall.dat', config)

if config.isGap == 0 then config.isGap = false end
if config.homeAtEnd == 0 then config.homeAtEnd = false end
if config.forgetPos == 0 then config.forgetPos = false end

wall.config.wallType = config.buildMaterial
local startPos = {x=position.x, y=position.y, z=position.z, dir=position.dir}


wall.doWall(config.wallHeight, config.wallLength, config.isGap, config.gapSize, config.distGap, config.gapHeight)


if config.forgetPos then position.forget() end
if config.homeAtEnd then
	pathfinding.goto(startPos.x, startPos.y, startPos.z)
	move.face(startPos.dir)
end