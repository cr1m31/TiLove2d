-- world loader module
local worldAndMapsLoaderT = {}

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local MAPSFROMWORLD = {} -- clear map data each time we call this module

local requireWorldData = {}
local worldContainerId = 0
local worldFileNameSelector = nil
function worldAndMapsLoaderT.ifWorldBrowseMapsAndCreateWorldContainer()
  requireWorldData[1] = require("worldData" .. "/" .. worldFileNameSelector)
  for i, j in ipairs(requireWorldData[1].maps) do
    checkIfMapsExistsAndRequire(i, j) 
  end 
end

function populateMapsFromWorld()
  MAPSFROMWORLD[1] = {}
end

function checkIfMapsExistsAndRequire(mapNum, mapVal)
  if love.filesystem.getInfo("lua_maps/" .. mapVal.fileName) then
    local tempFileName = string.gsub(mapVal.fileName, "%.lua", "")
    MAPSFROMWORLD[1][mapNum] = require("lua_maps." .. tempFileName) --require("lua_maps.map_1") (instead of require("lua_maps/map_1") cause module structure is only a return)
  end
end

function worldAndMapsLoaderT.passWorldNamesToMapsLoaderFromMain(worldNamesImport, choosedWorld)
  worldFileNameSelector = worldNamesImport[choosedWorld]
  populateMapsFromWorld()
  worldAndMapsLoaderT.ifWorldBrowseMapsAndCreateWorldContainer()
end

function worldAndMapsLoaderT.returnWorldMapsToMain() 
  return MAPSFROMWORLD, worldFileNameSelector -- return loaded maps and selected world name 
end

-- clear maps form memory
function worldAndMapsLoaderT.clearMapsData()
  table.remove(MAPSFROMWORLD, 1)
end
------------------------------------------------------------------------------------------------------------
local screenWidthOffset = 3
local screenHeightOffset = 3
function worldAndMapsLoaderT.drawIfMapsAreLoaded()
  for m, n in ipairs(requireWorldData) do
    for i, j in ipairs(n.maps) do
      if love.filesystem.getInfo("lua_maps/" .. j.fileName) then
        love.graphics.print("----------------------------", screenWidth / screenWidthOffset, screenHeight / screenHeightOffset)
        love.graphics.print("map = " .. j.fileName, screenWidth / screenWidthOffset, screenHeight / screenHeightOffset + (20 * i) )
        love.graphics.print("----------------------------", screenWidth / screenWidthOffset, screenHeight / screenHeightOffset)
      else
        love.graphics.setColor(1,0,0)
        love.graphics.print(j.fileName .." / map is missing from lua_maps folder !\n" .. "it exists in the world " .. m .. " file.", 200, 180 + (40 * m * i))
      end
    end  
  end 
  love.graphics.setColor(1,1,1)
end

return worldAndMapsLoaderT