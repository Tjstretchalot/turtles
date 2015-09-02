if storage then return end
dofile('common.lua')

local function hasThing(file)
	return fs.exists(file)
end

local function loadThing(file) 
	local f = fs.open(file, 'r')
	local command = textutils.unserialize(f.readAll())
	f.close()
	return command
end

local function saveThing(file, thing)
	local f = fs.open(file, 'w')
	f.write(textutils.serialize(thing))
	f.close()
end

local function deleteThing(file)
	fs.delete(file)
end

storage = {}
storage.config = {
	commandFile = 'disk/command.dat',
	statusFile = 'disk/status.dat',
	resultFile = 'disk/result.dat',
	
	pingCommand = 'ping',
	storeCommand = 'store',
	retrieveCommand = 'retrieve',
	listCommand = 'list',
	spaceCommand = 'space'
}

storage.isPingCommand = function(commandString)
	return commandString == storage.config.pingCommand
end

storage.isStoreCommand = function(commandString)
	return commandString == storage.config.storeCommand
end

storage.isRetrieveCommand = function(commandString)
	return commandString == storage.config.retrieveCommand
end

storage.isListCommand = function(commandString)
	return commandString == storage.config.listCommand
end

storage.isSpaceCommand = function(commandString)
	return commandString == storage.config.spaceCommand
end

storage.isCommand = function(commandString)
	return storage.isPingCommand(commandString) or storage.isStoreCommand(commandString) or storage.isRetrieveCommand(commandString) or storage.isListCommand(commandString) or storage.isSpaceCommand(commandString)
end

storage.argsAreValidForPingCommand = function(args)
	return #args == 0
end

storage.getPingCommandUsingArgs = function(args)
	return {command = storage.config.pingCommand}
end

storage.argsAreValidForStoreCommand = function(args)
	return #args == 0
end

storage.getStoreCommandUsingArgs = function(args)
	return {command = storage.config.storeCommand}
end

storage.argsAreValidForRetrieveCommand = function(args)
	if #args ~= 2 and #args ~= 3 then return false end
	if tonumber(args[2]) == nil then return false end
	if #args == 3 and tonumber(args[3]) == nil then return false end
	
	return true
end

storage.getRetrieveCommandUsingArgs = function(args)
	local result = {command = storage.config.retrieveCommand, item = args[1], amount = tonumber(args[2])}
	if #args == 3 then
		result.damage = tonumber(args[3])
	end
	return result
end

storage.argsAreValidForListCommand = function(args)
	return #args == 1
end

storage.getListCommandUsingArgs = function(args)
	return {command = storage.config.listCommand, item = args[1]}
end

storage.argsAreValidForSpaceCommand = function(args)
	return #args == 0
end

storage.getSpaceCommandUsingArgs = function(args)
	return {command = storage.config.spaceCommand}
end

storage.argsAreValidForCommand = function(commandString, args) 
	if storage.isPingCommand(commandString) then return storage.argsAreValidForPingCommand(args) end
	if storage.isStoreCommand(commandString) then return storage.argsAreValidForStoreCommand(args) end
	if storage.isRetrieveCommand(commandString) then return storage.argsAreValidForRetrieveCommand(args) end
	if storage.isListCommand(commandString) then return storage.argsAreValidForListCommand(args) end
	if storage.isSpaceCommand(commandString) then return storage.argsAreValidForSpaceCommand(args) end
	return false
end

storage.getCommand = function(commandString, args)
	if storage.isPingCommand(commandString) then return storage.getPingCommandUsingArgs(args) end
	if storage.isStoreCommand(commandString) then return storage.getStoreCommandUsingArgs(args) end
	if storage.isRetrieveCommand(commandString) then return storage.getRetrieveCommandUsingArgs(args) end
	if storage.isListCommand(commandString) then return storage.getListCommandUsingArgs(args) end
	if storage.isSpaceCommand(commandString) then return storage.getSpaceCommandUsingArgs(args) end
end
-- command

storage.hasCommand = function()
	return hasThing(storage.config.commandFile)
end

storage.loadCommand = function()
	return loadThing(storage.config.commandFile)
end

storage.saveCommand = function(command) 
	saveThing(storage.config.commandFile, command)
end

storage.deleteCommand = function()
	deleteThing(storage.config.commandFile)
end

-- status

storage.hasStatus = function()
	return hasThing(storage.config.statusFile)
end

storage.loadStatus = function()
	return loadThing(storage.config.statusFile)
end

storage.saveStatus = function(command) 
	saveThing(storage.config.statusFile, command)
end

storage.deleteStatus = function()
	deleteThing(storage.config.statusFile)
end

-- result

storage.hasResult = function()
	return hasThing(storage.config.resultFile)
end

storage.loadResult = function()
	return loadThing(storage.config.resultFile)
end

storage.saveResult = function(command) 
	saveThing(storage.config.resultFile, command)
end

storage.deleteResult = function()
	deleteThing(storage.config.resultFile)
end
