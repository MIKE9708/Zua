local WorldContext = require "src.world_context"
local Player = require "src.entities.player.player"
local Enemy = require "src.entities.enemy.enemy"

local WorldManager = {
    entities = {} -- Contanis Player Enemies and NPC
}

-- The world manager must Know the Entity Type
WorldManager.Type = { Player = 0, Enemy = 1 }

-- A reference to the Player Handle Key Func
WorldManager.handlePlayerKeyPress = nil

-- What to do in case of a collision
local CollisionAction = {
    None = 0,
    Push = 1,
    Block = 2
}

function WorldManager:new()
    self:load()
end

function WorldManager:load()
    local mPlayer = Player.new(400, 300)
    local mEnemy = Enemy.new(400, 300)

    self:AddEntity(mPlayer, WorldManager.Type.Player)
    self:AddEntity(mEnemy, WorldManager.Type.Enemy)

end

function WorldManager:AddEntity(entity, etype)
    if etype == WorldManager.Type.Player then
        self:setPlayerKeyHandler(
            function(key)
                entity:handleKeyPress(key)
            end
        )
    end

    table.insert(WorldManager.entities, {
        entity = entity,
        type = etype
    })
end

function WorldManager:setPlayerKeyHandler(handlerFn)
    self.handlePlayerKeyPress = handlerFn
end

function WorldManager:handleKey(key)
    self.handlePlayerKeyPress(key)
end

function WorldManager:checkCollision()
    for j = 1, #self.entities, 1 do
        entity1 = self.entities[j]
        for i = j + 1, #self.entities, 1 do
            entity2 = self.entities[i]
            overlap = self.areOverlap(entity1, entity2)
            if overlap then
                self.handleCollisions(entity1, entity2)
            end
        end
    end
end

function WorldManager:areOverlap(entity1, entity2)
    local distance_x = math.abs(entity1.base.x - entity2.x)
    local distance_y = math.abs(entity1.base.y - entity2.y)
    -- Less Computation not SQRT
    local distance = (distance_x * distance_x) + (distance_y * distance_y)

    local radious1 = entity1.Config.tile_size * 0.4
    local radious2 = entity2.Config.tile_size * 0.4

    local minDistance = radious1 + radious2
    -- local minDistanceSquare = minDistance * minDistance

    if distance <= minDistance and distance > 0 then
        return true
    else
        return false
    end
end

function WorldManager.handleCollisions(e1, e2)
    -- TODO
end

-- This is just For Debugging
function tprint(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint .. k .. "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent - 2) .. "}"
    return toprint
end

function WorldManager:update(dt)
    local px, py = 0, 0
    local playerFlip = 0
    for _, e in ipairs(self.entities) do
        if e.type == WorldManager.Type.Player then
            e.entity:update(dt, WorldContext)
        elseif e.type == self.Type.Enemy then
            e.entity:update(dt, WorldContext)
        end
    end
    -- WorldManager.checkCollision()
end

function WorldManager:draw()
    for _, e in ipairs(self.entities) do
        if e.entity and e.entity.draw then
            e.entity:draw()
        end
    end
end

return WorldManager
