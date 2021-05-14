PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"
end

function PlayState:update(dt)

end

function PlayState:render()
    love.graphics.printf('Playing...', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
    local sheet = love.graphics.newImage('SpaceShooterRedux/Spritesheet/sheet.png')
    love.graphics.draw(gTextures['sheet'], gFrames['sheet']['playerShip1_blue'], 0, 0)
end