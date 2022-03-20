SelectShipState = Class{__includes = BaseState}

function SelectShipState:init(params)
    self.name = "SelectShipState"
    self.background = params.background
    self.shipY = VIRTUAL_HEIGHT / 2 - 90
    self:loadShip()
    self.menu = Menu {
        y = VIRTUAL_HEIGHT / 2 + 100,
        texts = {
            "Ship",
            "Color",
            "Start"
        },
        callbacks = {
            nil,
            nil,
            function()
                love.filesystem.write(FILE_SHIP, lunajson.encode(self.playerShip))
                self.tweening = true
                Timer.tween(0.8, {
                    [self.playerShip] = {
                        x = VIRTUAL_WIDTH / 2 - SHIP_DEFS[self.playerShip.ship].width / 2,
                        y = VIRTUAL_HEIGHT / 2 + 100
                    },
                    [self] = { blackAlpha = 1 }
                })
                :finish(function()
                    gSounds['music-title-screen']:stop()
                    gStateStack:pop()
                    gStateStack:push(PlayState({playerShipConfig = self.playerShip}))
                end)
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
    -- Set menu state to current player ship
    self.menu:selectSideOption(1, Entity.getShipType(self.playerShip))
    self.menu:selectSideOption(2, self.playerShip.color)

    self.tweening = false
    self.blackAlpha = 0

    -- variables for making ship shoot
    self.shotIntervalTimer = 0
    self.shotInterval = self:getShipStats('shotInterval', false)
    self.playerShip.laserType = self:getShipStats('laserType', false)
    self.laserOffsets = SHIP_DEFS[self.playerShip.ship].laserOffsets
    self.lasers = {}
    self.shotTimer = 0
    self.shotDuration = 0
    self.shotWaitDuration = 0

    -- Define tables for ship stats display
    self.shipStats = {
        ['health'] = {
            max = 5,
            min = 3,
            text = 'health',
            pos = 1
        },
        ['flySpeed'] = {
            min = 2,
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
            text = 'fire rate',
            pos = 4
        }
    }

    self.shipStatBars = {}
    yOffset = 0
    for name, stats in spairs(self.shipStats, function(t,a,b) return t[a].pos < t[b].pos end) do
        self.shipStatBars[name] = ProgressBar {
            x = VIRTUAL_WIDTH / 2 + 40,
            y = self.shipY - 20 + yOffset,
            width = 150,
            height = 5,
            value = self:getShipStats(name, true),
            max = stats.max,
            min = stats.min or nil,
            text = stats.text
        }
        yOffset = yOffset + 30
    end
end

function SelectShipState:getShipStats(name, doConversion)
    local stats = ENTITY_DEFS['player'].ships[Entity.getShipType(self.playerShip)]
    local value = stats[name]

    if doConversion then
        if name == 'flySpeed' then
            return value / 100
        elseif name == 'shotInterval' then
            return (1.1 -value) * 10
        end
    end

    return value
end

function SelectShipState:shoot()
    if self.shotIntervalTimer > self.shotInterval then
        self.shotIntervalTimer = 0

        for i, offset in ipairs(self.laserOffsets) do
            table.insert(self.lasers, Laser (
                self.playerShip.x + offset.x,
                self.playerShip.y + offset.y,
                GAME_OBJECT_DEFS['laser-normal'],
                "up",
                self.playerShip
            ))
        end

        gSounds['laser-1']:stop()
        gSounds['laser-1']:play()
    end
end

function SelectShipState:update(dt)
    self.menu:update(dt)
    self.background:update(dt)

    -- Update playership's last char (number) with the index of the selected option
    self.playerShip.ship = self.playerShip.ship:sub(0, self.playerShip.ship:len()-1) .. self.menu.sideOptionsSelected[1]
    self.playerShip.color = self.menu:getSelectedSideText(2)

    -- Update ship stats
    for name, stats in pairs(self.shipStats) do
        self.shipStatBars[name]:setValue(self:getShipStats(name, true))
        self.shipStatBars[name].outlineColor = color2rgb(self.playerShip.color)
    end

    -- Update variables for shooting
    self.shotIntervalTimer = self.shotIntervalTimer + dt
    self.shotTimer = self.shotTimer + dt
    self.shotInterval = self:getShipStats('shotInterval', false)
    self.playerShip.laserType = self:getShipStats('laserType', false)
    self.laserOffsets = SHIP_DEFS[self.playerShip.ship].laserOffsets

    -- ensure that ship is always centered (due to different ship widths)
    -- except when tweening ship to match level location
    if not self.tweening then
        self.playerShip.x = VIRTUAL_WIDTH / 2 - SHIP_DEFS[self.playerShip.ship].width / 2 - 120
    end

    -- shot or pause
    if self.shotDuration == 0 then
        self.shotDuration = math.random(5)
        self.shotWaitDuration = math.random(3)
    elseif self.shotTimer < self.shotDuration then
        self:shoot()
    elseif self.shotTimer > (self.shotDuration + self.shotWaitDuration) then
        self.shotDuration = math.random(5)
        self.shotWaitDuration = math.random(3)
        self.shotTimer = 0
    end

    for k, laser in pairs(self.lasers) do
        laser:update(dt)
    end
end

function SelectShipState:render()
    self.background:render()

    for k, laser in pairs(self.lasers) do
        laser:render()
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Select Your Ship', 0, VIRTUAL_HEIGHT / 2 - 240, VIRTUAL_WIDTH, 'center')

    self.menu:render()

    for k, bar in pairs(self.shipStatBars) do
        bar:render()
    end

    -- black rectangle for fade out (getting dark)
    love.graphics.setColor(0, 0, 0, self.blackAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['sheet'], gFrames['sheet'][Player.getFrame(self.playerShip)],
        self.playerShip.x, self.playerShip.y)
end

function SelectShipState:loadShip()
    if love.filesystem.getInfo(FILE_SHIP) then
        content, _ = love.filesystem.read(FILE_SHIP)
        self.playerShip = lunajson.decode(content)
        self.playerShip.y = self.shipY
        self.playerShip.x = VIRTUAL_WIDTH / 2 - SHIP_DEFS[self.playerShip.ship].width / 2 - 120
    else
        -- Default selected ship
        self.playerShip = {
            x = VIRTUAL_WIDTH / 2 - SHIP_DEFS["playerShip1"].width / 2 - 120,
            y = self.shipY,
            ship = "playerShip1",
            color = "Blue",
            -- for shooting laser
            type = "player",
            laserType = "05"
        }
    end
end