Config = require "src.player.player_config"

local Player = {}
Player.Config = Config

-- Define the Player position on the Screen
Player.x = 0
Player.y = 0

-- Possible Key the User can Press to move the Player
Player.Move = { Up = 'w', Down = 's', Left = 'a', Right = 'd' }
-- Key for Attacking
Player.Attack = "space"
-- This is the Player Movement Speed
Player.speed = 200

-- Possible Operation that the Players can do (implies the Animations assoicated to it)
Player.Animation = { Run = 0, Idle = 1, Attack = 2 }

-- A dictionary where the key is the Animation and the Values are:
-- imgs, the various frame of the player (in a single png) loaded in love
-- frames, how many frame are in a image
-- speed, the speed of each animation
Player.Animations = {}

-- Player current State:
-- imgs,  The animation image of the current Player Stand (Idle, Run, etc)
-- current_animation, which Animation the Player is in (Idle, Run, Attack)
-- frame, The current frame of the animation
Player.current_state = {}

-- In standard mathematics (Cartesian coordinates), the origin (0,0) is at the bottom-left,
-- and Y increases as you go Up. However, in computer screens,
-- the origin (0,0) is at the top-left corner, and Y increases as you go Down.
-- Checks for the Player current stand, if in Attack let the entire Combat animation be executed
-- otherwise check if the movement key was pressed or not and will put the Player in Run or Idle
function Player.update(dt)
    local is_moving = false

    if Player.current_state.current_animation == Player.Animation.Attack then
        Player.updateFrame(Player.Animations[Player.current_state.current_animation], dt)
    else
        if love.keyboard.isDown(Player.Move.Up) then
            Player.y = Player.y - Player.speed * dt
            is_moving = true
        elseif love.keyboard.isDown(Player.Move.Down) then
            Player.y = Player.y + Player.speed * dt
            is_moving = true
        end

        if love.keyboard.isDown(Player.Move.Right) then
            Player.x = Player.x + Player.speed * dt
            is_moving = true
        elseif love.keyboard.isDown(Player.Move.Left) then
            Player.x = Player.x - Player.speed * dt
            is_moving = true
        end

        if is_moving then
            Player.setPlayerState(Player.Animation.Run)
        else
            Player.setPlayerState(Player.Animation.Idle)
        end

        Player.updateFrame(Player.Animations[Player.current_state.current_animation], dt)
    end

    local frame_x = (Player.current_state.frame - 1) * Player.Config.tile_size
    Player.quad:setViewport(frame_x, 0, Player.Config.tile_size, Player.Config.tile_size)
end

-- A timer is set with added last dt passed
-- verify that the timer has not passed the animation Speed,
-- if that is the case move to the next frame
-- If the last frame has been reached restart from the First, but
-- if the Animation is Attack when it reaches the last frame put the Player Animation in Idle
function Player.updateFrame(animation, dt)
    Player.Config.timer = Player.Config.timer + dt
    if Player.Config.timer > animation.speed then
        Player.Config.timer = 0
        Player.current_state.frame = Player.current_state.frame + 1

        if Player.current_state.frame > animation.frames then
            if Player.current_state.current_animation == Player.Animation.Attack then
                Player.setPlayerState(Player.Animation.Idle)
            end
            Player.current_state.frame = 1
        end
    end
end

-- This is for all the key press Char (not Long press)
function Player.handle_key_press(key)
    if key == Player.Attack then
        Player.setPlayerState(Player.Animation.Attack)
    end
end

-- Set the new State of the Player
function Player.setPlayerState(new_state)
    if Player.current_state.current_animation == new_state then
        return
    else
        Player.current_state.current_animation = new_state
        Player.current_state.imgs = Player.Animations[new_state].imgs
        Player.current_state.frame = 1

        local total_w, total_h = Player.current_state.imgs:getDimensions()
        Player.quad:setViewport(0, 0, Player.Config.tile_size, Player.Config.tile_size, total_w, total_h)
    end
end

-- Initalize the Player Animations Vector
-- and set as Starting State for the Player Idle
function Player.load(start_x, start_y)
    Player.Animations[Player.Animation.Idle] = {
        imgs = love.graphics.newImage(Player.Config.idle),
        frames = 8,
        speed = 0.2
    }
    Player.Animations[Player.Animation.Run] = {
        imgs = love.graphics.newImage(Player.Config.run),
        frames = 6,
        speed = 0.2
    }
    Player.Animations[Player.Animation.Attack] = {
        imgs = love.graphics.newImage(Player.Config.attack),
        frames = 4,
        speed = 0.07
    }

    Player.current_state = {
        imgs = Player.Animations[Player.Animation.Idle].imgs,
        current_animation = Player.Animation.Idle,
        frame = 1
    }

    Player.x = start_x
    Player.y = start_y

    local total_w, total_h = Player.current_state.imgs:getDimensions()

    Player.quad = love.graphics.newQuad(0, 0, Player.Config.tile_size, Player.Config.tile_size, total_w, total_h)
end

function Player.draw()
    love.graphics.draw(Player.current_state.imgs, Player.quad, Player.x, Player.y, 0, 1, 1, 96, 96)
end

return Player
