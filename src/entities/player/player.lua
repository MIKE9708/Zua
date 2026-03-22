Config = require "src.entities.player.player_config"
EntityBase = require "src.entities.entity_base"

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
function Player.update(dt)
    local is_moving = false

    if Player.base.CurrentState.current_animation == EntityBase.Animation.Attack then
        Player.base.updateFrame(Player.base.Animations[Player.base.CurrentState.current_animation], dt)
    else
        if love.keyboard.isDown(Player.Move.Up) then
            if Player.base.y > 10 then
                Player.base.move(Player.base.x, Player.base.y - Player.base.speed * dt)
            end
            is_moving = true
        elseif love.keyboard.isDown(Player.Move.Down) then
            if Player.base.y < (Player.Config.screen_height - 10) then
                Player.base.move(Player.base.x, Player.base.y + Player.base.speed * dt)
            end
            is_moving = true
        end

        if love.keyboard.isDown(Player.Move.Right) then
            if Player.base.x < (Player.Config.screen_width - 10) then
                Player.base.move(Player.base.x + Player.base.speed * dt, Player.base.y)
                Player.base.FlipX = 1
            end
            is_moving = true
        elseif love.keyboard.isDown(Player.Move.Left) then
            if Player.base.x > 10 then
                Player.base.move(Player.base.x - Player.base.speed * dt, Player.base.y)
                Player.base.FlipX = -1
            end
            is_moving = true
        end

        if is_moving then
            Player.base.setState(EntityBase.Animation.Run)
        else
            Player.base.setState(EntityBase.Animation.Idle)
        end

        Player.base.updateFrame(Player.base.Animations[Player.base.CurrentState.current_animation], dt)
    end

    local frame_x = (Player.base.CurrentState.frame - 1) * Player.Config.tile_size
    Player.base.Quad:setViewport(frame_x, 0, Player.Config.tile_size, Player.Config.tile_size)
end

-- This is for all the key press Char (not Long press)
function Player.handleKeyPress(key)
    if key == Player.Attack then
        Player.base.attack()
    end
end

function Player.getPosition()
    return Player.base.x, Player.base.y
end

-- Initalize the Player Animations Vector
-- and set as Starting State for the Player Idle
function Player.load(start_x, start_y)
    Player.base = EntityBase.init(Player.Config)

    Player.base.x = start_x
    Player.base.y = start_y
end

function Player.draw()
    love.graphics.draw(Player.base.CurrentState.imgs, Player.base.Quad, Player.base.x, Player.base.y, 0,
        Player.base.FlipX, 1, 96, 96)
end

return Player
