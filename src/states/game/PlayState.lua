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
end

function PlayState:exit()
    
end