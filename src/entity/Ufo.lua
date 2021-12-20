Ufo = Class{__includes = Entity}

function Ufo:init(x, y, def, level, params)
    Entity.init(self, x, y, def, level, params)
end

function Ufo:getFrame()
    return self.ship .. self.color
end

function Ufo:processAI(params, dt)
    self.stateMachine:processAI(params, dt)

    -- shoot all the time
    self:shoot()
end

function Ufo:createHealthbar()
    local barWidth = 100
    local offset = {
        x = self.width / 2 - barWidth / 2,
        y = -15 - HEALTH_BAR_TEXT_OFFSET
    }
    self.healthBar = ProgressBar {
        x = self.x + offset.x,
        y = self.y + offset.y,
        parent = self,
        parentOffset = offset,
        width = barWidth,
        height = 5,
        max = self.health,
        value = self.health,
        separators = true,
        text = "Friend"
    }
end

function Ufo:shoot()
    if self.shotIntervalTimer > self.shotInterval then
        self.shotIntervalTimer = 0
        
        local directions = {"up", "down", "left", "right"}
        for i, offset in ipairs(self.laserOffsets) do 
            table.insert(self.level.lasers, Laser (
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