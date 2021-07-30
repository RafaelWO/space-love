StartState = Class{__includes = BaseState}

function StartState:init()
    self.name = "StartState"
    
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
                gSounds['music-title-screen']:stop()
                gStateStack:pop()
                gStateStack:push(PlayState())
            end,
            function()
            end,
            function()
                love.event.quit()
            end
        }
    }
end

function StartState:update(dt)
    self.menu:update(dt)
end

function StartState:render()
    love.graphics.setBackgroundColor(0.5,0,1)
    love.graphics.setColor(150, 150, 150, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Space Love', 0, VIRTUAL_HEIGHT / 2 - 100, VIRTUAL_WIDTH, 'center')

    self.menu:render()
end