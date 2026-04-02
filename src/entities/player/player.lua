Config = require "src.entities.player.player_config"
EntityBase = require "src.entities.entity_base"
local WorldContext = require "src.world_context"

local Player = {}
Player.Config = Config


-- Possible Key the User can Press to move the Player
Player.Move = { Up = 'w', Down = 's', Left = 'a', Right = 'd' }
-- Key for Attacking
Player.Attack = "space"

-- In standard mathematics (Cartesian coordinates), the origin (0,0) is at the bottom-left,
-- and Y increases as you go Up. However, in computer screens,
-- the origin (0,0) is at the top-left corner, and Y increases as you go Down.
-- Checks for the Player current stand, if in Attack let the entire Combat animation be executed
-- otherwise check if the movement key was pressed or not and will put the Player in Run or Idle
function Player:update(dt, ctx)
    local is_moving = false

    if self.base.CurrentState.current_animation == EntityBase.Animation.Attack then
        self.base:updateFrame(self.base.Animations[self.base.CurrentState.current_animation], dt)
    else
        if love.keyboard.isDown(self.Move.Up) then
            if self.base.y > 10 then
                self.base:move(self.base.x, self.base.y - self.base.speed * dt)
            end
            is_moving = true
        elseif love.keyboard.isDown(self.Move.Down) then
            if self.base.y < (self.Config.screen_height - 10) then
                self.base:move(self.base.x, self.base.y + self.base.speed * dt)
            end
            is_moving = true
        end

        if love.keyboard.isDown(self.Move.Right) then
            if self.base.x < (self.Config.screen_width - 10) then
                self.base:move(self.base.x + self.base.speed * dt, self.base.y)
                self.base.FlipX = 1
            end
            is_moving = true
        elseif love.keyboard.isDown(self.Move.Left) then
            if self.base.x > 10 then
                self.base:move(self.base.x - self.base.speed * dt, self.base.y)
                self.base.FlipX = -1
            end
            is_moving = true
        end

        if is_moving then
            self.base:setState(EntityBase.Animation.Run)
        else
            self.base:setState(EntityBase.Animation.Idle)
        end

        self.base:updateFrame(self.base.Animations[self.base.CurrentState.current_animation], dt)
    end

    local frame_x = (self.base.CurrentState.frame - 1) * self.Config.tile_size
    self.base.Quad:setViewport(frame_x, 0, self.Config.tile_size, self.Config.tile_size)

    self:setPlayerWorldContext(ctx)
end

function Player:setPlayerWorldContext(ctx)
    ctx.player.position.x = self.base.x
    ctx.player.position.y = self.base.y
end


-- This is for all the key press Char (not Long press)
function Player:handleKeyPress(key)
    if key == self.Attack then
        self.base:attack()
    end
end

function Player:getPosition()
    return self.base.x, self.base.y
end

-- Initalize the Player Animations Vector
-- and set as Starting State for the Player Idle
function Player:load(start_x, start_y)
    self.base = EntityBase.init(Player.Config)
    self.base.x = start_x
    self.base.y = start_y
end

function Player:draw()
    love.graphics.draw(self.base.CurrentState.imgs, self.base.Quad, self.base.x, self.base.y, 0,
        self.base.FlipX, 1, 96, 96)
end

function Player.new(start_x, start_y)
    local istance = {}
    istance.base = EntityBase.init(Player.Config);
    istance.base.x = start_x
    istance.base.y = start_y

    setmetatable(istance, { __index = Player })

    return istance
end

return Player
