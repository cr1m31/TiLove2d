-- collision tester
local collisionTestT = {}

local screenwidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function collisionTestT.collisionTilesTester(MAPSNWORLD,worldX, worldY, playerOffsetX, playerOffsetY)
--  for worldKey, worldVal in ipairs(MAPSNWORLD) do   
--    for mapsKey, mapsVal in pairs(MAPSNWORLD[1]) do
--      for layersKey = 1, #MAPSNWORLD[1][mapsKey].layers , 1 do
--        local layerValue = MAPSNWORLD[1][mapsKey].layers[layersKey]
--        if layerValue.height == nil then
--        else
--          for y = 0, layerValue.height - 1 do
--            for x = 0 , layerValue.width - 1 do
--              local xx = x * MAPSNWORLD[1][mapsKey].tilewidth + MAPSNWORLD[1][mapsKey].mapOnWorldPosX + MAPSNWORLD[1][mapsKey].layers[layersKey].offsetx -- xx = adjust x on map grid, on world pos and layer offset 
--              local yy = y * MAPSNWORLD[1][mapsKey].tileheight + MAPSNWORLD[1][mapsKey].mapOnWorldPosY + MAPSNWORLD[1][mapsKey].layers[layersKey].offsety
--              local index = x + (y * layerValue.width) + 1
--              local layerDataIndex = layerValue.data[index]
--              if layerDataIndex ~= 0 then 
--                for tileKey, tilesetVal in ipairs(MAPSNWORLD[1][mapsKey].tilesets) do
--                  if tilesetVal.tilecount == nil then
--                  else
--                    if layerDataIndex >= tilesetVal.firstgid and 
--                    layerDataIndex <= tilesetVal.firstgid + tilesetVal.tilecount - 1 then 
--                      for tileNum, tileVal in ipairs(tilesetVal.tiles) do
--                        if tileVal.objectGroup == nil then
--                        else
--                          -- collision test
--                          for tileObjectGroupI, tileObjectGroupVal in ipairs(tileVal.objectGroup.objects) do
--                            if tileVal.id + 1 == layerDataIndex then
--                              --love.graphics.rectangle("line", xx + worldX, yy + worldY, tileObjectGroupVal.width, tileObjectGroupVal.height)
--                              --love.graphics.print("img:" .. tilesetVal.name .. "/coll", xx + worldX, yy + worldY - 20)
--                              local colPosX = xx + worldX
--                              local colPosY = yy + worldY
                              
--                              if colPosX < screenwidth / 2 then -- test to see when a collider is on the left of the screen or not
--                                -- works only with one collision tile !! fror testing purpose
--                                --print("left")
--                              else
--                                --print("right")
--                              end
--                            end
--                          end
--                        end
--                      end
--                    end
--                  end
--                end
--              end
--            end
--          end
--        end
--      end
--    end
--  end
end

return collisionTestT