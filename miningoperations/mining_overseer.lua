dofile('mo_common.lua')
dofile('position.lua')
----
-- mining_overseer.lua
--
-- The entry file to the overseer program for a long hallway that should
-- be efficiently mined out.
--
-- The overseer is a computer or turtle with a wireless modem with atleast as much
-- range as the tunnel infront of it that will be mined on the left and the right.
--
-- The overseer registers on the mo.CHANNEL_MO modem channel number and listens for 
-- workers to make job requests. The overseer then has each turtle mine a 1x1x100 tunnel 
-- with 3 blocks in between tunnels, with each tunnel 1 block higher than the starting position
-- of the overseer.
--
-- Setup requires that an overseer be facing into a 3-wide, 3-tall, configurably-long tunnel.
-- The overseer is in the middle block, one up from the floor.
-- The overseer then runs mining_overseer.lua
-- Workers are then placed 1 at a time, and run worker.lua.
-- Those workers will then go off and make a tunnel, until there are no more tunnels at z=-1, -5,...,tunnel length
-- The workers will then stop at the ends of their last tunnels.
----

local config = {
  tunnelLength = 100
}

config = common.unserializeFromFile('mining_overseer.dat', config)

local progress = 0

local function totalNumberOfTunnels() 
  -- Calculates the total number of tunnels. If the tunnel length is 1-4, there would be
  -- 2 tunnels. 5-8 is 4 tunnels, 9-12 is 6 tunnels, etc. In general, there is 
  -- floor((tunnelLength - 1)/4)*2 + 2 tunnels. This assumes that the tunnel length is greater than 0.
  --
  -- Examples:
  -- tunnelLength = 1
  -- floor((1-1) / 4)*2 + 2 = floor(0)*2 + 2 = 2
  --
  -- tunnelLength=7
  -- floor(7-1) / 4)*2 + 2 = floor(6/4)*2 + 2 = floor(1.5)*2 + 2 = 2 + 2 = 4
  
  return math.floor((config.tunnelLength-1) / 4)*2 + 2
end

local function getNextTunnel() 
  -- "progress" is the number of tunnels so far. getNextTunnel simply 
  -- increments progress and returns it, unless we have already done all 
  -- of the tunnels, in which case we return nil 
  
  if progress == totalNumberOfTunnels() then 
    return nil
  end
  
  progress = progress + 1
  return progress
end

local function getTunnelLocation(tunnel) 
  -- "tunnel" is the number of the tunnel. This first decides if its on the left 
  -- (odd numbers) or right (even numbers), and how deep (in number of tunnels)
  -- the tunnel is. Then, it multiplies the deepness in number of tunnels by 4 and
  -- adds one to get the actual negative z, and returns (left then west 1, right then east 1, 1, z)
  
  tunnel = tunnel - 1
  local left = (tunnel % 2) == 0
  local depthInTunnels = math.floor(tunnel / 2)
  
  local x = position.getOffsetForDir(position.WEST).x
  local dir = position.WEST
  if not left then 
    x = position.getOffsetForDir(position.EAST).x
    dir = position.EAST
  end
  
  local z = -(depthInTunnels * 4 + 1)
  
  return {x = x, y = 1, z = z, direction = dir}
end

-- from gps --
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

    
print('Tunnel Length (in blocks) in front of me? (' .. config.tunnelLength ..')');
config.tunnelLength = io.readNum(config.tunnelLength)

print('Progress so far? (' .. progress .. ')')
progress = io.readNum(progress)

common.serializeToFile('mining_overseer.dat', config)

print( "Opening channel " .. mo.CHANNEL_MO .. " on side " .. sModemSide)
modem.open(mo.CHANNEL_MO)
while true do
  local e, p1, p2, p3, p4, p5 = os.pullEvent("modem_message")
  
  if e == "modem_message" then 
    local sSide, sChannel, sReplyChannel, tMessage, nDistance = p1, p2, p3, p4, p5
    
    if sSide == sModemSide and sChannel == mo.CHANNEL_MO and type(tMessage) == 'table' then
      
      -- We don't actually care about their position for this overseer --
      
      local oJob = {jobId = mo.JOB_TYPE_NO_MORE_JOBS, jobDescription = 'No more jobs available!', jobConfig = {}}
      
      local nNextTunnelNum = getNextTunnel()  
      if nNextTunnelNum then 
        print('Sending turtle ' .. sReplyChannel .. ' to perform tunnel #' .. nNextTunnelNum)
        oJob = {jobId = mo.JOB_TYPE_TUNNEL, jobDescription = 'Get some resources!', jobConfig = {
          startPosition = getTunnelLocation(nNextTunnelNum),
          width = 1,
          height = 1,
          length = 100,
          mineResources = true,
          placeFloor = false
        }}
      end
      
      modem.transmit(sReplyChannel, mo.CHANNEL_MO, oJob)
    end
  end
end
