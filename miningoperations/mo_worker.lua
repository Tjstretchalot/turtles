dofile('mo_common.lua')
dofile('pathfinding.lua')
dofile('tunnel.lua')

----
-- mo_worker.lua
--
-- The entry file to a worker that pairs with an overseer. See the 
-- particular overseer file you are using for setup information
----

local tConfig = {
  nChannel = -1,
  tChestDumpLocation = {
    x = 0,
    y = 0,
    z = 0
  },
  tStartPosition = {
    x = 0,
    y = 0,
    z = 0,
    direction = position.NORTH
  },
  sChestDumpFace = "west",
  sChestDumpFunction = "down",
  
  sOrderStartToChest = "xyz",
  sOrderStartToJob = "xyz",
  sOrderJobToChest = "xyz",
  sOrderJobToJob = "xyz",
  sOrderJobToStart = "xyz",
  sOrderChestToJob = "xyz",
  sOrderChestToStart = "xyz"
}

local tConfigTemp = {
  nChestDumpFace = position.WEST,
  fChestDumpFunction = turtle.dropDown
}

local function getPathfindingFunction(sOrder) 
  ----
  -- Gets the appropriate function (pathfinding.gotoXYZ, pathfinding.gotoXZY, etc.) from
  -- a string like "xyz"
  ----
  
  if sOrder == 'xyz' then 
    return pathfinding.gotoXYZ
  elseif sOrder == 'xzy' then 
    return pathfinding.gotoXZY
  elseif sOrder == 'yzx' then 
    return pathfinding.gotoYZX
  elseif sOrder == 'yxz' then 
    return pathfinding.gotoYXZ
  elseif sOrder == 'zxy' then
    return pathfinding.gotoZXY
  elseif sOrder == 'zyx' then 
    return pathfinding.gotoZYX
  else 
    return nil
  end
end

local function positionEquals(p1, p2) 
  return p1.x == p2.x and p1.y == p2.y and p1.z == p2.z
end

pathfinding.goto = function(x, y, z) 
  local tGoal = {x, y, z}
  local bAtStart = positionEquals(tConfig.tStartPosition, position)
  local bAtChest = positionEquals(tConfig.tChestDumpLocation, position)
  local bAtJob = not bAtStart and not bAtChest
  
  local bGoalStart = positionEquals(tConfig.tStartPosition, tGoal)
  local bGoalChest = positionEquals(tConfig.tChestDumpLocation, tGoal)
  local bGoalJob = not bGoalStart and not bGoalChest 
  
  local sPath = tConfig.sOrderJobToJob
  if bAtStart and bGoalChest then 
    sPath = tConfig.sOrderStartToChest
  elseif bAtStart and bGoalJob then 
    sPath = tConfig.sOrderStartToJob 
  elseif bAtChest and bGoalStart then 
    sPath = tConfig.sOrderChestToStart 
  elseif bAtChest and bGoalJob then 
    sPath = tConfig.sOrderChestToJob 
  elseif bAtJob and bGoalStart then 
    sPath = tConfig.sOrderJobToStart 
  elseif bAtJob and bGoalChest then 
    sPath = tConfig.sOrderJobToChest 
  elseif bAtJob and bGoalJob then 
    sPath = tConfig.sOrderJobToJob 
  end 
  print('Going from (' .. position.x .. ', ' .. position.y .. ', ' .. position.z .. ') to (' .. x .. ', ' .. y .. ', ' .. z .. ') using order ' .. sPath)
  local fPath = getPathfindingFunction(sPath)
  return fPath(x, y, z)
end

local function getNumberDirectionFromString(sDir)
  ----
  -- Gets the appropriate direction (e.g. position.WEST) from a string like "west"
  ----
  
  if sDir == 'west' then
    return position.WEST
  elseif sDir == 'east' then 
    return position.EAST
  elseif sDir == 'north' then 
    return position.NORTH
  elseif sDir == 'south' then 
    return position.SOUTH
  else 
    return nil 
  end
end

local function getDropFunctionFromString(sDropFunction) 
  ----
  -- Gets the appropriate drop function (e.g. turtle.drop) from a string like "front" or "down" or "up"
  ----
  
  if sDropFunction == 'front' then 
    return turtle.drop
  elseif sDropFunction == 'down' then 
    return turtle.dropDown 
  elseif sDropFunction == 'up' then 
    return turtle.dropUp
  else 
    return nil 
  end
end

local function handleTunnelJob(oJob) 
  pathfinding.goto(oJob.jobConfig.startPosition.x, oJob.jobConfig.startPosition.y, oJob.jobConfig.startPosition.z)
  move.face(oJob.jobConfig.startPosition.direction)
  
  tunnel.config.scanForOre = oJob.jobConfig.mineResources
  
  tunnel.onInventoryFull = function() 
    local oCurPos = {x = position.x, y = position.y, z = position.z, dir = position.dir}
    pathfinding.goto(tConfig.tChestDumpLocation.x, tConfig.tChestDumpLocation.y, tConfig.tChestDumpLocation.z)
    move.face(tConfigTemp.nChestDumpFace)
    inventory.dumpInventory(nil, nil, tConfigTemp.fChestDumpFunction)
    pathfinding.goto(oCurPos.x, oCurPos.y, oCurPos.z)
    move.face(oCurPos.dir)
  end
  
  tunnel.doTunnel(oJob.jobConfig.width, oJob.jobConfig.height, oJob.jobConfig.length, oJob.jobConfig.placeFloor)
  pathfinding.goto(oJob.jobConfig.startPosition.x, oJob.jobConfig.startPosition.y, oJob.jobConfig.startPosition.z)
  move.face(oJob.jobConfig.startPosition.direction)
end

local function getJob()
  local sModemSide = nil
  for n,sSide in ipairs( rs.getSides() ) do
    if peripheral.getType( sSide ) == "modem" and peripheral.call( sSide, "isWireless" ) then	
      sModemSide = sSide
      break
    end
  end

  if sModemSide == nil then
    print( "No wireless modems found. 1 required." )
    return
  end
  local modem = peripheral.wrap( sModemSide )
  -- end from gps --
  
  modem.open(os.getComputerID())

  local oJobRequest = {workerPosition = {x = position.x, y = position.y, z = position.z, direction = position.direction}}
  modem.transmit(tConfig.nChannel, os.getComputerID(), oJobRequest)

  local timeout = os.startTimer(5)

  while true do 
    local e, p1, p2, p3, p4, p5 = os.pullEvent()
    
    if e == "modem_message" then 
      local sSide, sChannel, sReplyChannel, tMessage, nDistance = p1, p2, p3, p4, p5
      
      if sSide == sModemSide and sChannel == os.getComputerID() and type(tMessage) == 'table' then 
        modem.close(os.getComputerID())
        return tMessage
      end
    elseif e == "timer" then
      local timer = p1
      
      if timer == timeout then 
        modem.close(os.getComputerID())
        return nil 
      end
    end
  end
end

tConfig = common.unserializeFromFile('mo_worker.dat', tConfig)

print('This depends on our position being relative from the overseer!')
print('What channel should I use to talk to the overseer? (' .. tConfig.nChannel .. ')')
tConfig.nChannel = io.readNum(tConfig.nChannel)

print('x-position to go when dumping inventory? (' .. tConfig.tChestDumpLocation.x .. ')')
tConfig.tChestDumpLocation.x = io.readNum(tConfig.tChestDumpLocation.x)

print('y-position to go when dumping inventory? (' .. tConfig.tChestDumpLocation.y .. ')')
tConfig.tChestDumpLocation.y = io.readNum(tConfig.tChestDumpLocation.y)

print('z-position to go when dumping inventory? (' .. tConfig.tChestDumpLocation.z .. ')')
tConfig.tChestDumpLocation.z = io.readNum(tConfig.tChestDumpLocation.z)

print('direction to face when dumping inventory? (' .. tConfig.sChestDumpFace .. ')')
tConfig.sChestDumpFace = io.readStr(tConfig.sChestDumpFace)

print('dump direction? front, up, or down. (' .. tConfig.sChestDumpFunction .. ')')
tConfig.sChestDumpFunction = io.readStr(tConfig.sChestDumpFunction)

print('order start -> chest? (' .. tConfig.sOrderStartToChest .. ')')
tConfig.sOrderStartToChest = io.readStr(tConfig.sOrderStartToChest)

print('order start -> job? (' .. tConfig.sOrderStartToJob .. ')')
tConfig.sOrderStartToJob = io.readStr(tConfig.sOrderStartToJob)

print('order chest -> start? (' .. tConfig.sOrderChestToStart .. ')')
tConfig.sOrderChestToStart = io.readStr(tConfig.sOrderChestToStart)

print('order chest -> job? (' .. tConfig.sOrderChestToJob .. ')')
tConfig.sOrderChestToJob = io.readStr(tConfig.sOrderChestToJob)

print('order job -> start? (' .. tConfig.sOrderJobToStart .. ')')
tConfig.sOrderJobToStart = io.readStr(tConfig.sOrderJobToStart) 

print('order job -> chest? (' .. tConfig.sOrderJobToChest .. ')')
tConfig.sOrderJobToChest = io.readStr(tConfig.sOrderJobToChest)

print('order job -> job? (' .. tConfig.sOrderJobToJob .. ')')
tConfig.sOrderJobToJob = io.readStr(tConfig.sOrderJobToJob)

common.serializeToFile('mo_worker.dat', tConfig)

tConfigTemp.nChestDumpFace = getNumberDirectionFromString(tConfig.sChestDumpFace)
tConfigTemp.fChestDumpFunction = getDropFunctionFromString(tConfig.sChestDumpFunction)

tConfig.tStartPosition = {x = position.x, y = position.y, z = position.z, direction = position.direction}
while true do 
  print 'Fetching job...'
  local oJob = getJob() 
  
  if not oJob then 
    print 'Failed to fetch a job. Make sure the overseer is running and try again..'
    break
  end 
  
  if oJob.jobId == mo.JOB_TYPE_NO_MORE_JOBS then 
    print 'We were told there are no more jobs.'
    break 
  elseif oJob.jobId == mo.JOB_TYPE_TUNNEL then 
    print('Got a tunnel job @ ' .. textutils.serialize(oJob.jobConfig.startPosition))
    handleTunnelJob(oJob)
    print 'Done!'
  end    
end 

pathfinding.goto(tConfig.tChestDumpLocation.x, tConfig.tChestDumpLocation.y, tConfig.tChestDumpLocation.z)
move.face(tConfigTemp.nChestDumpFace)
inventory.dumpInventory(nil, nil, tConfigTemp.fChestDumpFunction)
pathfinding.goto(tConfig.tStartPosition.x, tConfig.tStartPosition.y, tConfig.tStartPosition.z)
move.face(otConfig.tStartPosition.direction)