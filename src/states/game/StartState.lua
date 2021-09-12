StartState = Class{__includes = BaseState}

function StartState:init()
    self.name = "StartState"
    self.background = Background('bg_black')
    
    gSounds['music-title-screen']:setLooping(true)
    gSounds['music-title-screen']:play()

    self.menu = Menu {
        y = VIRTUAL_HEIGHT / 2,
        texts = {
            "Play",
            "Highscore",
            "Quit"
        },
        callbacks = {
            function()
                gStateStack:pop()
                gStateStack:push(SelectShipState())
            end,
            function()
                gStateStack:pop()
                gStateStack:push(HighscoreState())
            end,
            function()
                love.event.quit()
            end
        }
    }
end

function StartState:update(dt)
    self.menu:update(dt)
    self.background:update(dt)
end

function StartState:render()
    self.background:render()
    -- love.graphics.setBackgroundColor(0.5,0,1)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Space Love', 0, VIRTUAL_HEIGHT / 2 - 100, VIRTUAL_WIDTH, 'center')

    self.menu:render()
end