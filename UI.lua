--UI design table
local UI = {}

local screenWidthUI = love.graphics.getWidth()
local screenHeightUI = love.graphics.getHeight()

-- menu BUTTONS ----------------------------------------------------------------------------------
UI.buttonsMenuList = {}

function UI.createButton(bType, w, h, x, y, name, state)
  UI.buttonsMenu = {}
  UI.buttonsMenu.image = love.graphics.newImage("images/UI/imgButton.png")
  UI.buttonsMenu.imageWidth = UI.buttonsMenu.image:getWidth()
  UI.buttonsMenu.imageHeight = UI.buttonsMenu.image:getHeight()
  UI.buttonsMenu.imagePressed = love.graphics.newImage("images/UI/imgButtonPressed.png")
  UI.buttonsMenu.type = bType
  UI.buttonsMenu.width = w
  UI.buttonsMenu.height = h
  UI.buttonsMenu.x = x
  UI.buttonsMenu.y = y
  UI.buttonsMenu.name = name
  UI.buttonsMenu.state = state
  
  table.insert(UI.buttonsMenuList, UI.buttonsMenu)
  return UI.buttonsMenu
end

-- create buttons for each world
UI.forEachWorldButtonsList = {}

function UI.createButtonForEachWorld(bType, w, h, x, y, name, state)
  UI.forEachWorldButtons = {}
  UI.forEachWorldButtons.image = love.graphics.newImage("images/UI/imgButton.png")
  UI.forEachWorldButtons.imageWidth = UI.forEachWorldButtons.image:getWidth()
  UI.forEachWorldButtons.imageHeight = UI.forEachWorldButtons.image:getHeight()
  UI.forEachWorldButtons.imagePressed = love.graphics.newImage("images/UI/imgButtonPressed.png")
  UI.forEachWorldButtons.type = bType
  UI.forEachWorldButtons.width = w
  UI.forEachWorldButtons.height = h
  UI.forEachWorldButtons.x = x
  UI.forEachWorldButtons.y = y
  UI.forEachWorldButtons.name = name
  UI.forEachWorldButtons.state = state
  
  table.insert(UI.forEachWorldButtonsList, UI.forEachWorldButtons)
  return UI.forEachWorldButtons
end

-- create buttons for each map
UI.forEachWorldButtonsList.maps = {}

function UI.createButtonForEachMap(bType, w, h, x, y, name, state)
  UI.forEachMapButtons = {}
  UI.forEachMapButtons.image = love.graphics.newImage("images/UI/imgButton.png")
  UI.forEachMapButtons.imageWidth = UI.forEachMapButtons.image:getWidth()
  UI.forEachMapButtons.imageHeight = UI.forEachMapButtons.image:getHeight()
  UI.forEachMapButtons.imagePressed = love.graphics.newImage("images/UI/imgButtonPressed.png")
  UI.forEachMapButtons.type = bType
  UI.forEachMapButtons.width = w
  UI.forEachMapButtons.height = h
  UI.forEachMapButtons.x = x
  UI.forEachMapButtons.y = y
  UI.forEachMapButtons.name = name
  UI.forEachMapButtons.state = state
  
  table.insert(UI.forEachWorldButtonsList.maps, UI.forEachMapButtons)
  return UI.forEachMapButtons
end

--UI.createButton(button Type, width, height, x pos, y pos, name, game state)

local worldNames = {}
local mapNames = {}
function UI.createUiButtonsOnce(worldAndMapsFromMain)
  --worlds menu buttons ----------------------------------------------------------------------------
  UI.createButton("reloadLove2d", 70, 20, screenWidthUI / 3, 150, "Reload game", "worldEditMode")
  -- checkboxes for world selection ------------
  -- world editor checkboxes
  for worldNum, worldVal in ipairs(worldAndMapsFromMain) do -- for each world create a button
    UI.createButtonForEachWorld("checkboxChooseWorldToDraw", 30, 30, screenWidthUI / 3, 240 + (worldNum * 50), "Choose world: ", "worldEditMode")
    for mapNum, mapVal in ipairs(worldVal) do
      UI.createButtonForEachMap("checkboxChooseMapToDraw", 30, 20, screenWidthUI / 1.5, 140 + ((worldNum + mapNum) * 50), "Choose map: ", "worldEditMode")
      worldNames[worldNum] = worldAndMapsFromMain[worldNum][mapNum].worldName
      
      mapNames[worldNum] = worldAndMapsFromMain[worldNum][mapNum].mapName
      
    end
  end
  worldAndMapsFromMain = nil
  
  --game menu buttons ------------------------------------------------------------------------------
  UI.createButton("buttonWorldMenuOpen", 70, 30, screenWidthUI / 3, 300, "World editor", "menuMode") --open map editor
  UI.createButton("buttonResumeGame", 90, 40, screenWidthUI / 3, 80, "Resume game", "menuMode")
  UI.createButton("buttonExitGame", 90, 40, screenWidthUI / 3, 180, "Exit Game", "menuMode")
end

function UI.drawButtons(state)
  for i, j in ipairs(UI.buttonsMenuList) do
    if j.state == state then
      love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      love.graphics.print(j.name, j.x, j.y - j.height)
    end
  end
end

-- draw buttons for each world
function UI.drawButtonsForEachWorld(state, chooseWorld)
  
  for chooseWButtonI = 1, #UI.forEachWorldButtonsList, 1 do
    local allWButtonsVal = UI.forEachWorldButtonsList[chooseWButtonI]
    
    local chooseWButtonVal = UI.forEachWorldButtonsList[chooseWorld]
    
    if allWButtonsVal.state == state then
      love.graphics.draw(allWButtonsVal.image, allWButtonsVal.x, allWButtonsVal.y, 0, allWButtonsVal.width / allWButtonsVal.imageWidth, allWButtonsVal.height / allWButtonsVal.imageHeight)
      love.graphics.print(allWButtonsVal.name .. worldNames[chooseWButtonI], allWButtonsVal.x, allWButtonsVal.y - (allWButtonsVal.height / 2))
    end
    if chooseWButtonVal == nil then
      
    else
      print(UI.forEachWorldButtonsList[1].name)
      for l, m in ipairs(chooseWButtonVal) do
        print("map button")
        
        if m.state == state then
          love.graphics.draw(m.image, m.x, m.y, 0, m.width / m.imageWidth, m.height / m.imageHeight)
          love.graphics.print(m.name .. mapNames[l], m.x, m.y - (m.height / 2))
        end    
      end
    end
  end
  
--  for i, j in ipairs(UI.forEachWorldButtonsList) do
    
--  end
end

---- draw buttons for each map
--function UI.drawButtonsForEachMap(state, chooseWorld)
--  for i, j in ipairs(UI.forEachMapButtonsList) do
--    if j.state == state then
--      love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
--      love.graphics.print(j.name .. mapNames[i], j.x, j.y - j.height)
--    end
--  end
--end


--mouse callbacks ------------------------------------------------------------------------------
function UI.mousePressedInUiCall(mousX, mousY, state)
  -- Buttons pressed ---------------------------------
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
  for i , UIObjects in ipairs(UI.forEachWorldButtonsList.maps) do
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

return UI