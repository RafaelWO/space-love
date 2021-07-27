PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"

    self.musicIdx = 1
    print("Music: " .. self.musicIdx)
    gSounds['music-lvl' .. self.musicIdx]:setLooping(true)
    gSounds['music-lvl' .. self.musicIdx]:play()
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
    gSounds['music-lvl' .. self.musicIdx]:stop()
end