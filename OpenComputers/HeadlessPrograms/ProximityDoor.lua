--Proximity door by Gangsir
--To use, provide how long to stay open, and a list of acceptable entities for the door to open in args.
--ex: door 5 Gangsir dan200 Sangar
--requires a motion detector attached to the computer, and a redstone card.
--Headless, screen not needed after run

component = require("component")
motion = component.motion_sensor
redstone = component.redstone
sides = require("sides")
event = require("event")
motion.setSensitivity(0.2) --Sensitivity of mot dect

--change these to your liking, default is good, however
local range = 3 --distance away from motion sensor to check
local side = sides.top


local acceptableEntities = {...} --args
if type(tonumber(acceptableEntities[1])) ~= "number" then error("Please provide time for door to stay open as the first arg.") end
local stayOpen = tonumber(acceptableEntities[1])
if #acceptableEntities <= 1 then error("Someone needs to have access!") end
table.remove(acceptableEntities,1) --remove time from list of entities

--add list of players to lookup list
players = {}
for _,name in pairs(acceptableEntities) do
  if type(tostring(name)) ~= "string" then error("Please provide entity names only.") end --sanity check
  players[tostring(name)] = true
end

while true do
  redstone.setOutput(side,0)
  local _,_,x,y,z,entity = event.pull("motion")
  if math.abs(x)<= tonumber(range) and math.abs(y)<= tonumber(range) and math.abs(z)<= tonumber(range) then --if recieved motion was within range
    if players[tostring(entity)] then --if entity is on whitelist
      redstone.setOutput(side,15)
      os.sleep(stayOpen)
      redstone.setOutput(side,0)
    end
  end
end
--eof
