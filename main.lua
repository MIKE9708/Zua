local Map = require "src.map.map"
local Player = require "src.player.player"

function love.load()
    Map.load()
    Map.new()
    Player.load(400, 300)
end

function love.update(dt)
    Player.update(dt)
end

function love.keypressed(key)
    Player.handle_key_press(key)
end

function love.draw()
    Map.draw()
    Player.draw()
end
