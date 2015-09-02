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