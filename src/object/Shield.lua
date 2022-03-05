Shield = Class{__includes = GameObject}

function Shield:init(x, y, def, params)
    GameObject.init(self, x, y, def, params)
end

function Shield:update(dt)
    GameObject.update(self, dt)

    if self.state == "down" then
        return
    end

    -- Unfortunately, the shield sprite has different dimensions for every frame
    -- Therefore, we need to update the width and height every time
    local newWidth = self.width
    local newHeight = self.height
    if self.currentAnimation.currentFrame == 2 then
        newWidth = 143
        newHeight = 119
    elseif self.currentAnimation.currentFrame == 3 then
        newWidth = 144
        newHeight = 137
    end

    if newWidth ~= self.width and newHeight ~= self.height then
        local xDiff = self.width - newWidth

        self.width = newWidth
        self.height = newHeight

        self.parentOffset.x = self.parentOffset.x + xDiff / 2
        self.x = self.parent.x + self.parentOffset.x
    end
end

function Shield:getHitboxes()
    return {
        Hitbox(self.x + 30, self.y + 10, 84, 108),
        Hitbox(self.x + 15, self.y + 25, 114, 93),
        Hitbox(self.x + 5, self.y + 45, 134, 73),
    }
end
