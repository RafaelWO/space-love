Laser = Class{__includes = GameObject}

function Laser:init(x, y, def)
    GameObject.init(self, x, y, def)
end

function Laser:update(dt)
    GameObject.update(self, dt)

    if self.y <= 100 then       -- TODO: Change to do only on collision
        self:changeState('hit')
    elseif self.state == "flying" then
        self.y = self.y - PLAYER_LASER_SPEED * dt
    end
end

function Laser:changeState(name)
    local changedState = GameObject.changeState(self, name)

    if changedState == "hit" then
        local animationLength = #self.states['hit'].frames * self.states['hit'].interval
        Timer.after(animationLength, function ()
            self.toRemove = true
        end)
    end
end