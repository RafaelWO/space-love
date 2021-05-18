Laser = Class{__includes = GameObject}

function Laser:init(x, y, def)
    GameObject.init(self, x, y, def)
    self.type = "Laser"
end

function Laser:update(dt)
    GameObject.update(self, dt)

    if self.y <= 100 then       -- TODO: Change to do only on collision
        self:changeState('hit')
        local animationLength = #self.states['hit'].frames * self.states['hit'].interval
        Timer.after(animationLength, function ()
            self.toRemove = true
        end)
    else
        self.y = self.y - PLAYER_LASER_SPEED * dt
    end
end