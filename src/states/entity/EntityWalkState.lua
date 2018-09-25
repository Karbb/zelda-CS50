--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, room)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.room = room

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false

    if direction == 'left' then
        hitboxWidth = 14
        hitboxHeight = 14
        hitboxX = self.entity.x + 1
        hitboxY = self.entity.y + 1
    elseif direction == 'right' then
        hitboxWidth = 14
        hitboxHeight = 14
        hitboxX = self.entity.x + 1
        hitboxY = self.entity.y + 1
    elseif direction == 'up' then
        hitboxWidth = 14
        hitboxHeight = 14
        hitboxX = self.entity.x + 1
        hitboxY = self.entity.y + 1
    else
        hitboxWidth = 14
        hitboxHeight = 14
        hitboxX = self.entity.x
        hitboxY = self.entity.y + self.entity.height
    end
end

function EntityWalkState:update(dt)
    
    -- assume we didn't hit a wall
    self.bumped = false
    
    local oldX = self.entity.x
    local oldY = self.entity.y

    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        
        if self:checkObjCollision() then
            self.entity.x = oldX
            self.bumped = true
        end
        if self.entity.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            self.entity.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.bumped = true
        end
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt

        if self:checkObjCollision() then
            self.entity.x = oldX
            self.bumped = true
        end

        if self.entity.x + self.entity.width >= VIRTUAL_WIDTH - TILE_SIZE * MAP_COLLISION_OFFSET then
            self.entity.x = VIRTUAL_WIDTH - TILE_SIZE * MAP_COLLISION_OFFSET - self.entity.width
            self.bumped = true
        end
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt

        if self:checkObjCollision() then
            self.entity.y = oldY
            self.bumped = true
        end

        if self.entity.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2 then 
            self.entity.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2
            self.bumped = true
        end
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt

        if self:checkObjCollision() then
            self.entity.y = oldY
            self.bumped = true
        end

        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.entity.y + self.entity.height >= bottomEdge then
            self.entity.y = bottomEdge - self.entity.height
            self.bumped = true
        end
    end
end

function EntityWalkState:checkObjCollision()
    if self.room ~= nil then
        local objects = self.room.objects

        for k, obj in pairs(self.room.objects) do
            if obj.solid and self.entity:collides(obj) then
                return true
            end
        end
    end
end

function EntityWalkState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end