dofile('storage_shared.lua')
dofile('inventory.lua')
dofile('pathfinding.lua')

-- STORAGE API --
--[[
	Contains a list of chests, their respective locations, and their contents. Ex:
	
	[
		[
			position: {x=0, y=12, z=-1},
			content: 'minecraft:cobblestone'
			amount: 64
		]
	]
]]
local my_storage = {}

local function initStorage()
	local numChestsInZ = 8
	local numChestsInY = 8
	
	numChestsInZ = numChestsInZ - 1
	numChestsInY = numChestsInY - 1
	
	for zDist = -4, -4 - (numChestsInZ * 2), -2 do
		for yDist = -4, -4 - numChestsInY, -1 do
			my_storage[#my_storage + 1] = {position = {x=-9, y=yDist, z=zDist}}
		end
	end
end

local function loadStorage()
	if not fs.exists('disk/storage.dat') then 
		initStorage()
		return
	end
	
	local f = fs.open('disk/storage.dat', 'r')
	my_storage = textutils.unserialize(f.readAll())
	f.close()
end

local function saveStorage()
	local f = fs.open('disk/storage.dat', 'w')
	f.write(textutils.serialize(my_storage))
	f.close()
end

local function inChestRoom()
	return position.y < -2
end

local function gotoChestRoom()
	if inChestRoom() then return end
	pathfinding.gotoZXY(-9, -3, -3)
end

local function leaveChestRoom()
	if not inChestRoom() then return end
	pathfinding.gotoZXY(-9, -1, -3)
	pathfinding.gotoXYZ(0, 0, 0)
	move.face(position.NORTH)
end

local function gotoChest(chestObj)
	pathfinding.gotoXZY(chestObj.position.x + 1, chestObj.position.y, chestObj.position.z)
	move.face(position.WEST)
end

local function findChestForItem(item, requiredSpace)
	if requiredSpace == 0 then requiredSpace = false end
	
	for i=1, #my_storage do
		local chestObj = my_storage[i]
		if chestObj.content == item then
			local space = 1728 - chestObj.count
			if not requiredSpace or space >= requiredSpace then
				return chestObj
			end
		end
	end
end

local function findChestWithItem(item, requiredNumber)
	if requiredNumber == 0 then requiredNumber = false end
	
	for i=1, #my_storage do
		local chestObj = my_storage[i]
		if chestObj.content == item then
			if not requiredNumber or chestObj.count >= requiredNumber then
				return chestObj
			end
		end
	end
end

local function findOrChooseChestForItem(item, requiredSpace)
	local chestObj = findChestForItem(item, requiredSpace)
	if chestObj then return chestObj end
	
	for i=1, #my_storage do
		local chestObj = my_storage[i]
		if not chestObj.content then
			chestObj.content = item
			chestObj.count = 0
			return chestObj
		end
	end
end

local function dumpItem(item)
	gotoChestRoom()
	
	local spaceNeeded = inventory.countItem(item)
	
	local chestObj = findOrChooseChestForItem(item, currentCount)
	gotoChest(chestObj)
	
	inventory.dumpInventory(item)
	
	chestObj.count = chestObj.count + spaceNeeded
end

local function acquireItem(item, quantity, damage)
	gotoChestRoom()
	
	local chestObj = findChestWithItem(item, quantity)
	gotoChest(chestObj)
	
	inventory.acquireItem(item, damage, quantity)
	
	chestObj.count = chestObj.count - quantity
	if chestObj.count == 0 then
		chestObj.content = nil
		chestObj.count = nil
	end
end

-- END STORAGE API --

local function awaitCommand()
	while not storage.hasCommand() do
		os.sleep(1)
	end
end

local function handlePingCommand(pingCommand)
	return {descriptionString = 'ping - Connection successful'}
end

local function handleStoreCommand(storeCommand)
	if inventory.isEmpty() then
		return {descriptionString = 'store - Inventory is already empty'}
	end
	
	local itemsByName = inventory.getItemsSortedByName()
	local totalCount = inventory.itemCount()
	
	local itemsStored = ''
	local firstItem = true
	for itemName, stackInvIndexesAndQuantities in pairs(itemsByName) do
		if firstItem then
			firstItem = false
		else
			itemsStored = itemsStored .. ', '
		end
		
		local countOfItem = inventory.countItem(itemName)
		itemsStored = itemsStored .. tostring(countOfItem) .. 'x ' .. itemName
		
		dumpItem(itemName)
	end
	
	leaveChestRoom()
	
	return {descriptionString = 'store - Stored ' .. itemsStored}
end

local function handleRetrieveCommand(retrieveCommand)
	acquireItem(retrieveCommand.item, retrieveCommand.amount, retrieveCommand.damage)
	leaveChestRoom()
	local descString = 'retrieve - ' .. tostring(retrieveCommand.amount) .. 'x ' .. retrieveCommand.item
	if retrieveCommand.damage then
		descString = descString .. ':' .. tostring(retrieveCommand.damage)
	end
	return {descriptionString = descString}
end

local function handleListCommand(listCommand)
	local item = listCommand.item
	local count = 0
	local numChests = 0
	for i=1, #my_storage do
		local chestObj = my_storage[i]
		
		if chestObj.content == item then
			numChests = numChests + 1
			count = count + chestObj.count
		end
	end
	return {descriptionString = 'list - ' .. tostring(count) .. 'x ' .. item .. ' over ' .. tostring(numChests) .. ' chest(s)'}
end

local function handleCommand(command)
	if storage.isPingCommand(command.command) then return handlePingCommand(command) end
	if storage.isStoreCommand(command.command) then return handleStoreCommand(command) end
	if storage.isRetrieveCommand(command.command) then return handleRetrieveCommand(command) end
	if storage.isListCommand(command.command) then return handleListCommand(command) end
end

loadStorage()

while true do
	awaitCommand()
	storage.saveResult(handleCommand(storage.loadCommand()))
	storage.deleteCommand()
	saveStorage()
end