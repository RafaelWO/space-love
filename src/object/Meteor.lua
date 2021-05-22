Meteor = Class{__includes = GameObject}

function Meteor:init(x, y, def)
    GameObject.init(self, x, y, def)

    self.hitmargin = 2
    if string.match(self.frame, "_big") then
        -- hitbox for big meteors is smaller by 10 on each side
        self.hitmargin = 10 
    elseif string.match(self.frame, "_med") then
        self.hitmargin = 5
    end
end

function Meteor:update(dt)
    GameObject.update(self, dt)

    if self.y > VIRTUAL_HEIGHT then
        self.toRemove = true
    else
        self.y = self.y + METEOR_SPEED * dt
    end
end

function Meteor:collides(target)
    local hitbox = self:getHitBox()
    return not (hitbox.x + hitbox.width < target.x or hitbox.x > target.x + target.width or
                hitbox.y + hitbox.height < target.y or hitbox.y > target.y + target.height)
end

function Meteor:getHitBox()
    local x = self.x + self.hitmargin
    local y = self.y + self.hitmargin
    local width = self.width - self.hitmargin * 2
    local height = self.height - self.hitmargin * 2
    
    return { x = x, y = y, width = width, height = height }
end