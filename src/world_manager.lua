local WorldManager = {
    entities = {} -- Contanis Player Enemies and NPC
}

-- What to do in case of a collision
local CollisionAction = {
    None = 0,
    Push = 1,
    Block = 2
}

function WorldManager.AddEntity(entity)
    table.insert(WorldManager.entities, entity)
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
end

function WorldManager.update(dt)
    for _,e ipairs(WorldManager.entities) do 
        e.update(dt) 
    end 

    WorldManager.checkCollision()
end

return WorldManager
