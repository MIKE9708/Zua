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

function Enemy:followPlayer(dt)
    -- Movement along X
    if math.abs(self.base.x + 1 - self.playerPos.x)
        <
        math.abs(self.base.x - self.playerPos.x) then
        self.base:move(self.base.x + self.base.speed * dt, self.base.y)
        self.base.FlipX = 1
    elseif math.abs(self.base.x - 1 - self.playerPos.x)
        <
        math.abs(self.base.x - self.playerPos.x) then
        self.base:move(self.base.x - self.base.speed * dt, self.base.y)
        self.base.FlipX = -1
    end
    -- Movement along Y
    if
        math.abs(self.base.y + 1 - self.playerPos.y)
        <
        math.abs(self.base.y - self.playerPos.y) then
        self.base:move(self.base.x, self.base.y + self.base.speed * dt)
    elseif
        math.abs(self.base.y - 1 - self.playerPos.y)
        <
        math.abs(self.base.y - self.playerPos.y) then
        self.base:move(self.base.x, self.base.y - self.base.speed * dt)
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
function Enemy:update(dt, x, y)
    self.playerPos = {
        x = x,
        y = y
    }

    local distance_x = math.abs(self.base.x - self.playerPos.x)
    local distance_y = math.abs(self.base.y - self.playerPos.y)
    local distance = (distance_x * distance_x) + (distance_y * distance_y)

    if distance <= self.idleMinDistance then
        self.isChasing = false
    elseif distance > self.runMinDistance and distance < 200 * 200 then
        self.isChasing = true
    elseif distance > self.idleMaxDistance then
        self.isChasing = false
    end

    if self.isChasing then
        if self.base.CurrentState.current_animation ~= EntityBase.Animation.Run then
            self.base:setState(EntityBase.Animation.Run)
        end
        self:followPlayer(dt)
    else
        if self.base.CurrentState.current_animation ~= EntityBase.Animation.Idle then
            self.base:setState(EntityBase.Animation.Idle)
        end
    end

    self.base:updateFrame(self.base.Animations[self.base.CurrentState.current_animation], dt)
    local frame_x = (self.base.CurrentState.frame - 1) * self.Config.tile_size
    self.base.Quad:setViewport(frame_x, 0, self.Config.tile_size, self.Config.tile_size)
end

function Enemy:setPlayerPos(x, y)
    self.playerPos = {
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

function Enemy:draw()
    love.graphics.draw(self.base.CurrentState.imgs, self.base.Quad, self.base.x, self.base.y, 0,
        self.base.FlipX, 1, 96, 96)
end

function Enemy.new(start_x, start_y)
    local istance = {}
    istance.base = EntityBase.init(Enemy.Config);
    istance.base.x = start_x
    istance.base.y = start_y
    setmetatable(istance, { __index = Enemy })

    return istance
end

return Enemy
