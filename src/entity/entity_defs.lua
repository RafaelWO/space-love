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
    ['enemy'] = {
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
    }
}