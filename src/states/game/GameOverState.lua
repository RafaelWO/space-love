GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.name = "GameOverState"
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop()
        gStateStack:push(PlayState())
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press [ENTER] to restart', 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')
end