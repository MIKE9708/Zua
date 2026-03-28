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

function WorldManager.AddEntity(entity, etype)
    if etype == WorldManager.Type.Player then
        WorldManager.setPlayerKeyHandler(
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

function WorldManager.setPlayerKeyHandler(handlerFn)
    WorldManager.handlePlayerKeyPress = handlerFn
end

function WorldManager.handleKey(key)
    WorldManager.handlePlayerKeyPress(key)
end

function WorldManager.checkCollision()
    for j = 1, #WorldManager.entities, 1 do
        entity1 = WorldManager.entities[j]
        for i = j + 1, #WorldManager.entities, 1 do
            entity2 = WorldManager.entities[i]
            overlap = WorldManager.areOverlap(entity1, entity2)
            if overlap then
                WorldManager.handleCollisions(entity1, entity2)
            end
        end
    end
end

function WorldManager.areOverlap(entity1, entity2)
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

function WorldManager.update(dt)
    local px, py = 0, 0
    for _, e in ipairs(WorldManager.entities) do
        if e.type == WorldManager.Type.Player then
            px, py = e.entity:getPosition()
            e.entity:update(dt)
        elseif e.type == WorldManager.Type.Enemy then
            e.entity:update(dt, px, py)
        end
    end
    -- WorldManager.checkCollision()
end

function WorldManager.draw()
    for _, e in ipairs(WorldManager.entities) do
        if e.entity and e.entity.draw then
            e.entity:draw()
        end
    end
end

return WorldManager
