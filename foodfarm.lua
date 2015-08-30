dofile('pathfinding.lua')
dofile('inventory.lua')

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

local wheatSeedsChest = {x = 0, y = -1, z = 1}
local potatoesChest = {x = 2, y = -1, z = 1}
local wheatChest = {x = -2, y = -1, z = 1}

local function handleInventory()
	pathfinding.goto(wheatSeedsChest.x, wheatSeedsChest.y + 1, wheatSeedsChest.z)
	inventory.acquireItem('minecraft:wheat_seeds', nil, 1, turtle.suckDown, turtle.dropDown)
	pathfinding.goto(potatoesChest.x, potatoesChest.y + 1, potatoesChest.z)
	inventory.acquireItem('minecraft:potato', nil, 1, turtle.suckDown, turtle.dropDown)
	pathfinding.goto(wheatChest.x, wheatChest.y + 1, wheatChest.z)
	inventory.dumpInventory('minecraft:wheat', nil, turtle.dropDown)
end


handleInventory()
while true do
	for foodX = -4, 4 do
		for foodZ = -1, -9, -1 do
			pathfinding.goto(foodX, 0, foodZ)
			handleFoodBelowMe()
		end
	end
	handleInventory()
end