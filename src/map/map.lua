local Config = require "src.map.map_config"

local Map = {}

Map.Config = Config

local background = {}
local map = {}

function Map:load()
    background = love.graphics.newImage(Map.Config.desert)
end

function Map:new()
    self:load()
    for row = 0, Map.Config.tile_y - 1 do
        map[row] = {}
        for col = 0, Map.Config.tile_x - 1 do
            map[row][col] = Map.Config.Tile.Desert
        end
    end

    return map
end

function Map.draw()
    for row = 0, Map.Config.tile_y - 1 do
        for col = 0, Map.Config.tile_x - 1 do
            if map[row][col] == Map.Config.Tile.Desert then
                love.graphics.draw(background, (col) * Map.Config.tile_size, (row) * Map.Config.tile_size)
            end
        end
    end
end

return Map
