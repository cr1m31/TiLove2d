-- map search
local worldSearchModule = {}

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local utf8 = require("utf8")
local importUI = require("UI")

function worldSearchModule.createWorldDirectoryIfNil()
  local info = love.filesystem.getInfo( "worldData", info )
  if info == nil then -- if the directory does'nt exist
    -- create this directory
    os.execute( "mkdir " .. "worldData")
  end
  local info2 = love.filesystem.getInfo( "tiledFiles", info2 )
  if info2 == nil then 
    os.execute( "mkdir " .. "tiledFiles")
  end
  local info3 = love.filesystem.getInfo( "lua_maps", info3 )
  if info3 == nil then 
    os.execute( "mkdir " .. "lua_maps")
  end
end

-- file browser functions
local filesString = nil

function worldSearchModule.loadFileBrowser()
  filesString = browseWorldJsonFiles("tiledFiles" .. "", "")
  removeWorldFileExtension()
end

local str = nil

function findWorldFileExtensionMatch(str)  --prevent listing other file formats than .world
  if string.find(str, "%.world") then
    return true
  else
    return false
  end
end

local worldFileNames = {}

function browseWorldJsonFiles(folder, fileTree) --not json file extension, .world extension
	local filesTable = love.filesystem.getDirectoryItems(folder)
	for i,v in ipairs(filesTable) do
    if findWorldFileExtensionMatch(v) then
      local file = folder.."/"..v
      if love.filesystem.getInfo(file) then
        fileTree = fileTree.."\n"..v
        table.insert(worldFileNames, v) --insert world file names here
      end
    elseif not findWorldFileExtensionMatch(v) then -- files that will be ignored when to load
      --print("not ok for " .. '"' .. v .. '"' .. " file, will be ignored")
    end
	end
	return fileTree
end

function removeWorldFileExtension()
  for i, j in ipairs(worldFileNames) do
    j = string.gsub(j, "%.world", "") --remove the .world file extension
    worldFileNames[i] = j --modify string on the fly
  end
end

function worldSearchModule.returnWorldNames()
  return worldFileNames
end

function worldSearchModule.drawFileBrowserResults()
  if #worldFileNames == 0 then
    love.graphics.print("no world file found !!", 10, 5)
  end
  for i, j in ipairs(worldFileNames) do
    if j == "" then
      love.graphics.print("world file name is an empty string !!", 10, 30)
    else
      love.graphics.print("    tiledFiles " .. "folder content = ")
      love.graphics.print("    " .. j .. ".world", 160, (i * 20) - 20 )
    end
  end
end

return worldSearchModule