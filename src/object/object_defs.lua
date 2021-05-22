GAME_OBJECT_DEFS = {
    ['laser-blue'] = {
        type = 'laser',
        texture = 'sheet',
        frame = 'laserBlue07',
        solid = false,
        defaultState = 'fly',
        states = {
            ['fly'] = {
                frames = {'laserBlue07'}
            },
            ['hit'] = {
                frames = {'laserBlue11', 'laserBlue10'},
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
        frame = 'fire06',
        width = 14,
        height = 31,
        solid = false,
        defaultState = "idle",
        states = {
            ['idle'] = {
                frames = {'fire06'}
            },
            ['fly'] = {
                frames = {'fire07'}
            }
        }
    }
}