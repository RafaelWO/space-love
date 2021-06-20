SHIP_DEFS = {
    ['playerShip1'] = {
        hitboxDefs = {
            {
                xOffset = 38, yOffset = 0, width = 22, height = 75
            },
            {
                xOffset = 1, yOffset = 31, width = 97, height = 31
            }
        },
        laserOffsets = {
            {
                x = 0, y = 26
            },
            {
                x = 90, y = 26
            }
        }
    },
    ['enemy1'] = {
        hitboxDefs = {
            {
                xOffset = 5, yOffset = 0, width = 83, height = 56
            },
            {
                xOffset = 15, yOffset = 56, width = 20, height = 24
            },
            {
                xOffset = 58, yOffset = 56, width = 20, height = 24
            }
        },
        laserOffsets = {
            {
                x = 93/2 - 9/2, y = 70
            }
        }
    },
    ['enemy2'] = {
        hitboxDefs = {
            {
                xOffset = 0, yOffset = 0, width = 104, height = 84
            }
        },
        laserOffsets = {
            {
                x = 104/2 - 9/2, y = 84
            }
        }
    }
}