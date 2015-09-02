dofile('storage_shared.lua')

local function getInstructions()
	return {
		'Storage Turtle: Commands',
		'  ping - Test connection',
		'  store - Stores turtles inventory',
		'  retrieve <itemname> <amount> [<damage>]',
		'  list <itemname> - Checks quantity of itemname',
		'  space - check space remaining'
	}
end

local function writeLineToMonitor(monitor, line, curPos, xPos) 
	xPos = xPos or 1
	monitor.setCursorPos(xPos, curPos)
	monitor.write(line)
	curPos = curPos + 1
	return curPos
end

local function writeLinesToMonitor(monitor, linesTable, curPos, xPos)
	xPos = xPos or 1
	for i, str in ipairs(linesTable) do
		curPos = writeLineToMonitor(monitor, str, curPos, xPos)
	end
	return curPos
end

local function updateMonitor(monitor, recentActivityLines)
	monitor.clear()
	monitor.setTextScale(0.5)

	local curPos = 1
	curPos = writeLinesToMonitor(monitor, getInstructions(), curPos)
	curPos = writeLineToMonitor(monitor, 'Recent Activity', curPos + 1) -- skip 1 line
	curPos = writeLinesToMonitor(monitor, recentActivityLines, curPos, 3)
end

local MAX_RECENT_ACTIVITY = 12
local recentActivityFile = 'disk/recent_activity.dat'
local recentActivityLines = {}

local function loadRecentActivity()
	if fs.exists(recentActivityFile) then
		local f = fs.open(recentActivityFile, 'r')
		recentActivityLines = textutils.unserialize(f.readAll())
		f.close()
	end
end

local function saveRecentActivity()
	local f = fs.open(recentActivityFile, 'w')
	f.write(textutils.serialize(recentActivityLines))
	f.close()
end

local function addRecentActivityLine(line) 
	while #recentActivityLines >= MAX_RECENT_ACTIVITY do
		table.remove(recentActivityLines, 1)
	end
	recentActivityLines[#recentActivityLines + 1] = line
end

local function runCommand(command)
	storage.saveCommand(command)
	
	print('Awaiting result..')
	while not storage.hasResult() do
		os.sleep(1)
	end
	print('Acquired result!')
	
	local result = storage.loadResult()
	local resultString = result.descriptionString
	print(resultString)
	addRecentActivityLine(resultString)
	
	storage.deleteResult()
end

loadRecentActivity()

local monitor = peripheral.wrap('top')
updateMonitor(monitor, recentActivityLines)

while true do
	print('Enter command: ')
	local command, args = common.splitCommandAndArgsFromString(io.read())
	
	if command and storage.argsAreValidForCommand(command, args) then
		runCommand(storage.getCommand(command, args))
	else
		print('Invalid command!')
	end
	saveRecentActivity()
	updateMonitor(monitor, recentActivityLines)
end
