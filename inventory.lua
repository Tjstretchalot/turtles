if inventory then return end

inventory = {}

inventory.countItem = function(itemName, damage)
	local count = 0
	for i=1, 16 do 
		local data = turtle.getItemDetail(i)
		
		if data then
			if data.name == itemName then
				if not damage or damage == data.damage then 
					count = count + item.count
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

inventory.dumpInventory = function() 
	for i=1, 16 do
		turtle.select(i)
		turtle.drop()
	end
end