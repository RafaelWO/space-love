Laser = Class{__includes = GameObject}

function Laser:init(def)
    GameObject.init(self, def)
    self.type = "Laser"
end

function Laser:update(dt)
    local speed = 600
    self.y = self.y - speed * dt

    if self.y <= 0 - self.height then
        self.toRemove = true
    end
end