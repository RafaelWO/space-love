StartState = Class{__includes = BaseState}

function StartState:init(params)
    self.name = "StartState"
    self.background = params.background or Background(MENU_BACKGROUND)
    
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
                gStateStack:push(SelectShipState({background = self.background}))
            end,
            function()
                gStateStack:pop()
                gStateStack:push(HighscoreState({background = self.background}))
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