local Map = require "src.map.map"
local Player = require "src.entities.player.player"
local Enemy = require "src.entities.enemy.enemy"

function love.load()
    Map.load()
    Map.new()
    Player.load(400, 300)
    Enemy.load(400, 300)
end

function love.update(dt)
    Player.update(dt)
    local x, y = Player.getPosition()
    Enemy.update(dt, x, y)
end

function love.keypressed(key)
    Player.handleKeyPress(key)
end

function love.draw()
    Map.draw()
    Player.draw()
    Enemy.draw()
end
