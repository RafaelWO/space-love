Laser = Class{__includes = GameObject}

function Laser:init(x, y, def, direction, source)
    GameObject.init(self, x, y, def)
    self.source = source
    self.direction = direction or "up"
    self.directionMultiplier = (self.direction == "up") and -1 or 1
end

function Laser:update(dt)
    GameObject.update(self, dt)

    if self.state == "fly" then
        self.y = self.y + PLAYER_LASER_SPEED * self.directionMultiplier * dt
    end
end

function Laser:changeState(name)
    local changedState = GameObject.changeState(self, name)

    if changedState == "hit" then
        self.y = self.y + (self.height / 4) * self.directionMultiplier
        gSounds['laser-2']:stop()
        gSounds['laser-2']:play()
        local animationLength = #self.states['hit'].frames * self.states['hit'].interval
        Timer.after(animationLength, function ()
            self.toRemove = true
        end)
    end
end