Meteor = Class{__includes = GameObject}

function Meteor:init(x, y, def)
    GameObject.init(self, x, y, def)

    if string.match(self.frame, "big") then
        
end

function Meteor:update(dt)
    GameObject.update(self, dt)

    if self.y > VIRTUAL_HEIGHT then
        self.toRemove = true
    else
        self.y = self.y + METEOR_SPEED * dt
    end
end