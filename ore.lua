if ore then return end
dofile('pathfinding.lua')
dofile('inventory.lua')

ore = {}
ore.types = {
	emerald = {
		itemName = 'minecraft:emerald_ore',
		prettyName = 'emerald'
	},
	diamond = {
		itemName = 'minecraft:diamond_ore',
		prettyName = 'diamond'
	},
	gold = {
		itemName = 'minecraft:gold_ore',
		prettyName = 'gold'
	},
	redstone = {
		itemName = 'minecraft:redstone_ore',
		prettyName = 'redstone'
	},
	lapis = {
		itemName = 'minecraft:lapis_ore',
		prettyName = 'lapis lazuli'
	},
	iron = {
		itemName = 'minecraft:iron_ore',
		prettyName = 'iron'
	},
	coal = {
		itemName = 'minecraft:coal_ore',
		prettyName = 'coal'
	},
	copper = {
		itemName = 'IC2:blockOreCopper',
		prettyName = 'copper'
	},
	tin = {
		itemName = 'IC2:blockOreTin',
		prettyName = 'tin'
	},
	uranium = {
		itemName = 'IC2:blockOreUran',
		prettyName = 'uranium'
	},
	lead = {
		itemName = 'IC2:blockOreLead',
		prettyName = 'lead'
	}
}

ore.miscTypes = {
	chest = {
		itemName = 'minecraft:chest',
		prettyName = 'chest'
	}
}

--[[
	Checks if the specified item name matches one of our
	ores
	
	itemName - name of the item (e.g. minecraft:gold_ore)
	return - true, table: [ itemName='minecraft:gold_ore', prettyName='gold' ] or false
]]
ore.isOre = function(itemName)
	for key, data in pairs(ore.types) do
		if data.itemName == itemName then
			return true, data
		end
	end
	
	return false
end

--[[
	Checks if the item name matches that of a chest
	
	itemName - name of the item
	return - true or false
]]
ore.isChest = function(itemName)
	return itemName == ore.miscTypes.chest.itemName
end

--[[
	Scans all around for ore, if it finds one it 
	digs it, goes to it, calls itself recursively, returns,
	then continues searching.
]]
local function doDigOutOre()
	local actionFnsArr = {
		{
			inspect = turtle.inspect,
			dig = turtle.dig,
			move = move.forward,
			undoMove = move.back
		},
		{
			inspect = turtle.inspectUp,
			dig = turtle.digUp,
			move = move.up,
			undoMove = move.down
		},
		{
			inspect = turtle.inspectDown,
			dig = turtle.digDown,
			move = move.down,
			undoMove = move.up
		}
	}
	
	for i=1, #actionFnsArr do
		local actionFns = actionFnsArr[i]
		local succ, data = actionFns.inspect()
		if succ then
			local isOre, oreData = ore.isOre(data.name)
			if isOre then
				print('Detected ' .. oreData.prettyName)
				actionFns.dig()
				actionFns.move()
				doDigOutOre()
				actionFns.undoMove()
			end
		end
	end
	
	for i=1, 3 do
		move.turnLeft()
		local succ, data = turtle.inspect()
		if succ then
			local isOre, oreData = ore.isOre(data.name)
			if isOre then
				print('Detected ' .. oreData.prettyName)
				turtle.dig()
				move.forward()
				doDigOutOre()
				move.back()
			end
		end
	end
	move.turnLeft()
end

--[[
	Digs out ore in a direction, scanning using the specified functions first if specified. Otherwise,
	scans in all directions. Ends in its original position and direction in all cases.
	
	firstInspectFn - turtle.inspect, turtle.inspectUp, turtle.inspectDown, or nil. If nil, all params are ignored
	firstDigFn - turtle.dig, turtle.digUp, turtle.digDown, or nil. If nil, all params are ignored
	firstMoveFn - move.forward, move.up, move.down, or nil. If nil, all params are ignored.
]]
ore.digOutOre = function(firstInspectFn, firstDigFn, firstMoveFn)
	if not firstInspectFn or not firstDigFn or not firstMoveFn then
		doDigOutOre()
		return
	end
	
	local posCache = { x = position.x, y = position.y, z = position.z, dir = position.dir }
	local succ, data = firstInspectFn()
	if succ then
		local isOre, oreData = ore.isOre(data.name)
		if isOre then
			print('Detected ' .. oreData.prettyName)
			firstDigFn()
			firstMoveFn()
			doDigOutOre()
			pathfinding.goto(posCache.x, posCache.y, posCache.z)
			move.face(posCache.dir)
		end
	end
	
end

--[[
	Convienence function to dig out ore to the left & to the right (clockwise and counterclockwise)
]]
ore.digOutOreLeftRight = function()
	move.turnLeft()
	ore.digOutOre(turtle.inspect, turtle.dig, move.forward)
	move.turnRight(2)
	ore.digOutOre(turtle.inspect, turtle.dig, move.forward)
	move.turnLeft()
end


