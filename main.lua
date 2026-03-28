local Map = require "src.map.map"
local Player = require "src.entities.player.player"
local Enemy = require "src.entities.enemy.enemy"
local WorldManager = require "src.world_manager"

function love.load()
    Map.load()
    Map.new()
    local mPlayer = Player.new(400, 300)
    local mEnemy = Enemy.new(400, 300)

    WorldManager.AddEntity(mPlayer, WorldManager.Type.Player)
    WorldManager.AddEntity(mEnemy, WorldManager.Type.Enemy)
end

function love.update(dt)
    WorldManager.update(dt)
end

function love.keypressed(key)
    WorldManager.handleKey(key)
end

function love.draw()
    Map.draw()
    WorldManager.draw()
end
