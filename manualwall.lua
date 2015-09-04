dofile('pathfinding.lua')
dofile('inventory.lua')
dofile('wall.lua')

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

local isGap = false
local distToGap = false
local gapSize = false
local gapHeight = false
print('How long should the wall be?')
local wallLength = tonumber(io.read())
print('How High?')
local wallHeight = tonumber(io.read())
print('Any gaps in the wall?(1 or 0)')
if tonumber(io.read()) == 1 then
	isGap = true
	print('How far to the first empty column?')
	distToGap = tonumber(io.read())
	print('How wide is the gap?')
	gapSize = tonumber(io.read())
	print('How tall is the gap?')
	gapHeight = tonumber(io.read())
end
print('What should I do at the end?')
print('0 - Stay at the top of the last column')
print('1 - Go to the bottom of the last column')
print('2 - Go back to the start')
local endAction = tonumber(io.read())
print('Forget position after? 1 or 0')
local remPos = tonumber(io.read())
local function gotoEndLoc(input, finalZ)
	if input == 0 then
		return
	elseif input == 1 then
		pathfinding.gotoZXY(finalZ, 0, 0)
	else
		pathfinding.goto(0, 0, 0)
		move.face(position.NORTH)
	end
end
wall.doWall(wallHeight, wallLength, gapSize, distToGap, gapHeight)
gotoEndLoc(endAction, wallLength - 1)
if remPos == 1 then position.forget() end