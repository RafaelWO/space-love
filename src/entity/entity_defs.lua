--[[

]]

ENTITY_DEFS = {
    ['player'] = {
        type = 'player',
        flySpeed = 400,
        shotInterval = 0.4,
        attack = 1,
        health = 6,
        width = 99,
        height = 75,
        texture = 'sheet',
        ship = 'playerShip1',
        color = 'Blue',
        laser = 'laser-normal'
    },
    ['enemy-1'] = {
        type = 'simple_enemy',
        flySpeed = 200,
        shotInterval = 0.8,
        attack = 0.5,
        health = 3,
        width = 93,
        height = 84,
        texture = 'sheet',
        ship = 'enemy1',
        color = 'Black',
        laser = 'laser-normal'
    },
    ['enemy-2'] = {
        type = 'fast_enemy',
        flySpeed = 300,
        shotInterval = 0.4,
        attack = 0.5,
        health = 2,
        width = 104,
        height = 84,
        texture = 'sheet',
        ship = 'enemy2',
        color = 'Black',
        laser = 'laser-normal'
    },
    ['enemy-3'] = {
        type = 'fast_enemy',
        flySpeed = 300,
        shotInterval = 0.6,
        attack = 0.5,
        health = 2,
        width = 103,
        height = 84,
        texture = 'sheet',
        ship = 'enemy3',
        color = 'Black',
        laser = 'laser-normal',
        laserType = '04'
    },
    ['enemy-4'] = {
        type = 'tank_enemy',
        flySpeed = 100,
        shotInterval = 1,
        attack = 1.5,
        health = 5,
        width = 82,
        height = 84,
        texture = 'sheet',
        ship = 'enemy4',
        color = 'Black',
        laser = 'laser-normal',
        laserType = '15'
    },
    ['enemy-5'] = {
        type = 'tank_enemy',
        flySpeed = 150,
        shotInterval = 1,
        attack = 2,
        health = 5,
        width = 82,
        height = 84,
        texture = 'sheet',
        ship = 'enemy5',
        color = 'Black',
        laser = 'laser-normal',
        laserType = '14'
    }
}