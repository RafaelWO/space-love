Shield = Class{__includes = GameObject}

function Shield:init(x, y, def, params)
    GameObject.init(self, x, y, def, params)
end

function Shield:update(dt)
    GameObject.update(self, dt)

    if self.state == "down" then
        return
    end

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
        local yDiff = self.height - newHeight
        self.width = newWidth
        self.height = newHeight

        self.parentOffset.x = self.parentOffset.x + xDiff / 2
        self.x = self.parent.x + self.parentOffset.x
    end
end
