GAME_OBJECT_DEFS = {
    ['laser-normal'] = {
        type = 'laser',
        texture = 'sheet',
        frame = 'laser<color>05',
        solid = false,
        defaultState = 'fly',
        states = {
            ['fly'] = {
                frames = {'laser<color>05'}
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
    ['explosion'] = {
        type = 'explosion',
        texture = 'explosion',
        solid = false,
        defaultState = 'explode',
        states = {
            ['explode'] = {
                texture = "explosion",
                interval = 0.05,
                looping = false,
                frames = "ALL"
            }
        }
    }
}