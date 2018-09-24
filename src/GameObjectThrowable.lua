--[[
    GD50
    Legend of Zelda

    Author: Karbb
]]

GameObjectThrowable = Class{_includes = GameObject}

function GameObjectThrowable:init(def, x, y)
    GameObject.init(self, def, x, y)
    self.onThrow = def.onThrow
    self.projectile = false
    self.maxDistance = 64
    self.distance = 0
end

function GameObjectThrowable:update(dt)
    if self.projectile then
        if self:checkWallCollisions() or self.distance > self.maxDistance then
            self:destroy()
        end

        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
        self.distance = self.distance + OBJECT_MOV_SPEED*dt
    end
end


function GameObjectThrowable:destroy()
    self.state = 'broken'
    self.projectile = false
end

function GameObjectThrowable:checkWallCollisions()
    local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

    if self.x < MAP_RENDER_OFFSET_X + TILE_SIZE or self.x > VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
        or self.y < MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 or  self.y > bottomEdge - self.height then
            return true
    end
    return false
end


function GameObjectThrowable:lift()
    self.state = 'throwed'
end

function GameObjectThrowable:fire(self, room, dx, dy)
    self.projectile = true
    self.onThrow(self, room, dx, dy)
end

function GameObjectThrowable:render()
    GameObject.render(self)
end