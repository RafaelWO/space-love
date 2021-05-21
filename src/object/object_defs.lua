GAME_OBJECT_DEFS = {
    ['laser-blue'] = {
        type = 'laser',
        texture = 'sheet',
        frame = 'laserBlue07',
        solid = false,
        defaultState = 'flying',
        states = {
            ['flying'] = {
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
    }
}