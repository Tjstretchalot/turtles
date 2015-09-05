dofile('pathfinding.lua')
dofile('inventory.lua')
dofile('wall.lua')
local config = {
isGap = false
distGap = false
gapHeight = false
gapSize = false
endAction = 1
forgetPos = 0
buildMaterial = 'minecraft:stonebrick'
}
config = common.unserializeFromFile('wall.dat', config)
if position.x ~= 0 or position.y ~= 0 or position.z ~= 0 or position.dir ~= position.NORTH then
	print('Disclaimer - this is not mine')
	print('Reset old position information?')
	print('  0 - No, pretend I did not notice that (WARNING: unpredictable)')
	print('  1 - Yes, delete old position information')
	print('  2 - No, but take me back to 0, 0, 0 and face north.')
	local choice = tonumber(io.read())
	
	if choice == 1 then
		position.forget()
	elseif choice == 2 then
		pathfinding.goto(0, 0, 0)
		move.face(position.NORTH)
	elseif choice ~= 0 then
		return
	end
end
local function isGapInColumn(colNum, distGap, gapSize)
	if not distGap then return false end
	if not gapSize then return false end
	if colNum <= distGap then return false end
	if colNum > distGap + gapSize then return false end
	return true
end
local function doColumn(height, colNum, distGap, gapHeight, gapSize)
	local desiredZ = colNum - 1
	pathfinding.gotoZXY(desiredZ, 0, 0)
	move.face(position.NORTH)
	if isGapInColumn(colNum, distGap, gapSize) then
		for i = 1, gapHeight do
			move.up()
		end
		for i = 1, height - gapHeight do
			inventory.selectItem('minecraft:stonebrick')
			turtle.place()
			move.up()
		end
	else
		for i = 1, height do
			inventory.selectItem('minecraft:stonebrick')
			turtle.place()
			move.up()
		end
	end
end

print('How long should the wall be?')
config.wallLength = io.readNum(config.wallLength)
print('How High?')
config.wallHeight = io.readNum(config.wallHeight)
print('Any gaps in the wall?(1 or 0)')
if tonumber(io.read()) == 1 then
	print('How far to the first empty column?')
	config.distGap = io.readNum(config.distGap)
	print('How wide is the gap?')
	config.gapSize = io.readNum(config.gapSize)
	print('How tall is the gap?')
	config.gapHeight = io.readNum(config.gapHeight)
end
print('What should I do at the end?')
print('0 - Stay at the top of the last column')
print('1 - Go to the bottom of the last column')
print('2 - Go back to the start')
config.endAction = io.readNum(config.readNum)
print('Forget position after? 1 or 0')
config.forgetPos = io.readNum(io.forgetPos)
print('What should it be made with?')
config.buildMaterial = io.readNum(config.buildMaterial)
local function gotoEndLoc(input, finalX)
	if input == 0 then
		return
	elseif input == 1 then
		pathfinding.gotoZXY(finalX, 0, 0)
	else
		pathfinding.goto(0, 0, 0)
		move.face(position.NORTH)
	end
end

wall.doWall(wallHeight, wallLength, gapSize, distToGap, gapHeight)
gotoEndLoc(endAction, wallLength - 1)
if remPos == 1 then position.forget() end