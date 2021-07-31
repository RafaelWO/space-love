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
    ['meteor'] = {
        type = 'meteor',
        texture = 'sheet',
        frame = 'OVERRIDE',
        solid = true
    },
    ['jet'] = {
        type = 'jet',
        texture = 'sheet',
        frame = 'fire09',
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
    ['shield'] = {
        type = 'shield',
        texture = 'sheet',
        frame = 'shield1',
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