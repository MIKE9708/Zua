local Map = require "src.map.map"
local Player = require "src.entities.player.player"
local Enemy = require "src.entities.enemy.enemy"
local WorldManager = require "src.world_manager"

function love.load()
    Map:new()
    WorldManager:new()
end

function love.update(dt)
    WorldManager:update(dt)
end

function love.keypressed(key)
    WorldManager:handleKey(key)
end

function love.draw()
    Map.draw()
    WorldManager:draw()
end
