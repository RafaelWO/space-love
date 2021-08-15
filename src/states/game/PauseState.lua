PauseState = Class{__includes = BaseState}

function PauseState:init(levelMusic)
    self.name = "PauseState"
    self.levelMusic = levelMusic
end

function PauseState:enter()
    self.levelMusic:pause()
    gSounds['pause-start']:play()
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        gSounds['pause-end']:play()
        Timer.after(1, function() gStateStack:pop() end)
    end
end

function PauseState:render()
    love.graphics.setColor(0, 0, 0, 150)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Game paused", 0, VIRTUAL_HEIGHT / 2 - 200, VIRTUAL_WIDTH, 'center')
end

function PauseState:exit()
    self.levelMusic:resume()
end