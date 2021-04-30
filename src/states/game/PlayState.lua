PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"
end

function PlayState:update(dt)

end

function PlayState:render()
    love.graphics.printf('Playing...', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
end