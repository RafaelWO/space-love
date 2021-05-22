PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"

    self.level = Level()
end

function PlayState:update(dt)
    self.level:update(dt)

    if love.keyboard.wasPressed('p') then
        self.level.bgScrolling = not self.level.bgScrolling
    end
end

function PlayState:render()
    self.level:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Playing...', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
end