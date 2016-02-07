-- Mining Operations - Common File --

----
-- This file imports common files, contains common constants and functions
-- for the overseer and the worker to communicate. Everything is wrapped in the "mo" object,
-- which stands for "miningoperations"
----

if mo then return end
mo = {}

-- Imports
dofile('common.lua')

-- Constants

----
-- Indicates that there are no more jobs available from the overseer, and the worker should act
-- accordingly
--
-- Configuration:
-- {
-- }
----

mo.CHANNEL_MO = 12765

mo.JOB_TYPE_NO_MORE_JOBS = 0

----
-- Indicates that the worker should create a tunnel.
--
-- Configuration:
-- {
--   startPosition: {
--     x: 0,
--     y: 0,
--     z: 0,
--     direction: position.NORTH
--   },
--   width: 1,
--   height: 1,
--   length: 100,
--   mineResources: true,
--   placeFloor: false
-- }
----
mo.JOB_TYPE_TUNNEL = 1

-- Functions