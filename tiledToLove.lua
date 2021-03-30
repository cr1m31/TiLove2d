--tiled to love2d 
--https://www.youtube.com/watch?v=yKk-rODDD8Y

local tiledToLoveT = {}

local TILESETSIMPORTEDFROMMAIN = {}

function tiledToLoveT.passMainTilesetsToTiledToLove(importedTilesetsP)
  TILESETSIMPORTEDFROMMAIN = importedTilesetsP
  createSubTableQuadLImgL()
end

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local tilesetsImagesList = {}
local quadListT = {} 

function createSubTableQuadLImgL()
  for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do
    quadListT[worldKey] = {}
    tilesetsImagesList[worldKey] = {}    
    for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
      quadListT[worldKey][mapsKey] = {}
      tilesetsImagesList[worldKey][mapsKey] = {}
    end
  end
end

function tiledToLoveT.imageListTable() --because lua maps are stored in a game's sub directory and tiled editor adds ../
  for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do    
    for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
      if TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey] == nil then
      else
        for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilesets) do
          tilesetsImagesList[worldKey][mapsKey][tileKey] = {}
        end
      end
    end
  end
end

  function tiledToLoveT.loadTilesetImages()
    for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do    
      for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
        if TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey] == nil then
        else
          for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilesets) do
            local tempImageName = tilesetVal.image
            if tempImageName == nil then
              print("image tsx file is missing for tileset " .. tileKey)
            else
              tempImageName = string.gsub(tempImageName, "%.%./", "", 1)
              tilesetVal.image = tempImageName -- apply path changes
              tilesetsImagesList[worldKey][mapsKey][tileKey].tileImg = love.graphics.newImage(tilesetVal.image)
            end
          end
        end
      end
    end
  end

-- WARNING !!, when creating quadList, create only one list per map, cause if
-- you create a quadList for each tileset, the quads will be counted from zero each time instead of
-- count quads accordingly with tile ids that make increasing tile stacks like firstgid is increasing
-- for each new tileset so, "quadListT[worldKey][mapsKey]" is right and "quadListT[worldKey][mapsKey][tilesetNum]" is WRONG !!
  function tiledToLoveT.buildTilesetQuad() 
    for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do    
      for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
        if TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey] == nil then
        else
          for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilesets) do
            if tilesetVal.imageheight == nil then
              print("image tsx file is missing for tileset " .. tileKey)
            else
              for y = 0 , tilesetVal.imageheight / tilesetVal.tileheight - 1 do
                for x = 0 , tilesetVal.imagewidth / tilesetVal.tilewidth - 1 do
                  local xx = x * tilesetVal.tilewidth
                  local yy = y * tilesetVal.tileheight
                  index = x + (y * tilesetVal.imagewidth / tilesetVal.tilewidth) + 1
                  table.insert(quadListT[worldKey][mapsKey], love.graphics.newQuad(xx, yy,
                    tilesetVal.tilewidth, 
                    tilesetVal.tileheight,
                    tilesetVal.imagewidth,
                    tilesetVal.imageheight
                  )) 
                end
              end 
            end
          end
        end
      end
    end
  end
  
  function tiledToLoveT.exportQuadsAndImageListFromTiledToMain()
    return quadListT, tilesetsImagesList
  end
  
  function tiledToLoveT.declareAnimTimer()
    for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do    
      for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
        if TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey] == nil then
        else
          for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilesets) do
            if tilesetVal.tiles == nil then
              print("image tsx file is missing for tileset " .. tileKey)
            else
              for tileNum, tileVal in ipairs(tilesetVal.tiles) do
                if tileVal.animation == nil then
                else
                  for animFrameI, animFrameVal in ipairs(tileVal.animation) do
                    tileVal.animTimer = 1
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  function tiledToLoveT.updateAnims(dt)
  for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do    
    for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
      if TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey] == nil then
      else
        for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilesets) do
          if tilesetVal.tiles == nil then
          else
            for tileNum, tileVal in ipairs(tilesetVal.tiles) do 
              if tileVal.animation == nil then
                
              else
                for animFrameI, animFrameVal in ipairs(tileVal.animation) do
                  tileVal.animTimer = tileVal.animTimer + ( ( (1000 / tileVal.animation[animFrameI].duration) * dt) / #tileVal.animation) -- / #tileVal.animation means that animation speed is divided by the number of total frames per anim.
                  if tileVal.animTimer > #tileVal.animation + 1 then
                    tileVal.animTimer = 1
                  end
                  tileVal.animTimerFloor = math.floor(tileVal.animTimer) -- put the floor here to pervent timer over time.
                end
              end
            end
          end
        end
      end
    end
  end
end
  
  function tiledToLoveT.drawLayerDataIndexes(worlX, worldY)
    for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do   
      for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
        if TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey] == nil then
        else
          for layersKey = 1, #TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].layers do
            local layerValue = TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].layers[layersKey] 
            if layerValue.type == "tilelayer" then
              for y = 0, layerValue.height - 1 do
                for x = 0 , layerValue.width - 1 do
                  -- add the injected map position to tile positions (.mapOnWorldPosX field was injected into the mainLinker module)
                  local xx = x * TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilewidth + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].mapOnWorldPosX + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].layers[layersKey].offsetx
                  local yy = y * TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tileheight + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].mapOnWorldPosY + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].layers[layersKey].offsety
                  local index = x + (y * layerValue.width) + 1 -- return to a new line when the table index equals the width of the layer width (because we are dealing with one dimesional table of tiled).
                  local layerDataIndex = layerValue.data[index]
                  love.graphics.print(layerDataIndex, xx + worlX, yy + worldY)
                end
              end
            end
          end
        end
      end
    end
  end
  
--https://www.youtube.com/watch?v=_NpDbNtJyDQ&t=242s

function drawGroupFolderLayers(worldX, worldY, playerOffsetX, playerOffsetY, worldKey, mapsKey, layersKey, subLayerVal)
  if subLayerVal.type == "tilelayer"then
    drawTileLayers(worldX, worldY, playerOffsetX, playerOffsetY, worldKey, mapsKey, layersKey, subLayerVal)
  elseif subLayerVal.type == "objectgroup" then -- this will select object layers
    drawObjectGroupLayers(worldX, worldY, playerOffsetX, playerOffsetY, worldKey, mapsKey, layersKey, subLayerVal)
  end  
end

function drawTileLayers(worldX, worldY, playerOffsetX, playerOffsetY, worldKey, mapsKey, layersKey, layerValue)
  for y = 0, layerValue.height - 1 do
    for x = 0 , layerValue.width - 1 do
      local xx = x * TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilewidth + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].mapOnWorldPosX + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].layers[layersKey].offsetx -- xx = adjust x on map grid, on world pos and layer offset 
      local yy = y * TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tileheight + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].mapOnWorldPosY + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].layers[layersKey].offsety
      local index = x + (y * layerValue.width) + 1
      local layerDataIndex = layerValue.data[index]
      if layerDataIndex ~= 0 then 
        -- list tilesets for each layer cause tilesets are parallel to layers lists.
        for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilesets) do
          if tilesetVal.tilecount == nil then
          else
            if layerDataIndex >= tilesetVal.firstgid and 
            layerDataIndex <= tilesetVal.firstgid + tilesetVal.tilecount - 1 then 
              -- draw tile layers
                love.graphics.draw(tilesetsImagesList[worldKey][mapsKey][tileKey].tileImg, quadListT[worldKey][mapsKey][layerDataIndex], xx + worldX, yy + worldY) 
              for tileNum, tileVal in ipairs(tilesetVal.tiles) do
                if tileVal.objectGroup == nil then
                else
                  -- draw collision test
                  for tileObjectGroupI, tileObjectGroupVal in ipairs(tileVal.objectGroup.objects) do
                    if tileVal.id + 1 == layerDataIndex then
                      love.graphics.rectangle("line", xx + worldX, yy + worldY, tileObjectGroupVal.width, tileObjectGroupVal.height)
                      love.graphics.print("img:" .. tilesetVal.name .. "/coll", xx + worldX, yy + worldY - 20)
                    end
                  end
                end
                if tileVal.animation == nil then
                else
                  for animFrameI, animFrameVal in ipairs(tileVal.animation) do  
                    if layerDataIndex == tilesetVal.firstgid + animFrameVal.tileid then -- if the data correspond with tilesets then...
                      -- draw animations here
                      love.graphics.draw(tilesetsImagesList[worldKey][mapsKey][tileKey].tileImg, quadListT[worldKey][mapsKey][ tilesetVal.firstgid + tileVal.animation[tileVal.animTimerFloor ].tileid ], xx + worldX + playerOffsetX, yy + worldY + playerOffsetY)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

function drawObjectGroupLayers(worldX, worldY, playerOffsetX, playerOffsetY, worldKey, mapsKey, layersKey, layerValue)
  if layerValue.objects ~= nil then
    for objectsI, objectsVal in ipairs(layerValue.objects) do
      local xxO = objectsVal.x + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].mapOnWorldPosX + layerValue.offsetx
      local yyO = objectsVal.y + TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].mapOnWorldPosY + layerValue.offsety
      if objectsVal.gid == nil then 
        -- draw objects (rectangle without image)
        love.graphics.rectangle("line", xxO + worldX, yyO + worldY, objectsVal.width, objectsVal.height) 
        love.graphics.print("Obj ID = " .. objectsVal.id, xxO + worldX, yyO - objectsVal.height + worldY) 
      else
        for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[worldKey][mapsKey].tilesets) do -- tilesets are counted in each layer.
          if objectsVal.gid >= tilesetVal.firstgid and 
          objectsVal.gid <= tilesetVal.firstgid + tilesetVal.tilecount - 1 then 
            -- draw tiles in the objects layer
              love.graphics.draw(tilesetsImagesList[worldKey][mapsKey][tileKey].tileImg, quadListT[worldKey][mapsKey][objectsVal.gid], xxO + worldX, yyO - objectsVal.height + worldY, 0, objectsVal.width / tilesetVal.tilewidth, objectsVal.height / tilesetVal.tileheight) 
              -- object width and height divived by tileset width and height to compensate scale in the draw. 
            for tileNum, tileVal in ipairs(tilesetVal.tiles) do -- draw animated object tiles from here
              if tileVal.animation == nil then
              else
                for animFrameI, animFrameVal in ipairs(tileVal.animation) do 
                  if objectsVal.gid == tilesetVal.firstgid + animFrameVal.tileid then -- if the data correspond with tilesets then...
                    -- draw animations here
                    love.graphics.draw(tilesetsImagesList[worldKey][mapsKey][tileKey].tileImg, quadListT[worldKey][mapsKey][ objectsVal.gid + tileVal.animation[tileVal.animTimerFloor ].tileid - tileVal.id ], xxO + worldX + playerOffsetX, yyO - objectsVal.height + worldY, 0, objectsVal.width / tilesetVal.tilewidth, objectsVal.height / tilesetVal.tileheight)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

function tiledToLoveT.drawTiled(chooseWorld, chooseMap, worldX, worldY, playerOffsetX, playerOffsetY)
  for worldKey, worldVal in ipairs(TILESETSIMPORTEDFROMMAIN) do   
    for mapsKey, mapsVal in pairs(TILESETSIMPORTEDFROMMAIN[worldKey]) do
      if TILESETSIMPORTEDFROMMAIN[chooseWorld] == nil then
        love.graphics.setColor(1,0,0)
        love.graphics.print("Please choose a world in the world editor. ", screenWidth / 3, screenHeight / 1.5)
        love.graphics.setColor(1,1,1)
      elseif TILESETSIMPORTEDFROMMAIN[chooseWorld][chooseMap] == nil then
        love.graphics.setColor(1,0,0)
        love.graphics.print("Please choose a map in the world editor. ", screenWidth / 3, screenHeight / 1.2)
        love.graphics.setColor(1,1,1)
      else
        for tileKey, tilesetVal in ipairs(TILESETSIMPORTEDFROMMAIN[chooseWorld][chooseMap].tilesets) do
          if tilesetVal.tiles == nil then
            love.graphics.setColor(1,0,0)
            love.graphics.print("please embedd tilesets in Tiled map editor " .. tileKey .. " !", screenWidth / 3, screenHeight / 2)
            love.graphics.setColor(1,1,1)
          end
        end
        -- end of tsx image check
        for layersKey = 1, #TILESETSIMPORTEDFROMMAIN[chooseWorld][chooseMap].layers , 1 do
          local layerValue = TILESETSIMPORTEDFROMMAIN[chooseWorld][chooseMap].layers[layersKey]
          if layerValue.type == "group" then
            for subLayerI, subLayerVal in ipairs(layerValue.layers) do
              love.graphics.setColor(1,0.4,0.4)
              -- draw tiles or animations in GROUPS (folders)
              drawGroupFolderLayers(worldX, worldY, playerOffsetX, playerOffsetY, chooseWorld, chooseMap, layersKey, subLayerVal)
              love.graphics.setColor(1,1,1)
            end
          elseif layerValue.type == "tilelayer"then
            drawTileLayers(worldX, worldY, playerOffsetX, playerOffsetY, chooseWorld, chooseMap, layersKey, layerValue)
          elseif layerValue.type == "objectgroup" then -- this will select object layers 
            drawObjectGroupLayers(worldX, worldY, playerOffsetX, playerOffsetY, chooseWorld, chooseMap, layersKey, layerValue)
          end  
        end
      end
    end
  end
end

return tiledToLoveT
