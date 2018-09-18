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
        -- TODO
    }
}