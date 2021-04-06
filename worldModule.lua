-- read and change world files (required by the mapSearchInput module)
local worldTable = {}

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local worldFileExists = false
local worldFileName = nil

function worldTable.getWorldNamesFromMain(worldNamesList)
  for i, j in ipairs(worldNamesList) do
    --print("world num = " .. i, "imported world name = " .. j)
    groupWorldModuleCall(j) --pass world names to func
  end
end

function groupWorldModuleCall(worldNamesListP)
  worldTable.getTextContent(worldNamesListP)
  worldTable.compareAndSubstituteStrings()
  worldTable.removeQuotes()
  worldTable.addReturnString(worldNamesListP)
  worldTable.writeToWorldTextData(worldNamesListP)
  worldTable.ifWorldBrowseMapsAndCreateWorldContainer(worldNamesListP)
end

-----------------------------------------------------------------------------------------------------

-- read the world json file of tiled and return his content as a string
function worldTable.readAllWorldFileAndReturn(file)
  local f = assert(io.open(file, "rb")) -- rb  arg mean read bytes and wb means write bytes
  local content = f:read("*all")
  f:close()
  return content
end

local TextContent = nil
function worldTable.getTextContent(worldNamesListP)
  TextContent = worldTable.readAllWorldFileAndReturn("tiledFiles/" .. worldNamesListP .. ".world") -- read world json (.world) in the good directory
end

local stringsToReplaceT = {"%:", "%[", "%]", "tmx"} -- json strings to replace in good order
local replaceStringsWith = {"=", "{", "}", "lua"} -- lua strings replacements in good order

function worldTable.compareAndSubstituteStrings()  
  for k, v in ipairs(stringsToReplaceT) do
    for i, j in ipairs(replaceStringsWith) do
      if k == i then -- if stringsToReplaceT index = replaceStringsWith index then
        --reuse TextContent and alter it each time k = i
        TextContent = string.gsub(TextContent, v, j)
      end
    end
  end
end  

function worldTable.removeQuotes()
  local removeVarQuotes = {"maps", "onlyShowAdjacentMaps", "type", "fileName", "height", "width", "x", "y"}
  for k, v in ipairs(removeVarQuotes) do
    match = '"' ..v .. '"'
    TextContent = string.gsub(TextContent, match, v .. " ")
  end
  local removePatternVarQuotes = {"patterns", "regexp", "multiplierX", "multiplierY", "offsetX", "offsetY"} -- lua is not compatible with POSIX regexp !!
  for k, v in ipairs(removePatternVarQuotes) do
    match = '"' ..v .. '"'
    TextContent = string.gsub(TextContent, match, v .. " ")
  end
end

------------------------------------------------------------------------------------------
--Create world.lua file(s) and write text content into it.

function worldTable.addReturnString(worldDataP)
  local intitiateData = io.open( "worldData\\" .. worldDataP .. ".lua","w")
  intitiateData:write("return ")
  intitiateData:close()
end

local worldJsonToLua = nil

function worldTable.writeToWorldTextData(worldDataP) -- write the lua code in the worldTextData.lua
  worldJsonToLua = io.open( "worldData\\" .. worldDataP .. ".lua","a") -- append textContent to return
  worldJsonToLua:write(TextContent)
  worldJsonToLua:close() --dont forget to close or accessing the worldTextData module will make a boolean error
end

-----------------------------------------------------------------------------------------------------
local MAPSFROMWORLD = {}

local worldContainerId = 0
local requireWorldData = {}
function worldTable.ifWorldBrowseMapsAndCreateWorldContainer(worldFileName)
  worldContainerId = worldContainerId + 1
  MAPSFROMWORLD[worldContainerId] = {}
  requireWorldData[worldContainerId] = require("worldData" .. "/" .. worldFileName)
  for i, j in ipairs(requireWorldData[worldContainerId].maps) do
    checkIfMapsExistsAndRequire(i, j) 
  end  
end

function checkIfMapsExistsAndRequire(mapNum, mapVal)
  if love.filesystem.getInfo("lua_maps/" .. mapVal.fileName) then
    local tempFileName = string.gsub(mapVal.fileName, "%.lua", "")
    MAPSFROMWORLD[worldContainerId][mapNum] = require("lua_maps." .. tempFileName) --require("lua_maps.map_1") (instead of require("lua_maps/map_1") cause module structure is only a return)
  end
end

function worldTable.returnWorldMapsToMain()
  return MAPSFROMWORLD
end

------------------------------------------------------------------------------------------------------------
local scrXBy4 = screenWidth / 4
function worldTable.drawIfMapsAreLoaded()
  for m, n in ipairs(requireWorldData) do
    for i, j in ipairs(n.maps) do
      if love.filesystem.getInfo("lua_maps/" .. j.fileName) then
        love.graphics.print("----------------------------", (m * scrXBy4) - scrXBy4, screenHeight / 15)
        love.graphics.print("world = " .. m .. " /loaded", (m * scrXBy4) - scrXBy4, screenHeight / 12)
        love.graphics.print("----------------------------", (m * scrXBy4) - scrXBy4, screenHeight / 10)
        love.graphics.print("map = " .. j.fileName, (m * scrXBy4) - scrXBy4, screenHeight / 10 + (20 * i) )
        love.graphics.rectangle("line", 0, 0, screenWidth / 2, screenHeight / 5 + (20 * i))
      else
        love.graphics.setColor(1,0,0)
        love.graphics.print(j.fileName .." / map is missing from lua_maps folder !\n" .. "it exists in the world " .. m .. " file.", 200, 180 + (40 * m * i))
        print(m)
      end
    end  
  end 
  love.graphics.setColor(1,1,1)
end

return worldTable