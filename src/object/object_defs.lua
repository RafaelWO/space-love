GAME_OBJECT_DEFS = {
    ['laser-normal'] = {
        type = 'laser',
        texture = 'sheet',
        frame = 'laser<color><type>',
        solid = false,
        defaultState = 'fly',
        states = {
            ['fly'] = {
                frames = {'laser<color><type>'}
            },
            ['hit'] = {
                frames = {'laser<color>11', 'laser<color>10'},
                interval = 0.15,
                looping = false,
                width = 38,
            }
        }
    },
    ['meteor-1'] = {
        type = 'meteor',
        texture = 'sheet',
        frame = 'meteor<color>_tiny<type>',
        solid = true,
        health = 0.5
    },
    ['meteor-2'] = {
        type = 'meteor',
        texture = 'sheet',
        frame = 'meteor<color>_small<type>',
        solid = true,
        health = 2
    },
    ['meteor-3'] = {
        type = 'meteor',
        texture = 'sheet',
        frame = 'meteor<color>_med<type>',
        solid = true,
        health = 4
    },
    ['meteor-4'] = {
        type = 'meteor',
        texture = 'sheet',
        frame = 'meteor<color>_big<type>',
        solid = true,
        health = 6
    },
    ['jet'] = {
        type = 'jet',
        texture = 'sheet',
        width = 16,
        height = 40,
        solid = false,
        defaultState = "idle",
        states = {
            ['idle'] = {
                frames = {}
            },
            ['pre-fly'] = {
                frames = {'fire09'}
            },
            ['fly'] = {
                frames = {'fire08'}
            }
        }
    },
    ['pill'] = {
        type = 'powerup_pill',
        texture = 'sheet',
        frame = 'pill_<color>',
        solid = false,
        width = 22,
        height = 21,
        consumable = true
    },
    ['powerup-shield'] = {
        type = 'powerup_shield',
        texture = 'sheet',
        frame = 'powerup<color>_shield',
        solid = false,
        width = 34,
        height = 33,
        consumable = true
    },
    ['powerup-star'] = {
        type = 'powerup_star',
        texture = 'sheet',
        frame = 'powerup<color>_star',
        solid = false,
        width = 34,
        height = 33,
        consumable = true
    },
    ['shield'] = {
        type = 'shield',
        texture = 'sheet',
        solid = false,
        width = 133,
        height = 108,
        defaultState = 'down',
        states = {
            ['down'] = {
                frames = {}
            },
            ['up'] = {
                frames = {'shield1', 'shield2', 'shield3'},
                interval = 0.1,
                looping = false
            }
        }
    }
}