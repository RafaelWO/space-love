Ufo = Class{__includes = Entity}

function Ufo:init(x, y, def, level, params)
    Entity.init(self, x, y, def, level, params)
    print(self:getFrame())
end

function Ufo:getFrame()
    return self.ship .. self.color
end

function Ufo:processAI(params, dt)
    self.stateMachine:processAI(params, dt)

    if self.shotDuration == 0 then
        self.shotDuration = math.random(4)
        self.shotWaitDuration = math.random(3)
    elseif self.shotTimer < self.shotDuration then
        self:shoot()
    elseif self.shotTimer > (self.shotDuration + self.shotWaitDuration) then
        self.shotDuration = math.random(4)
        self.shotWaitDuration = math.random(3)
        self.shotTimer = 0
    end

    self.shotTimer = self.shotTimer + dt
end

function Ufo:shoot()
    if self.shotIntervalTimer > self.shotInterval then
        self.shotIntervalTimer = 0
        
        local directions = {"up", "down", "left", "right"}
        for i, offset in ipairs(self.laserOffsets) do 
            table.insert(self.level.objects['lasers'], Laser (
                self.x + offset.x,
                self.y + offset.y,
                GAME_OBJECT_DEFS[self.laser],
                directions[i],
                self
            ))
        end

        gSounds['laser-1']:stop()
        gSounds['laser-1']:play()
        Event.dispatch('objects-changed')
    end
end