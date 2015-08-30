-- Rename to startup to have the turtle return home on reboot

dofile('pathfinding.lua')

pathfinding.goto(0,0,0)
move.face(position.NORTH)