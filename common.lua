if common then return end
common = {}

if not string.split then 
	-- https://github.com/StuartIanRoss/ComputerCraft/blob/master/packages/lib/String.lua
	string.split = function(str, delim, maxNb)
		delim = delim or ' '
		-- Eliminate bad cases...
		if string.find(str, delim) == nil then
			return { str }
		end
		
		if maxNb == nil or maxNb < 1 then
			maxNb = 0 -- No limit
		end
		
		local result = {}
		local pat = "(.-)" .. delim .. "()"
		local nb = 0
		local lastPos
		for part, pos in string.gmatch(str, pat) do
			nb = nb + 1
			result[nb] = part
			lastPos = pos
			if nb == maxNb then break end
		end
		
		-- Handle the last field
		if nb ~= maxNb then
			result[nb + 1] = string.sub(str, lastPos)
		end
		
		return result
		
	end
end

common.splitCommandAndArgsFromString = function(str)
	local exploded = string.split(str)
	
	local args = {}
	
	for i=2, #exploded do
		args[i-1] = exploded[i]
	end
	
	return exploded[1], args
end

common.serializeToFile = function(fileName, tab) 
	local f = fs.open(fileName, 'w')
	f.write(textutils.serialize(tab))
	f.close()
end

common.unserializeFromFile = function(fileName, defaults)
	local result = {}
	if not fs.exists('manualtunnel.dat') then
		for key, value in pairs(defaults) do
			result[key] = value
		end
		return result
	end
	
	local f = fs.open('manualtunnel.dat', 'r')
	local saved = textutils.unserialize(f.readAll())
	f.close()
	
	for key, value in pairs(defaults) do
		result[key] = value
	end
	for key, value in pairs(saved) do
		result[key] = value
	end
	return result
end


io.readStr = function(default)
	local choice = io.read()
	if string.len(choice) > 0 then
		return choice
	end
	return default
end

io.readNum = function(default)
	return tonumber(readStr(default))
end
