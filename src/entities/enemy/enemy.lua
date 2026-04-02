Config = require "src.entities.enemy.enemy_config"
local WorldContext = require "src.world_context"

local Enemy = {}
Enemy.Config = Config

-- First: Distance at which the Enemy should stop running
-- Second: Distance at which the Enemy should start running again
-- Third: Distance at which the Enemy loose track of Player (idle)
Enemy.R = 96
Enemy.idleMinDistance = (Enemy.R * Enemy.R) * 0.5
Enemy.runMinDistance = Enemy.idleMinDistance * 3

-- Get the Distance of the Enemy from the Player
function Enemy:getDistance(ctx)
    local distance_x = self.base.x - ctx.player.position.x
    local distance_y = self.base.y - ctx.player.position.y
    local distance = (distance_x * distance_x) + (distance_y * distance_y)

    return distance
end

function Enemy:followPlayer(dt, ctx)
    local half = self.Config.tile_size / 2

    local dx = (ctx.player.position.x + half) - (self.base.x + half)
    local dy = (ctx.player.position.y + half) - (self.base.y + half)
    local step = self.base.speed * dt

    -- Clamping the Moovement
    local move_x = math.max(-step, math.min(step, dx))
    local move_y = math.max(-step, math.min(step, dy))

    if move_x > 0 and self.base.FlipX ~= 1 then
        self.base.FlipX = 1
    elseif move_x < 0  and self.base.FlipX ~= -1 then
        self.base.FlipX = -1
    end

    self.base:move(self.base.x + move_x, self.base.y + move_y)
end

-- Check the Position of the Enemy
-- and based on that change the Animation for the Attack
function Enemy.attackPlayer()
    -- Enemy.base.setState(EntityBase.Animation.Idle)
end

-- Define the Attack Animation (Up, Down, Left, Right)
function Enemy.setAttackAnimation(ctx)
    if ctx.player.position.x >= self.base.x then
    end
end

-- This will call enemy move
-- and check if the Enemy has to attack the
-- player or not
function Enemy:update(dt, ctx)
    local distance = self:getDistance(ctx)

    if distance <= self.idleMinDistance then
        self.base:setState(EntityBase.Animation.Idle)
    elseif distance > self.runMinDistance  then
        self.base:setState(EntityBase.Animation.Run)
        self:followPlayer(dt, ctx)
    end

    self.base:updateFrame(self.base.Animations[self.base.CurrentState.current_animation], dt)
    local frame_x = (self.base.CurrentState.frame - 1) * self.Config.tile_size
    self.base.Quad:setViewport(frame_x, 0, self.Config.tile_size, self.Config.tile_size)

end

-- Initalize the Player Animations Vector
-- and set as Starting State for the Player Idle
function Enemy.load(x, y)
    Enemy.base = EntityBase.init(Config)
    Enemy.base.x = 150
    Enemy.base.y = 150

    Enemy.base.setState(EntityBase.Animation.Idle)
end

-- Save snapshot of transform (position, scale, rotation)
-- Shift everything and flip everything horizontally
-- Draw flipped and shifted, an isolated scope of transformation
-- for the Enemy in Flip
function Enemy:draw()
    love.graphics.push()
    if self.base.FlipX == -1 then
        love.graphics.translate(self.base.x + 96, self.base.y)
        love.graphics.scale(-1, 1)
        love.graphics.draw(self.base.CurrentState.imgs, self.base.Quad, 0, 0, 0, 1, 1, 96, 96)
    else
        love.graphics.draw(self.base.CurrentState.imgs, self.base.Quad, self.base.x, self.base.y, 0, 1, 1, 96, 96)
    end
    love.graphics.pop()
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
