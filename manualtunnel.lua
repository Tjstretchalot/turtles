dofile('tunnel.lua')

if position.x ~= 0 or position.y ~= 0 or position.z ~= 0 or position.dir ~= position.NORTH then
	print('Reset old position information?')
	print('  0 - No, pretend I did not notice that (WARNING: unpredictable)')
	print('  1 - Yes, delete old position information')
	print('  2 - No, but take me back to 0, 0, 0 and face north.')
	local choice = tonumber(io.read())
	
	if choice == 1 then
		position.forget()
	elseif choice == 2 then
		pathfinding.goto(0, 0, 0)
		move.face(position.NORTH)
	elseif choice ~= 0 then
		return
	end
end

print('How wide? (turtle is currently in the center, ties broken to the left)')
local width = tonumber(io.read())
print('How tall?')
local height = tonumber(io.read())
print('How long?')
local length = tonumber(io.read())
print('Come back afterward?')
print('  0 - No, just shut down after I am done')
print('  1 - Yes, return to 0, 0, 0 and face north after I am done')
local comeback = tonumber(io.read())


tunnel.doTunnel(width, height, length)
if comeback then
	pathfinding.goto(0, 0, 0)
	move.face(position.NORTH)
end