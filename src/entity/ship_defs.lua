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
                xOffset = 18, yOffset = 0, width = 27, height = 83
            },
            {
                xOffset = 59, yOffset = 0, width = 27, height = 83
            },
            {
                xOffset = 0, yOffset = 26, width = 104, height = 24
            }
        },
        laserOffsets = {
            {
                x = 104/2 - 9/2, y = 84
            }
        }
    },
    ['enemy3'] = {
        hitboxDefs = {
            {
                xOffset = 5, yOffset = 0, width = 93, height = 75
            }
        },
        laserOffsets = {
            {
                x = 17, y = 79
            },
            {
                x = 86, y = 79
            }
        }
    },
    ['enemy4'] = {
        hitboxDefs = {
            {
                xOffset = 19, yOffset = 0, width = 44, height = 77
            },
            {
                xOffset = 0, yOffset = 0, width = 82, height = 65
            }
        },
        laserOffsets = {
            {
                x = 82 / 2, y = 84
            }
        }
    }
}