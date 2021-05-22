--[[

]]

ENTITY_DEFS = {
    ['player'] = {
        flySpeed = 400,
        width = 99,
        height = 75,
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
        hitboxMargins = {
            {
                xOffset = 38, yOffset = 0, width = 22, height = 75
            },
            {
                xOffset = 1, yOffset = 31, width = 97, height = 31
            }
        }
    }
}