--[[

]]

ENTITY_DEFS = {
    ['player'] = {
        type = 'player',
        flySpeed = 400,
        shotInterval = 0.4,
        attack = 1,
        health = 6,
        texture = 'sheet',
        laser = 'laser-normal',
        ships = {
            {   -- playerShip1 (classic)
                attack = 1,
                health = 5,
                flySpeed = 400,
                shotInterval = 0.6,
                laserType = '05'
            },
            {   -- playerShip2 (shooter)
                attack = 0.75,
                health = 4,
                flySpeed = 500,
                shotInterval = 0.15,
                laserType = '04'
            },
            {   -- playerShip3 (sniper)
                attack = 2.5,
                health = 4.5,
                flySpeed = 300,
                shotInterval = 1,
                laserType = '14'
            }
        }
    },
    ['enemy-1'] = {
        type = 'simple_enemy',
        levels = {
            {
                color = 'Black',
                flySpeed = 200,
                shotInterval = 0.8,
                attack = 0.5,
                health = 3,
            },
            {
                color = 'Blue',
                flySpeed = 200,
                shotInterval = 0.6,
                attack = 1,
                health = 3,
            },
            {
                color = 'Green',
                flySpeed = 220,
                shotInterval = 0.6,
                attack = 1,
                health = 4,
            },
            {
                color = 'Red',
                flySpeed = 220,
                shotInterval = 0.6,
                attack = 1.5,
                health = 4,
            }
        },
        texture = 'sheet',
        ship = 'enemy1',
        laser = 'laser-normal'
    },
    ['enemy-2'] = {
        type = 'fast_enemy',
        levels = {
            {
                color = 'Black',
                flySpeed = 300,
                shotInterval = 0.4,
                attack = 0.5,
                health = 2,
            },
            {
                color = 'Blue',
                flySpeed = 300,
                shotInterval = 0.4,
                attack = 0.75,
                health = 3,
            },
            {
                color = 'Green',
                flySpeed = 350,
                shotInterval = 0.3,
                attack = 0.75,
                health = 3,
            },
            {
                color = 'Red',
                flySpeed = 350,
                shotInterval = 0.2,
                attack = 0.75,
                health = 3,
            }
        },
        texture = 'sheet',
        ship = 'enemy2',
        laser = 'laser-normal'
    },
    ['enemy-3'] = {
        type = 'fast_enemy',
        levels = {
            {
                color = 'Black',
                flySpeed = 300,
                shotInterval = 0.6,
                attack = 0.5,
                health = 2,
            },
            {
                color = 'Blue',
                flySpeed = 320,
                shotInterval = 0.6,
                attack = 0.75,
                health = 2,
            },
            {
                color = 'Green',
                flySpeed = 350,
                shotInterval = 0.5,
                attack = 0.75,
                health = 3,
            },
            {
                color = 'Red',
                flySpeed = 380,
                shotInterval = 0.3,
                attack = 0.75,
                health = 3,
            }
        },
        texture = 'sheet',
        ship = 'enemy3',
        laser = 'laser-normal',
        laserType = '04'
    },
    ['enemy-4'] = {
        type = 'tank_enemy',
        levels = {
            {
                color = 'Black',
                flySpeed = 100,
                shotInterval = 1.5,
                attack = 1.5,
                health = 5,
            },
            {
                color = 'Blue',
                flySpeed = 100,
                shotInterval = 1,
                attack = 1.75,
                health = 5,
            },
            {
                color = 'Green',
                flySpeed = 150,
                shotInterval = 1,
                attack = 1.75,
                health = 6,
            },
            {
                color = 'Red',
                flySpeed = 200,
                shotInterval = 0.75,
                attack = 2,
                health = 6,
            }
        },
        texture = 'sheet',
        ship = 'enemy4',
        laser = 'laser-normal',
        laserType = '15'
    },
    ['enemy-5'] = {
        type = 'tank_enemy',
        levels = {
            {
                color = 'Black',
                flySpeed = 150,
                shotInterval = 1,
                attack = 2,
                health = 5,
            },
            {
                color = 'Blue',
                flySpeed = 150,
                shotInterval = 1,
                attack = 2.5,
                health = 5,
            },
            {
                color = 'Green',
                flySpeed = 150,
                shotInterval = 0.75,
                attack = 2.5,
                health = 6,
            },
            {
                color = 'Red',
                flySpeed = 200,
                shotInterval = 0.75,
                attack = 3,
                health = 7,
            }
        },
        texture = 'sheet',
        ship = 'enemy5',
        laser = 'laser-normal',
        laserType = '14'
    }
}