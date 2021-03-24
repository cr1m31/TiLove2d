--UI design table
local UI = {}

local screenWidthUI = love.graphics.getWidth()
local screenHeightUI = love.graphics.getHeight()

-- BUTTONS ----------------------------------------------------------------------------------
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

--UI.createButton(button Type, width, height, x pos, y pos, name, game state)
local worldListNum = {}
function UI.createUiButtonsOnce(worldAndMapsFromMain)
  --worlds menu buttons ----------------------------------------------------------------------------
  UI.createButton("reloadLove2d", 70, 20, screenWidthUI / 3, 150, "Reload game", "worldEditMode")
  -- checkboxes for world selection ------------
  -- world editor checkboxes
  for worldNum, worldVal in ipairs(worldAndMapsFromMain) do -- for each world create a button
    worldListNum[worldNum] = {}
    UI.createButton("checkboxChooseWorldToDraw", 30, 30, screenWidthUI / 2, 140 + (worldNum * 50), "Choose world", "worldEditMode")
    worldAndMapsFromMain = nil
  end
  
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
        elseif UIObjects.type == "checkboxChooseWorldToDraw" then
          return UIObjects.type
        end
      end
    end
  end
end

return UI