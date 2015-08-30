if inventory then return end

inventory = {}

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
	
	turtle.select(1)
	local lastCount = inventory.countItem(itemName, damage)
	while lastCount < count do
		local amountToSuck = count - lastCount
		suckFn(amountToSuck)
		local newCount = inventory.countItem(itemName, damage)
		if newCount == lastCount then 
			print('Insufficient ' .. itemName .. ' from chest!')
			os.sleep(5) 
		end
		lastCount = newCount
	end
	
	while lastCount > count do
		turtle.selectItem(itemName, damage)
		local amountToDrop = lastCount - count
		dropFn(amountToDrop)
		local newCount = inventory.countItem(itemName, damage)
		if newCount == lastCount then
			print('Chest is full!')
			os.sleep(5)
		end
		lastCount = newCount
	end
end