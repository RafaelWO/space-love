SelectShipState = Class{__includes = BaseState}

function SelectShipState:init()
    self.name = "SelectShipState"

    self.menu = Menu {
        y = VIRTUAL_HEIGHT / 2 + 100,
        texts = {
            "Ship",
            "Color",
            "Start"
        },
        callbacks = {
            function()
            end,
            function()
            end,
            function()
                gSounds['music-title-screen']:stop()
                gStateStack:pop()
                gStateStack:push(PlayState({playerShipConfig = self.playerShip}))
            end
        },
        sideOptions = {
            {
                "Classic", "Shooter", "Sniper"
            },
            {
                "Blue", "Green", "Orange", "Red"
            },
            nil
        }
    }

    self.playerShip = {
        ship = "playerShip1",
        color = "Blue"
    }

    -- Define tables for ship stats display
    self.shipStats = {
        ['health'] = {
            max = 6,
            text = 'health',
            pos = 1
        },
        ['flySpeed'] = {
            max = 5,
            text = 'speed',
            pos = 3
        },
        ['attack'] = {
            max = 2.5,
            text = 'attack',
            pos = 2
        },
        ['shotInterval'] = {
            max = 9,
            text = 'cooldown',
            pos = 4
        }
    }

    self.shipStatBars = {}
    yOffset = 0
    for name, stats in spairs(self.shipStats, function(t,a,b) return t[a].pos < t[b].pos end) do
        self.shipStatBars[name] = ProgressBar {
            x = VIRTUAL_WIDTH / 2 + 40,
            y = VIRTUAL_HEIGHT / 2 - 80 + yOffset,
            width = 150,
            height = 5,
            value = self:getShipStats(name),
            max = stats.max,
            text = stats.text
        }
        yOffset = yOffset + 30
    end
end

function SelectShipState:getShipStats(name)
    local stats = ENTITY_DEFS['player'].ships[Entity.getShipType(self.playerShip)]
    local value = stats[name]

    if name == 'flySpeed' then
        return value / 100
    elseif name == 'shotInterval' then
        return value * 10
    end

    return value
end

function SelectShipState:update(dt)
    self.menu:update(dt)

    -- Update playership's last char (number) with the index of the selected option
    self.playerShip.ship = self.playerShip.ship:sub(0, self.playerShip.ship:len()-1) .. self.menu.sideOptionsSelected[1]
    self.playerShip.color = self.menu:getSelectedSideText(2)

    -- Update ship stats
    for name, stats in pairs(self.shipStats) do
        self.shipStatBars[name]:setValue(self:getShipStats(name))
        self.shipStatBars[name].outlineColor = color2rgb(self.playerShip.color)
    end
end

function SelectShipState:render()
    love.graphics.setBackgroundColor(0.5,0,1)
    love.graphics.setColor(250, 250, 250, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Select Your Ship', 0, VIRTUAL_HEIGHT / 2 - 200, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(gTextures['sheet'], gFrames['sheet'][Player.getFrame(self.playerShip)],
        VIRTUAL_WIDTH / 2 - SHIP_DEFS[self.playerShip.ship].width / 2 - 120, VIRTUAL_HEIGHT / 2 - 60)


    self.menu:render()

    love.graphics.setColor(250, 250, 250, 255)
    for k, bar in pairs(self.shipStatBars) do
        bar:render()
    end
end