local EntityBase = {}

-- Possible Operation that the entitys can do (implies the Animations assoicated to it)
-- EntityBase.Animation = { Run = 0, Idle = 1, Attack = 2 }
EntityBase.Animation = { Run = 0, Idle = 1, Attack = 2 }

-- Recieve either player or enemy config to create a basic structure
function EntityBase.init(config, etype)
    local entity = {}
    entity.Config = config
    -- Define the Entity position on the Screen
    entity.x = 0
    entity.y = 0
    entity.timer = 0
    -- This is the Entity Movement Speed
    entity.speed = 200
    -- Either 1 or -1 to flip the image
    entity.FlipX = 1
    entity.type = etype
    -- A dictionary where the key is the Animation and the Values are:
    -- imgs, the various frame of the player (in a single png) loaded in love
    -- frames, how many frame are in a image
    -- speed, the speed of each animation
    entity.Animations = {}
    entity.Animations[EntityBase.Animation.Idle] = {
        imgs = love.graphics.newImage(entity.Config.idle),
        frames = entity.Config.idle_frames,
        speed = 0.1
    }
    entity.Animations[EntityBase.Animation.Run] = {
        imgs = love.graphics.newImage(entity.Config.run),
        frames = entity.Config.run_frames,
        speed = 0.2
    }
    entity.Animations[EntityBase.Animation.Attack] = {
        imgs = love.graphics.newImage(entity.Config.attack),
        frames = entity.Config.attack_frames,
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
    function entity:updateFrame(animation, dt)
        self.timer = self.timer + dt
        if self.timer > animation.speed then
            self.timer = 0
            self.CurrentState.frame = self.CurrentState.frame + 1

            if self.CurrentState.frame > animation.frames then
                if self.CurrentState.current_animation == EntityBase.Animation.Attack then
                    self:setState(EntityBase.Animation.Idle)
                end
                self.CurrentState.frame = 1
            end
        end
    end

    -- TODO
    function entity:move(x, y)
        self.x = x
        self.y = y
    end

    -- TODO
    function entity:attack()
        self:setState(EntityBase.Animation.Attack)
    end

    function entity:setState(new_state)
        if self.CurrentState.current_animation == new_state then
            return
        else
            self.CurrentState.current_animation = new_state
            self.CurrentState.imgs = self.Animations[new_state].imgs
            self.CurrentState.frame = 1

            local total_w, total_h = self.CurrentState.imgs:getDimensions()
            self.Quad:setViewport(0, 0, self.Config.tile_size, self.Config.tile_size, total_w,
                total_h)
        end
    end

    function entity:draw()
        love.graphics.draw(self.CurrentState.imgs, self.Quad, self.x, self.y, 0, 1, 1, 96, 96)
    end

    return entity
end

return EntityBase
