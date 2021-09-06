SelectShipState = Class{__includes = BaseState}

function SelectShipState:init()
    self.name = "SelectShipState"

    self.menu = Menu {
        y = VIRTUAL_HEIGHT / 2 + 80,
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
                "Base", "Sniper"
            },
            {
                "Blue", "Green"
            },
            nil
        }
    }

    self.playerShip = {
        ship = "playerShip1",
        color = "Blue"
    }
end

function SelectShipState:update(dt)
    self.menu:update(dt)

    -- Update playership's last char (number) with the index of the selected option
    self.playerShip.ship = self.playerShip.ship:sub(0, self.playerShip.ship:len()-1) .. self.menu.sideOptionsSelected[1]
    self.playerShip.color = self.menu:getSelectedSideText(2)
end

function SelectShipState:render()
    love.graphics.setBackgroundColor(0.5,0,1)
    love.graphics.setColor(250, 250, 250, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Select Ship', 0, VIRTUAL_HEIGHT / 2 - 200, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(gTextures['sheet'], gFrames['sheet'][Player.getFrame(self.playerShip)],
        VIRTUAL_WIDTH / 2 - SHIP_DEFS[self.playerShip.ship].width / 2, VIRTUAL_HEIGHT / 2 - SHIP_DEFS[self.playerShip.ship].height / 2 - 50)

    self.menu:render()
end