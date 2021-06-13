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
        damageFrame = 'playerShip1_damage',
        animations = {
            ['idle'] = {
                frames = {'playerShip1_blue'},
                texture = 'sheet'
            },
            ['fly'] = {
                frames = {'playerShip1_blue'},
                texture = 'sheet'
            }
        },
        hitboxDefs = {
            {
                xOffset = 38, yOffset = 0, width = 22, height = 75
            },
            {
                xOffset = 1, yOffset = 31, width = 97, height = 31
            }
        },
        laserDefs = {
            type = "laser-normal",
            offsets = {
                {
                    x = 0, y = 26
                },
                {
                    x = 90, y = 26
                }
            }
        }
    },
    ['enemy'] = {
        type = 'simple_enemy',
        flySpeed = 200,
        shotInterval = 0.8,
        attack = 0.5,
        health = 3,
        width = 93,
        height = 84,
        animations = {
            ['idle'] = {
                frames = {'enemyBlack1'},
                texture = 'sheet'
            },
            ['fly'] = {
                frames = {'enemyBlack1'},
                texture = 'sheet'
            }
        },
        laserDefs = {
            type = "laser-normal",
            offsets = {
                {
                    x = 93/2 - 9/2, y = 70
                }
            }
        }
    }
}