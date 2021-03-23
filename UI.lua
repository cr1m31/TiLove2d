--UI design table
local UI = {}

local screenWidthUI = love.graphics.getWidth()
local screenHeightUI = love.graphics.getHeight()

UI.buttonsMenuList = {}

function UI.createButton(bType)
  UI.buttonsMenu = {}
  UI.buttonsMenu.image = love.graphics.newImage("images/UI/imgButton.png")
  UI.buttonsMenu.imageWidth = UI.buttonsMenu.image:getWidth()
  UI.buttonsMenu.imageHeight = UI.buttonsMenu.image:getHeight()
  UI.buttonsMenu.imagePressed = love.graphics.newImage("images/UI/imgButtonPressed.png")
  UI.buttonsMenu.type = bType
  ---------------------------------------------------------------------
  --game menu
  if bType == "buttonResumeGame" then
    UI.buttonsMenu.name = "resumeGame"
    UI.buttonsMenu.width = 90
    UI.buttonsMenu.height = 40
    UI.buttonsMenu.x = (screenWidthUI / 3)
    UI.buttonsMenu.y = 80
    UI.buttonsMenu.state = "menuMode"
  elseif bType == "buttonExitGame" then
    UI.buttonsMenu.name = "exitGame"
    UI.buttonsMenu.width = 90
    UI.buttonsMenu.height = 40
    UI.buttonsMenu.x = (screenWidthUI / 3)
    UI.buttonsMenu.y = 180
    UI.buttonsMenu.state = "menuMode"
  elseif bType == "buttonWorldMenuOpen" then
    --open map editor
    UI.buttonsMenu.name = "worldEditor"
    UI.buttonsMenu.width = 70
    UI.buttonsMenu.height = 30
    UI.buttonsMenu.x = (screenWidthUI / 3)
    UI.buttonsMenu.y = 300
    UI.buttonsMenu.state = "menuMode"
  ---------------------------------------------------------------------
  --world menu
  
  elseif bType == "reloadLove2d" then  
    UI.buttonsMenu.width = 70
    UI.buttonsMenu.height = 20
    UI.buttonsMenu.x = (screenWidthUI / 3)
    UI.buttonsMenu.y = 150
    UI.buttonsMenu.name = "Reload game"
    UI.buttonsMenu.state = "worldEditMode"
  end
  table.insert(UI.buttonsMenuList, UI.buttonsMenu)
  return UI.buttonsMenu
end

function UI.createUiButtonsOnce()
  --worldsearch buttons
  UI.createButton("reloadLove2d")
  --game menu buttons
  UI.createButton("buttonWorldMenuOpen")
  UI.createButton("buttonResumeGame")
  UI.createButton("buttonExitGame")
end

function UI.drawButtons(state)
  local boxFrame = 1
  for i, j in ipairs(UI.buttonsMenuList) do
    if j.state == state then
      love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      love.graphics.print(j.name, j.x, j.y - j.height)
    end
  end
end

function UI.resumeGameMode()
  
end

--mouse callback
function UI.mousePressedInUiCall(mousX, mousY, state)
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
end

return UI