if inventory then return end

inventory = {}

inventory.isEmpty = function()
	for i=1, 16 do
		local data = turtle.getItemDetail(i)
		
		if data then return false end
	end
	return true
end

inventory.isFull = function()
	for i=1, 16 do
		local data = turtle.getItemDetail(i)
		
		if not data then return false end
	end
	return true
end

--[[
	Returns a table like such:
	
	[
		'minecraft:cobblestone': [ 1: 64, 4: 32],
		'minecraft:stone': [2: 1]
	]
]]
inventory.getItemsSortedByName = function()
	local result = {}
	for i=1, 16 do
		local data = turtle.getItemDetail(i)
		
		if data then
			if not result[data.name] then
				result[data.name] = {}
			end
			result[data.name][i] = data.count
		end
	end
	return result
end

inventory.itemCount = function()
	local result = 0
	
	for i=1, 16 do
		local data = turtle.getItemDetail(i)
		
		if data then
			result = result + data.count
		end
	end
	
	return result
end

inventory.countItem = function(itemName, damage)
	local count = 0
	for i=1, 16 do 
		local data = turtle.getItemDetail(i)
		
		if data then
			if data.name == itemName then
				if not damage or damage == data.damage then 
					count = count + data.count
				end
			end
		end
	end
	return count
end

inventory.haveItem = function(itemName, damage) 
	return inventory.countItem(itemName, damage) > 0
end

inventory.selectItem = function(itemName, damage)
	for i=1, 16 do
		local data = turtle.getItemDetail(i)
		
		if data then
			if data.name == itemName and (not damage or damage == data.damage) then
				turtle.select(i)
				return
			end
		end
	end
end

inventory.selectEmpty = function()
	for i=1, 16 do
		local data = turtle.getItemDetail(i)
		
		if not data then
			turtle.select(i)
			return i
		end
	end
end

inventory.combineStacks = function()
	for i=1, 15 do
		turtle.select(i)
		for j=(i+1), 16 do
			if turtle.compareTo(j) then
				turtle.select(j)
				turtle.transferTo(i)
				turtle.select(i)
			end
		end
	end
end

inventory.dumpInventory = function(itemName, damage, dropFn) 
	dropFn = dropFn or turtle.drop
	
	if not itemName then 
		for i=1, 16 do
			turtle.select(i)
			dropFn()
		end
	else
		while inventory.haveItem(itemName, damage) do
			inventory.selectItem(itemName, damage)
			dropFn()
		end
	end
end

inventory.acquireItem = function(itemName, damage, count, suckFn, dropFn) 
	suckFn = suckFn or turtle.suck
	dropFn = dropFn or turtle.drop
	count = count or 1
	
	local unrelatedThings = {}
	
	
	local lastCount = inventory.countItem(itemName, damage)
	while lastCount < count do
		local curSlot = inventory.selectEmpty()
		if not curSlot then 
			print('Out of inventory space for sorting!')
			return
		else
			local amountToSuck = count - lastCount
			if amountToSuck > 64 then amountToSuck = 64 end
			suckFn(amountToSuck)
			local newCount = inventory.countItem(itemName, damage)
			if newCount == lastCount then 
				local thingAcquiredData = turtle.getItemDetail(curSlot)
				if thingAcquiredData then
					unrelatedThings[#unrelatedThings + 1] = curSlot
				else
					print('Insufficient ' .. itemName .. ' from chest!')
					os.sleep(5) 
				end
			end
			lastCount = newCount
		end
	end
	
	while lastCount > count do
		inventory.selectItem(itemName, damage)
		local amountToDrop = lastCount - count
		local dataOfCurSlot = turtle.getItemDetail()
		if amountToDrop > dataOfCurSlot.count then amountToDrop = dataOfCurSlot.count end
		dropFn(amountToDrop)
		local newCount = inventory.countItem(itemName, damage)
		if newCount == lastCount then
			print('Chest is full!')
			os.sleep(5)
		end
		lastCount = newCount
	end
	
	for i=1, #unrelatedThings do
		local slotUnrelated = unrelatedThings[i]
		turtle.select(slotUnrelated)
		dropFn()
	end
end
