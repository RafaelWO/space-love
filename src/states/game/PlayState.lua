PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"

    local musicIdx = math.random(3)
    print("Music: " .. musicIdx)
    gSounds['music-lvl' .. musicIdx]:setLooping(true)
    gSounds['music-lvl' .. musicIdx]:play()
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