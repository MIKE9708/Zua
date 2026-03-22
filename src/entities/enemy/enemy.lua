Config = require "src.entities.enemy.enemy_config"

local Enemy = {}
Enemy.Config = Config

-- First: Distance at which the Enemy should stop running
-- Second: Distance at which the Enemy should start running again
-- Third: Distance at which the Enemy loose track of Player (idle)
Enemy.idleMinDistance = 150 * 150
Enemy.runMinDistance = 180 * 180
Enemy.idleMaxDistance = 300 * 300

-- Get the Distance of the Enemy from the Player
function Enemy.getDistance()
    local distance_x = math.abs(Enemy.base.x - Enemy.playerPos.x)
    local distance_y = math.abs(Enemy.base.y - Enemy.playerPos.y)
    local distance = (distance_x * distance_x) + (distance_y * distance_y)

    return distance
end

function Enemy.followPlayer(dt)
    -- Movement along X
    if math.abs(Enemy.base.x + 1 - Enemy.playerPos.x)
        <
        math.abs(Enemy.base.x - Enemy.playerPos.x) then
        Enemy.base.move(Enemy.base.x + Enemy.base.speed * dt, Enemy.base.y)
        Enemy.base.FlipX = 1
    elseif math.abs(Enemy.base.x - 1 - Enemy.playerPos.x)
        <
        math.abs(Enemy.base.x - Enemy.playerPos.x) then
        Enemy.base.move(Enemy.base.x - Enemy.base.speed * dt, Enemy.base.y)
        Enemy.base.FlipX = -1
    end
    -- Movement along Y
    if
        math.abs(Enemy.base.y + 1 - Enemy.playerPos.y)
        <
        math.abs(Enemy.base.y - Enemy.playerPos.y) then
        Enemy.base.move(Enemy.base.x, Enemy.base.y + Enemy.base.speed * dt)
    elseif
        math.abs(Enemy.base.y - 1 - Enemy.playerPos.y)
        <
        math.abs(Enemy.base.y - Enemy.playerPos.y) then
        Enemy.base.move(Enemy.base.x, Enemy.base.y - Enemy.base.speed * dt)
    end
end

-- Check the Position of the Enemy
-- and based on that change the Animation for the Attack
function Enemy.attackPlayer()
    -- Enemy.base.setState(EntityBase.Animation.Idle)
end

-- Define the Attack Animation (Up, Down, Left, Right)
function Enemy.setAttackAnimation()
end

-- This will call enemy move
-- and check if the Enemy has to attack the
-- player or not
function Enemy.update(dt, x, y)
    Enemy.playerPos = {
        x = x,
        y = y
    }

    local distance_x = math.abs(Enemy.base.x - Enemy.playerPos.x)
    local distance_y = math.abs(Enemy.base.y - Enemy.playerPos.y)
    local distance = (distance_x * distance_x) + (distance_y * distance_y)

    if distance <= Enemy.idleMinDistance then
        Enemy.isChasing = false
    elseif distance > Enemy.runMinDistance and distance < 200 * 200 then
        Enemy.isChasing = true
    elseif distance > Enemy.idleMaxDistance then
        Enemy.isChasing = false
    end

    if Enemy.isChasing then
        if Enemy.base.CurrentState.current_animation ~= EntityBase.Animation.Run then
            Enemy.base.setState(EntityBase.Animation.Run)
        end
        Enemy.followPlayer(dt)
    else
        if Enemy.base.CurrentState.current_animation ~= EntityBase.Animation.Idle then
            Enemy.base.setState(EntityBase.Animation.Idle)
        end
    end

    Enemy.base.updateFrame(Enemy.base.Animations[Enemy.base.CurrentState.current_animation], dt)
    local frame_x = (Enemy.base.CurrentState.frame - 1) * Enemy.Config.tile_size
    Enemy.base.Quad:setViewport(frame_x, 0, Enemy.Config.tile_size, Enemy.Config.tile_size)
end

function Enemy.setPlayerPos(x, y)
    Enemy.playerPos = {
        x = x,
        y = y
    }
end

-- Initalize the Player Animations Vector
-- and set as Starting State for the Player Idle
function Enemy.load(x, y)
    Enemy.base = EntityBase.init(Config)
    Enemy.base.x = 150
    Enemy.base.y = 150

    Enemy.base.setState(EntityBase.Animation.Idle)

    Enemy.playerPos = {
        x = x,
        y = y
    }
end

function Enemy.draw()
    love.graphics.draw(Enemy.base.CurrentState.imgs, Enemy.base.Quad, Enemy.base.x, Enemy.base.y, 0,
        Enemy.base.FlipX, 1, 96, 96)
end

return Enemy
