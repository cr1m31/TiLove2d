--UI design table
local UI = {}

local screenWidthUI = love.graphics.getWidth()
local screenHeightUI = love.graphics.getHeight()

-- buttons load and create ---------------------------------------------------------------------
UI.buttonsMenuList = {}
UI.forEachWorldButtonsList = {}

-- (buttonList, bType, w, h, x, y, name, state) = (different table of buttons, type of button, width, height, x position, y position, name of the button, state = in which game state this button is active.)
function createDifferentButtons(buttonList, bType, w, h, x, y, name, state) -- button fabric
  button = {}
  button.image = love.graphics.newImage("images/UI/imgButton.png")
  button.imagePressed = love.graphics.newImage("images/UI/imgButtonPressed.png")
  button.isDownBool = false
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

local selectedMapNum = {}
--(buttonList, bType, w, h, x, y, name, state)
function UI.createUiButtonsOnce(worldAndMapsFromMain) -- button fabric control (called from main linker module)
  local buttonTypesList = {"reloadLove2d", "buttonWorldMenuOpen", "buttonResumeGame", "buttonExitGame", "checkboxChooseWorldToDraw", "automaticMapBuild"} -- each button types
  local buttonYOffset = screenHeightUI / 10
  
for i, j in ipairs(buttonTypesList) do
  if j == "reloadLove2d" then
    createDifferentButtons(UI.buttonsMenuList, j, 70, 20, screenWidthUI / 1.2, 80, "Reload game", "worldEditMode")
  elseif j == "automaticMapBuild" then
    createDifferentButtons(UI.buttonsMenuList, j, 70, 20, screenWidthUI / 1.5, 80, "Automatic maps", "worldEditMode")
  elseif j == "buttonWorldMenuOpen" then
    createDifferentButtons(UI.buttonsMenuList, j, 70, 30, screenWidthUI / 3, 300, "World editor", "menuMode")
  elseif j == "buttonResumeGame" then
   createDifferentButtons(UI.buttonsMenuList, j, 130, 50, screenWidthUI / 3, 80, "Resume game", "menuMode")
  elseif j == "buttonExitGame" then
    createDifferentButtons(UI.buttonsMenuList, j, 130, 50, screenWidthUI / 3, 180, "Exit Game", "menuMode")
  elseif j == "checkboxChooseWorldToDraw" then
    for worldNum, worldVal in ipairs(worldAndMapsFromMain) do
      createDifferentButtons(UI.forEachWorldButtonsList, j, 60, 30, 20, screenHeightUI / 2.8 + (worldNum * buttonYOffset) - buttonYOffset, "Choose world: ", "worldEditMode")
      worldNames[worldNum] = worldAndMapsFromMain[worldNum]
    end
  end
end
  worldAndMapsFromMain = nil
end

-- buttons and mouse update ---------------------------------------------------------
function AABBCollisions(x,y,b) -- also used for mouse callbacks at the end
  if x < b.x + b.width and
  x > b.x and
  y < b.y + b.height and
  y > b.y 
  then
    return true
  else
    return false
  end
end

function browseAllButtonsListUpdate(buttonList,x,y,mouseIsD) -- check mouse with button collision for any buttons list
  for i, j in ipairs(buttonList) do
    if mouseIsD and 
    AABBCollisions(x,y,j) then -- if mouse xy is colliding with any button in list and mouse button is down
      j.isDownBool = true -- this button is holded down
    elseif mouseIsD == false or AABBCollisions(x,y,j) == false then
      j.isDownBool = false
    end
  end
end

function UI.mouseButtonUpdate(mouseIsDownBool,x,y) -- get mouse info from mainlinker module
  browseAllButtonsListUpdate(UI.buttonsMenuList,x,y,mouseIsDownBool) -- call mouse collision for this buttons list
  browseAllButtonsListUpdate(UI.forEachWorldButtonsList,x,y,mouseIsDownBool)
end

-- draw buttons --------------------------------------------------------------
function UI.drawButtons(state)
  for i, j in ipairs(UI.buttonsMenuList) do
    if j.state == state then
      if j.isDownBool then -- if the button is down boolean is true, use the image of a pressed down button
        love.graphics.draw(j.imagePressed, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      else
        love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      end
      love.graphics.print(j.name, j.x, j.y - (j.height / 1.7))
    end
  end
end

-- draw buttons for each world
local selectedWorldNum = nil
function UI.drawButtonsForEachWorld(state)
  for i, j in ipairs(UI.forEachWorldButtonsList) do
    if j.state == state then
      if selectedWorldNum == i then -- when button is selected
        love.graphics.setColor(0.72,0.68,0.15)
      else
        love.graphics.setColor(1,1,1)
      end
      if j.isDownBool then -- button hold state
        love.graphics.draw(j.imagePressed, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      else
        love.graphics.draw(j.image, j.x, j.y, 0, j.width / j.imageWidth, j.height / j.imageHeight)
      end
      love.graphics.setColor(0.78,0.48,0.25)
      love.graphics.print(j.name .. worldNames[i], j.x, j.y - (j.height / 2))
      love.graphics.setColor(1,1,1)
    end
  end
end

--click buttons, mouse callbacks ------------------------------------------------------------------------------
function UI.mousePressedInUiCall(mousX, mousY, state)
  -- menu Buttons pressed ---------------------------------
  for i , UIObjects in ipairs(UI.buttonsMenuList) do
    if AABBCollisions(mousX,mousY,UIObjects) then
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
        elseif UIObjects.type == "automaticMapBuild" then
          return UIObjects.type
        end
      end
    end
  end
  -- Buttons pressed for each world ---------------------------------
  for i , UIObjects in ipairs(UI.forEachWorldButtonsList) do
    if AABBCollisions(mousX,mousY,UIObjects) then
      if state == "worldEditMode" then
        if UIObjects.type == "checkboxChooseWorldToDraw" then
          selectedWorldNum = i -- choose world to hignlight in the draw when selected
          return UIObjects.type, i
        end
      end
    end
  end
end

return UI