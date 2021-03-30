--UI design table
local UI = {}

local screenWidthUI = love.graphics.getWidth()
local screenHeightUI = love.graphics.getHeight()

UI.buttonsMenuList = {}
UI.forEachWorldButtonsList = {}
UI.forEachMapButtonList = {}

-- (buttonList, bType, w, h, x, y, name, state) = (different table of buttons, type of button, width, height, x position, y position, name of the button, state = in which game state this button is active.)
function createDifferentButtons(buttonList, bType, w, h, x, y, name, state) -- button fabric
  button = {}
  button.image = love.graphics.newImage("images/UI/imgButton.png")
  button.imageWidth = button.image:getWidth()
  button.imageHeight = button.image:getHeight()
  button.imagePressed = love.graphics.newImage("images/UI/imgButtonPressed.png")
  button.type = bType
  button.width = w
  button.height = h
  button.x = x
  button.y = y
  button.name = name
  button.state = state
  
  table.insert(buttonList, button)
  return button
end

-- button settings ----------------------------------------------------------------------
local worldNames = {} -- just to get names and print them for button naming
local mapNames = {}
function UI.createUiButtonsOnce(worldAndMapsFromMain) -- button fabric control (called from main linker module)
  local buttonTypesList = {"reloadLove2d", "buttonWorldMenuOpen", "buttonResumeGame", "buttonExitGame", "checkboxChooseWorldToDraw", "checkboxChooseMapToDraw"} -- each button types
  local buttonXOffset = screenWidthUI / 4
for i, j in ipairs(buttonTypesList) do
  if j == "reloadLove2d" then
    createDifferentButtons(UI.buttonsMenuList, j, 70, 20, screenWidthUI / 3, 150, "Reload game", "worldEditMode")
  elseif j == "buttonWorldMenuOpen" then
    createDifferentButtons(UI.buttonsMenuList, j, 70, 30, screenWidthUI / 3, 300, "World editor", "menuMode")
  elseif j == "buttonResumeGame" then
   createDifferentButtons(UI.buttonsMenuList, j, 90, 40, screenWidthUI / 3, 80, "Resume game", "menuMode")
  elseif j == "buttonExitGame" then
    createDifferentButtons(UI.buttonsMenuList, j, 90, 40, screenWidthUI / 3, 180, "Exit Game", "menuMode")
  elseif j == "checkboxChooseWorldToDraw" then
    for worldNum, worldVal in ipairs(worldAndMapsFromMain) do
      createDifferentButtons(UI.forEachWorldButtonsList, j, 30, 30, (worldNum * buttonXOffset) - buttonXOffset, screenHeightUI / 2.8 + (worldNum * 50), "Choose world: ", "worldEditMode")
    end
  elseif j == "checkboxChooseMapToDraw" then
    for worldNum, worldVal in ipairs(worldAndMapsFromMain) do -- for each world create a button
      UI.forEachMapButtonList[worldNum] = {}
      mapNames[worldNum] = {}
      for mapNum, mapVal in ipairs(worldVal) do
        createDifferentButtons(UI.forEachMapButtonList[worldNum], j, 30, 20, (worldNum * buttonXOffset) - buttonXOffset, screenHeightUI / 2.2 + (worldNum * 50), "Choose map: ", "worldEditMode") -- for each map, create a button in a world index table.
        
        worldNames[worldNum] = worldAndMapsFromMain[worldNum][mapNum].worldName
        mapNames[worldNum][mapNum] = worldAndMapsFromMain[worldNum][mapNum].mapName
      end
    end
  end  
end
  worldAndMapsFromMain = nil
end

-- draw buttons --------------------------------------------------------------
function UI.drawButtons(state)
  for i, j in ipairs(UI.buttonsMenuList) do
    if j.state == state then
      love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      love.graphics.print(j.name, j.x, j.y - j.height)
    end
  end
end

-- draw buttons for each world
function UI.drawButtonsForEachWorld(state)
  for i, j in ipairs(UI.forEachWorldButtonsList) do
    if j.state == state then
      love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      love.graphics.setColor(0.78,0.48,0.25)
      love.graphics.print(j.name .. worldNames[i], j.x, j.y - (j.height / 2))
      love.graphics.setColor(1,1,1)
    end
  end
end

-- draw buttons for each map
function UI.drawButtonsForEachMap(state)
  for worldNum, worldMapVal in ipairs(UI.forEachMapButtonList) do
    for i, j in ipairs(worldMapVal) do
      if j.state == state then
        love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
        love.graphics.setColor(0.08,0.76,0.25)
        love.graphics.print(j.name .. mapNames[worldNum][i], j.x, j.y - (j.height / 1.2))
        love.graphics.setColor(1,1,1)
      end
    end
  end
end

--click buttons, mouse callbacks ------------------------------------------------------------------------------
function UI.mousePressedInUiCall(mousX, mousY, state)
  -- menu Buttons pressed ---------------------------------
  for i , UIObjects in ipairs(UI.buttonsMenuList) do
    if mousX < UIObjects.x + UIObjects.width and
    mousX > UIObjects.x and
    mousY < UIObjects.y + UIObjects.height and
    mousY > UIObjects.y 
    then
      if state == "menuMode" then
        if UIObjects.type == "buttonResumeGame" then
          return UIObjects.type
        elseif UIObjects.type == "buttonExitGame" then
          return UIObjects.type
        elseif UIObjects.type == "buttonWorldMenuOpen" then
          return UIObjects.type
        end
      elseif state == "worldEditMode" then
        if UIObjects.type == "reloadLove2d" then
          return UIObjects.type
        end
      end
    end
  end
  -- Buttons pressed for each world ---------------------------------
  for i , UIObjects in ipairs(UI.forEachWorldButtonsList) do
    if mousX < UIObjects.x + UIObjects.width and
    mousX > UIObjects.x and
    mousY < UIObjects.y + UIObjects.height and
    mousY > UIObjects.y 
    then
      if state == "worldEditMode" then
        if UIObjects.type == "checkboxChooseWorldToDraw" then
          return UIObjects.type, i
        end
      end
    end
  end
  -- Buttons pressed for each map ---------------------------------
  for worldNum, worldMapVal in ipairs(UI.forEachMapButtonList) do
    for i , UIObjects in ipairs(worldMapVal) do
      if mousX < UIObjects.x + UIObjects.width and
      mousX > UIObjects.x and
      mousY < UIObjects.y + UIObjects.height and
      mousY > UIObjects.y 
      then
        if state == "worldEditMode" then
          if UIObjects.type == "checkboxChooseMapToDraw" then
            return UIObjects.type, i
          end
        end
      end
    end
  end
end

return UI