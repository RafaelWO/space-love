SHIP_DEFS = {
    ['playerShip1'] = {
        width = 99,
        height = 75,
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
                x = 3, y = 32
            },
            {
                x = 96, y = 32
            }
        },
        jetOffset = {
            x = 99 / 2 - GAME_OBJECT_DEFS['jet'].width / 2,
            y = 75 - 5
        }
    },
    ['playerShip2'] = {
        width = 112,
        height = 75,
        hitboxDefs = {
            {
                xOffset = 48, yOffset = 0, width = 16, height = 20
            },
            {
                xOffset = 35, yOffset = 20, width = 42, height = 12
            },
            {
                xOffset = 15, yOffset = 32, width = 82, height = 40
            },
            {
                xOffset = 2, yOffset = 40, width = 108, height = 15
            }
        },
        laserOffsets = {
            {
                x = 112 / 2, y = 0
            }
        },
        jetOffset = {
            x = 112 / 2 - GAME_OBJECT_DEFS['jet'].width / 2,
            y = 75 - 5
        }
    },
    ['enemy1'] = {
        width = 93,
        height = 84,
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
                x = 93 / 2, y = 70
            }
        }
    },
    ['enemy2'] = {
        width = 104,
        height = 84,
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
                x = 104 / 2, y = 80
            }
        }
    },
    ['enemy3'] = {
        width = 103,
        height = 84,
        hitboxDefs = {
            {
                xOffset = 5, yOffset = 0, width = 93, height = 75
            }
        },
        laserOffsets = {
            {
                x = 17, y = 80
            },
            {
                x = 86, y = 80
            }
        }
    },
    ['enemy4'] = {
        width = 82,
        height = 84,
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
    },
    ['enemy5'] = {
        width = 82,
        height = 84,
        hitboxDefs = {
            {
                xOffset = 0, yOffset = 0, width = 97, height = 30
            },
            {
                xOffset = 14, yOffset = 0, width = 69, height = 74
            },
            {
                xOffset = 31, yOffset = 74, width = 35, height = 10
            }
        },
        laserOffsets = {
            {
                x = 97 / 2, y = 84
            }
        }
    }
}