--main file linker
local mainLinkerT = {}

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local defaultFont = love.graphics.newFont()
local bigFont = love.graphics.newFont(32)

local uiButtonsTable = nil
local worldFileSearchMod = require("worldFileSearch") --search for world files (very first thing to check)

local worldModuleCall = nil
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
local CHOOSEWORLD = nil

function importWorldNamesInMain()
  worldNamesImport = worldFileSearchMod.returnWorldNames()
  if worldNamesImport == nil then
    print("there is no world imported in main from the world search module !!")
  else
    worldModuleCall = require("worldModule") -- call world module when world files were found in world file search module
    worldModuleCall.getWorldNamesFromMain(worldNamesImport) --pass world names to the world module
    MAPSFROMWORLDTOMAIN = worldModuleCall.returnWorldMapsToMain() -- get map files from the world module
  end
end

function prepareTiledToLoveAndInjectWorldDataIntoMapFiles()
  tiledToLoveMod = require("tiledToLove")
  local worldDataRequire = nil
  -- catch world names
  for n, o in ipairs(worldNamesImport) do
    if love.filesystem.getInfo("worldData" .. "/" .. o .. ".lua") then -- check if world data lua module exists
      worldDataRequire = require("worldData" .. "/" .. o) -- require lua world files content into worldData folder.
      for l, m in ipairs(worldDataRequire.maps) do
        if love.filesystem.getInfo("lua_maps" .. "/" .. m.fileName) then -- check if map exists
          -- injects world number and map position into the tiled map file.
          MAPSFROMWORLDTOMAIN[n][l].worldNumber = n
          MAPSFROMWORLDTOMAIN[n][l].worldName = o
          MAPSFROMWORLDTOMAIN[n][l].mapNumber = l
          MAPSFROMWORLDTOMAIN[n][l].mapOnWorldPosX = m.x -- injects the world x coordinates into the tiled map
          MAPSFROMWORLDTOMAIN[n][l].mapOnWorldPosY = m.y
        else 
          print(m.fileName, "is missing in lua_maps folder!")
        end
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
  prepareTiledToLoveAndInjectWorldDataIntoMapFiles() -- is requiring tiledToLove too.
  -- create buttons
  uiButtonsTable.createUiButtonsOnce(MAPSFROMWORLDTOMAIN) -- after world is loaded
  -- import quads and imagelist from tiledToLove
  local quadsImportFromTiled, imageListFromTiled = tiledToLoveMod.exportQuadsAndImageListFromTiledToMain()
  tiledToLoveMod.declareAnimTimer()
  
  collisionTestMod = require("collisionTest") 
end

function love.update(dt)
  
  if dt > 0.035 then -- if we move the window, the game freezes while collisions are off.
    return 
  end 
  
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
    tiledToLoveMod.drawTiled(CHOOSEWORLD, fakeWorldX, fakeWorldY, playerOffsetX, playerOffsetY)
    love.graphics.scale(1, 1)
  elseif mainState.state == stateMachine.worldEditMode then
    worldFileSearchMod.drawFileBrowserResults()
    worldModuleCall.drawIfMapsAreLoaded()
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

local MODIFIEDMAPS = {}

function love.mousepressed(x, y, MouseButton, istouch)
  if MouseButton == 1 then
    if mainState.state == stateMachine.gameMode then
      uiButtonsTable.mousePressedInUiCall(x, y, mainState.state)
    elseif mainState.state == stateMachine.worldEditMode then
      -- world edit button restart
      if uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "reloadLove2d" then
        love.event.quit( "restart" )
      -- world choosing buttons ------------------------------------------------------------------------
      elseif uiButtonsTable.mousePressedInUiCall(x, y, mainState.state) == "checkboxChooseWorldToDraw" then
        local worldButtonType, worldButtonNum = uiButtonsTable.mousePressedInUiCall(x, y, mainState.state)
        print("choose World in main", worldButtonNum)
        CHOOSEWORLD = worldButtonNum -- set the world to draw as the button choosed in wordl editor inside UI module.
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
  