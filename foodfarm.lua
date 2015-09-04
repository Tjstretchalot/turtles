dofile('pathfinding.lua')
dofile('inventory.lua')
dofile('common.lua')


local function harvestFoodBelowMe()
	local success, data = turtle.inspectDown()
	if not success then 
		return true, nil
	end
	
	local replantMe = false
	local foodType = data.name
	
	if data.name == 'minecraft:potatoes' and data.metadata == 7 then
		replantMe = true
	elseif data.name == 'minecraft:wheat' and data.metadata == 7 then
		replantMe = true
	elseif data.name == 'minecraft:carrot' and data.metadata == 7 then
		replantMe = true
	end
	
	if replantMe then
		turtle.digDown()
		return true, foodType
	end
	
	return false, nil
end

local function replantFoodBelowMe(foodType)
	foodType = foodType or 'minecraft:wheat'
	
	local seedType = foodType
	if foodType == 'minecraft:wheat' then
		seedType = 'minecraft:wheat_seeds'
	elseif foodType == 'minecraft:potatoes' then
		seedType = 'minecraft:potato'
	elseif foodType == 'minecraft:carrots' then
		seedType = 'minecraft:carrot'
	end
	
	turtle.digDown()
	inventory.selectItem(seedType)
	turtle.placeDown()
end

local function handleFoodBelowMe()
	local replantMe, foodType = harvestFoodBelowMe()
	if replantMe then
		replantFoodBelowMe(foodType)
	end
end

local wheatSeedsChest = {x = 2, y = -1, z = 1, item = 'minecraft:wheat_seeds', count = 3}
local potatoesChest = {x = -4, y = -1, z = 1, item = 'minecraft:potato', count = 3}
local wheatChest = {x = -2, y = -1, z = 1, item = 'minecraft:wheat', count = 0}
local carrotChest = {x = 4, y = -1, z = 1, item = 'minecraft:carrot', count = 3}
local poisonedPotatoChest = {x = 0, y = -1, z = 1, item = 'minecraft:poisonous_potato', count = 0}

local allChests = {potatoesChest, wheatChest, poisonedPotatoChest, wheatSeedsChest, carrotChest}
local function handleInventory()
	for i=1, #allChests do
		local chestInf = allChests[i]
		
		pathfinding.gotoXZY(chestInf.x, chestInf.y + 1, chestInf.z)
		inventory.acquireItem(chestInf.item, nil, chestInf.count, turtle.suckDown, turtle.dropDown)
	end
end


handleInventory()
local startPosOfFarm = {x = -4, y = 1, z = -1, dir=position.NORTH}
while true do
	for i=1, 81 do
		local xz = common.getNextXZInSquareRoom(startPosOfFarm, 9, i)
		pathfinding.gotoYXZ(xz.x, startPosOfFarm.y, xz.z)
		handleFoodBelowMe()
	end
	handleInventory()
	os.sleep(30)
end