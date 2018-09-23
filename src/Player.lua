--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    self.carriedObject = nil

    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:pickObject(object)
    if self.carriedObject == nil then
        self.carriedObject = object
    end
end

function Player:throwObject(object, entities, direction)
    print_r(object)
    local entityThrowed = Entity {
        animations = ENTITY_DEFS['pot'].animations,
        walkSpeed = ENTITY_DEFS['pot'].walkSpeed or 20,

        -- ensure X and Y are within bounds of the map
        x = object.x,
        y = object.y,
        
        width = 16,
        height = 16,

        health = 1
    }

    table.insert(entities, entityThrowed)

    entityThrowed.stateMachine = StateMachine {
        ['throwed'] = function() return EntityThrowedState(entityThrowed, direction) end
    }

    entityThrowed:changeState('throwed')
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end