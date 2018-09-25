--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'consumable',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 5
            }
        },
        onConsume = function(self, room, k)
            if room.player.health < 5 then
                room.player:heal(2)
                table.remove(room.objects, k)
            end
            return false
        end
    },
    ['pot'] = {
        type = 'liftable',
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 14
            },
            ['throwed'] = {
                frame = 248
            },
            ['broken'] = {
                frame = 52
            }
        },
        onThrow = function(self, room, dx, dy)
            self.dx = dx;
            self.dy = dy;
            table.insert(room.projectiles, self)
        end
    },
    ['wall'] = {
        type = 'wall',
        texture = 'tiles',
        frame = 120,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 120
            }
        }
    }
}