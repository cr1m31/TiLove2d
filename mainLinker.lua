--main file linker
local mainLinkerT = {}

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local defaultFont = love.graphics.newFont()
local bigFont = love.graphics.newFont(32)

local uiButtonsTable = nil
local worldFileSearchMod = require("worldFileSearch") --search for world files (very first thing to check)

local worldJsonToLuaCall = nil
local worldAndMapsLoaderMod = nil
local tiledToLoveMod = nil
local collisionTestMod = nil

local fakeWorldX = 0
local fakeWorldY = 0
local fakeWorldSpeed = 520

local playerOffsetX = 30 -- offset for animated tiles 
local playerOffsetY = 0

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function math.angle(x1,y1, x2,y2) 
  return math.atan2(y2-y1, x2-x1) 
end

local stateMachine = {}
stateMachine.worldEditMode = "worldEditMode"
stateMachine.menuMode = "menuMode"
stateMachine.gameMode = "gameMode"

local mainState = {}
mainState.state = stateMachine.worldEditMode

local MAPSFROMWORLDTOMAIN = {}
local worldNamesImport = {}
local CHOOSEWORLD = 1
local automaticMapsBool = false

function importWorldNamesInMain()
  worldNamesImport = worldFileSearchMod.returnWorldNames()
  if worldNamesImport == nil then
    print("there is no world imported in main from the world search module !!")
  else
    worldJsonToLuaCall = require("worldJsonToLua") -- call world module when world files were found in world file search module
    worldJsonToLuaCall.getWorldNamesFromMain(worldNamesImport) --pass world names to the world module
    for i, j in ipairs(worldNamesImport) do 
    end
  end
end

local activeWorldNameImport = nil
function reloadMapsData()
  MAPSFROMWORLDTOMAIN[1] = {}
  table.remove(MAPSFROMWORLDTOMAIN, 1) -- clear maps data
  
  worldAndMapsLoaderMod = require("worldAndMapsLoader")
  worldAndMapsLoaderMod.passWorldNamesToMapsLoaderFromMain(worldNamesImport, CHOOSEWORLD)
  
  MAPSFROMWORLDTOMAIN, activeWorldNameImport = worldAndMapsLoaderMod.returnWorldMapsToMain() -- get map files and world names from the world loader module 
  prepareTiledToLoveAndInjectWorldDataIntoMapFiles() -- is requiring tiledToLove too.
  
  for i, j in ipairs(MAPSFROMWORLDTOMAIN[1]) do
    print("map num = " .. i .. " posX = " .. j.mapOnWorldPosX, "posY = " .. j.mapOnWorldPosY)
  end
end

function prepareTiledToLoveAndInjectWorldDataIntoMapFiles()
  tiledToLoveMod = require("tiledToLove")
  local worldDataRequire = nil
  -- catch world names
  if love.filesystem.getInfo("worldData" .. "/" .. activeWorldNameImport .. ".lua") then -- check if world data lua module exists
    worldDataRequire = require("worldData" .. "/" .. activeWorldNameImport) -- require lua world files content into worldData folder.
    for l, m in ipairs(worldDataRequire.maps) do
      if love.filesystem.getInfo("lua_maps" .. "/" .. m.fileName) then -- check if map exists
        -- injects world number and map position into the tiled map file.
        MAPSFROMWORLDTOMAIN[1][l].mapOnWorldPosX = m.x -- injects the world x coordinates into the tiled map
        MAPSFROMWORLDTOMAIN[1][l].mapOnWorldPosY = m.y
      else 
        print(m.fileName, "is missing in lua_maps folder!")
      end
    end
  end
  tiledToLoveMod.passMainTilesetsToTiledToLove(MAPSFROMWORLDTOMAIN)
  tiledToLoveMod.imageListTable()
  tiledToLoveMod.loadTilesetImages()
  tiledToLoveMod.buildTilesetQuad()
end

function love.load() 
  uiButtonsTable = require("UI") --enable ui buttons
  
  worldFileSearchMod.createWorldDirectoryIfNil()
  worldFileSearchMod.loadFileBrowser()
  
  

  importWorldNamesInMain()
  reloadMapsData()
  
  -- create buttons
  uiButtonsTable.createUiButtonsOnce(worldNamesImport) -- after world is loaded
  
  tiledToLoveMod.declareAnimTimer()
  
  collisionTestMod = require("collisionTest") 
end

local mouseOneIsDown = false
local mouseX = nil
local mouseY = nil
function love.update(dt)
  
  if dt > 0.035 then -- if we move the window, the game freezes while collisions are off.
    return 
  end 
  
  -- check when mouse button is down
  mouseX = love.mouse.getX() 
  mouseY = love.mouse.getY() 
  if love.mouse.isDown(1) then
    mouseOneIsDown = true
  else
    mouseOneIsDown = false
  end
  uiButtonsTable.mouseButtonUpdate(mouseOneIsDown,mouseX,mouseY) --communicate to UI
  
  if mainState.state == stateMachine.gameMode then
    tiledToLoveMod.updateAnims(dt)
    if love.keyboard.isDown("d") then
      fakeWorldX = fakeWorldX - (fakeWorldSpeed * dt)
    end
    if love.keyboard.isDown("a") then
      fakeWorldX = fakeWorldX + (fakeWorldSpeed * dt)
    end
    if love.keyboard.isDown("w") then
      fakeWorldY = fakeWorldY + (fakeWorldSpeed * dt)
    end
    if love.keyboard.isDown("s") then
      fakeWorldY = fakeWorldY - (fakeWorldSpeed * dt)
    end
    
    collisionTestMod.collisionTilesTester(MAPSFROMWORLDTOMAIN, fakeWorldX, fakeWorldY, playerOffsetX, playerOffsetY) -- pass maps to collision tester
    
  elseif mainState.state == stateMachine.worldEditMode then
  elseif mainState.state == stateMachine.menuMode then
  end
--update end
end 

function love.draw()
  if mainState.state == stateMachine.gameMode then
    --tiledToLoveMod.drawLayerDataIndexes(fakeWorldX, fakeWorldY)
    love.graphics.scale(1, 1)  
    tiledToLoveMod.drawTiled(fakeWorldX, fakeWorldY, playerOffsetX, playerOffsetY)
    love.graphics.scale(1, 1)
  elseif mainState.state == stateMachine.worldEditMode then
    worldFileSearchMod.drawFileBrowserResults()
    worldAndMapsLoaderMod.drawIfMapsAreLoaded(MAPSFROMWORLDTOMAIN)
  elseif mainState.state == stateMachine.menuMode then
  end
  
  -- draw buttons
  uiButtonsTable.drawButtons(mainState.state) 
  -- draw buttons for each world
  uiButtonsTable.drawButtonsForEachWorld(mainState.state)
  
  love.graphics.setColor(1,1,0)
  love.graphics.print(mainState.state, screenWidth/ 1.2, 20)
  love.graphics.setColor(1,1,1)  
  --draw end
end

function love.keypressed(key)
  if mainState.state == stateMachine.gameMode then
    if key == "escape" then
      mainState.state = stateMachine.menuMode
    end
  elseif mainState.state == stateMachine.worldEditMode then
    if key == "escape" then
      mainState.state = stateMachine.menuMode
    end
  elseif mainState.state == stateMachine.menuMode then
    
  end
end

function love.mousepressed(x, y, MouseButton, istouch)
  if MouseButton == 1 then
    if mainState.state == stateMachine.gameMode then
      uiButtonsTable.mousePressedInUiCall(x, y, mainState.state)
    elseif mainState.state == stateMachine.worldEditMode then
      -- world edit button restart
      if uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "reloadLove2d" then
        love.event.quit( "restart" )
      -- automatic map mode load all maps of the active world
      elseif uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "automaticMapBuild" then
        automaticMapsBool = true
        print("auto maps")
      -- world choosing buttons ------------------------------------------------------------------------
      elseif uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "checkboxChooseWorldToDraw" then
       

        local worldButtonType, worldButtonNum = uiButtonsTable.mousePressedInUiCall(x, y, mainState.state)
        print("choose World in main", worldButtonNum)
        CHOOSEWORLD = worldButtonNum -- set the world to draw as the button choosed in wordl editor inside UI module.
        
        reloadMapsData() -- reload world and maps
        
        -- clear maps in worldJsonToLua (empty memory)
        worldAndMapsLoaderMod.clearMapsData()
      end
    elseif mainState.state == stateMachine.menuMode then
      if uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "buttonResumeGame" then
        mainState.state = stateMachine.gameMode
      elseif uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "buttonExitGame" then
        love.event.quit()
      elseif uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "buttonWorldMenuOpen" then
        mainState.state = stateMachine.worldEditMode
      end
    end
  elseif MouseButton == 2 then
  end
end

function love.wheelmoved(x, y)
  if mainState.state == stateMachine.gameMode then
  elseif mainState.state == stateMachine.worldEditMode then
  elseif mainState.state == stateMachine.menuMode then
  end
end

return mainLinkerT
  