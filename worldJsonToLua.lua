-- read and change world files (required by the mapSearchInput module)
local worldJsonToLuaT = {}

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local worldFileExists = false
local worldFileName = nil

function worldJsonToLuaT.getWorldNamesFromMain(worldNamesList)
  for i, j in ipairs(worldNamesList) do
    --print("world num = " .. i, "imported world name = " .. j)
    groupworldJsonToLuaCall(j) --pass world names to func
  end
end

function groupworldJsonToLuaCall(worldNamesListP)
  worldJsonToLuaT.getTextContent(worldNamesListP)
  worldJsonToLuaT.compareAndSubstituteStrings()
  worldJsonToLuaT.removeQuotes()
  worldJsonToLuaT.addReturnString(worldNamesListP)
  worldJsonToLuaT.writeToWorldTextData(worldNamesListP)
end

-----------------------------------------------------------------------------------------------------

-- read the world json file of tiled and return his content as a string
function worldJsonToLuaT.readAllWorldFileAndReturn(file)
  local f = assert(io.open(file, "rb")) -- rb  arg mean read bytes and wb means write bytes
  local content = f:read("*all")
  f:close()
  return content
end

local TextContent = nil
function worldJsonToLuaT.getTextContent(worldNamesListP)
  TextContent = worldJsonToLuaT.readAllWorldFileAndReturn("tiledFiles/" .. worldNamesListP .. ".world") -- read world json (.world) in the good directory
end

local stringsToReplaceT = {"%:", "%[", "%]", "tmx"} -- json strings to replace in good order
local replaceStringsWith = {"=", "{", "}", "lua"} -- lua strings replacements in good order

function worldJsonToLuaT.compareAndSubstituteStrings()  
  for k, v in ipairs(stringsToReplaceT) do
    for i, j in ipairs(replaceStringsWith) do
      if k == i then -- if stringsToReplaceT index = replaceStringsWith index then
        --reuse TextContent and alter it each time k = i
        TextContent = string.gsub(TextContent, v, j)
      end
    end
  end
end  

function worldJsonToLuaT.removeQuotes()
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

function worldJsonToLuaT.addReturnString(worldDataP)
  local intitiateData = io.open( "worldData\\" .. worldDataP .. ".lua","w")
  intitiateData:write("return ")
  intitiateData:close()
end

local worldJsonToLua = nil

function worldJsonToLuaT.writeToWorldTextData(worldDataP) -- write the lua code in the worldTextData.lua
  worldJsonToLua = io.open( "worldData\\" .. worldDataP .. ".lua","a") -- append textContent to return
  worldJsonToLua:write(TextContent)
  worldJsonToLua:close() --dont forget to close or accessing the worldTextData module will make a boolean error
end

return worldJsonToLuaT