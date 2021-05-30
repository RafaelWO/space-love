StartState = Class{__includes = BaseState}

function StartState:init()
    self.name = "StartState"
    self.backgroundSounds = {'laser-1', 'laser-2', 'two-tone'}
    self.soundTimer = Timer.every(5, 
        function () 
            local soundIdx = math.random(#self.backgroundSounds)
            gSounds[self.backgroundSounds[soundIdx]]:play()
        end
    )
    
    gSounds['music-title-screen']:setLooping(true)
    gSounds['music-title-screen']:play()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.soundTimer:remove()
        gSounds['music-title-screen']:stop()
        gStateStack:pop()
        gStateStack:push(PlayState())
    end
end

function StartState:render()
    love.graphics.setBackgroundColor(0.5,0,1)
    love.graphics.setColor(34, 34, 34, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Space Love', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
end