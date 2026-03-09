local EntityBase = {}

-- Possible Operation that the entitys can do (implies the Animations assoicated to it)
-- EntityBase.Animation = { Run = 0, Idle = 1, Attack = 2 }
EntityBase.Animation = { Run = 0, Idle = 1, Attack = 2 }

-- Recieve either player or enemy config to create a basic structure
function EntityBase.init(config)
    local entity = {}
    entity.Config = config
    -- Define the Entity position on the Screen
    entity.x = 0
    entity.y = 0
    entity.timer = 0
    -- A dictionary where the key is the Animation and the Values are:
    -- imgs, the various frame of the player (in a single png) loaded in love
    -- frames, how many frame are in a image
    -- speed, the speed of each animation
    entity.Animations = {}
    entity.Animations[EntityBase.Animation.Idle] = {
        imgs = love.graphics.newImage(entity.Config.idle),
        frames = 8,
        speed = 0.2
    }
    entity.Animations[EntityBase.Animation.Run] = {
        imgs = love.graphics.newImage(entity.Config.run),
        frames = 6,
        speed = 0.2
    }
    entity.Animations[EntityBase.Animation.Attack] = {
        imgs = love.graphics.newImage(entity.Config.attack),
        frames = 4,
        speed = 0.07
    }
    -- imgs,  The animation image of the current Player Stand (Idle, Run, etc)
    -- current_animation, which Animation the Player is in (Idle, Run, Attack)
    -- frame, The current frame of the animation

    entity.CurrentState = {
        imgs = entity.Animations[EntityBase.Animation.Idle].imgs,
        speed = 200,
        current_animation = EntityBase.Animation.Idle,
        frame = 1
    }
    local total_w, total_h = entity.CurrentState.imgs:getDimensions()
    entity.Quad = love.graphics.newQuad(0, 0, entity.Config.tile_size, entity.Config.tile_size, total_w, total_h)

    -- A timer is set with added last dt passed
    -- verify that the timer has not passed the animation Speed,
    -- if that is the case move to the next frame
    -- If the last frame has been reached restart from the First, but
    -- if the Animation is Attack when it reaches the last frame put the Player Animation in Idle
    function entity.updateFrame(animation, dt)
        entity.Config.timer = entity.Config.timer + dt
        if entity.Config.timer > animation.speed then
            entity.Config.timer = 0
            entity.CurrentState.frame = entity.CurrentState.frame + 1

            if entity.CurrentState.frame > animation.frames then
                if entity.CurrentState.current_animation == EntityBase.Animation.Attack then
                    entity.setState(EntityBase.Animation.Idle)
                end
                entity.CurrentState.frame = 1
            end
        end
    end

    function entity.setState(new_state)
        if entity.CurrentState.current_animation == new_state then
            return
        else
            entity.CurrentState.current_animation = new_state
            entity.CurrentState.imgs = entity.Animations[new_state].imgs
            entity.CurrentState.frame = 1

            local total_w, total_h = entity.CurrentState.imgs:getDimensions()
            entity.Quad:setViewport(0, 0, entity.Config.tile_size, entity.Config.tile_size, total_w,
                total_h)
        end
    end

    function entity.draw()
        love.graphics.draw(entity.CurrentState.imgs, entity.Quad, entity.x, entity.y, 0, 1, 1, 96, 96)
    end

    return entity
end

return EntityBase
