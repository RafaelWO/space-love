Background = Class{}

function Background:init(sprite)
    self.sprite = sprite or BACKGROUNDS[math.random(#BACKGROUNDS)]
    self.bgOffsetY = 0
end

function Background:update(dt)
    self.bgOffsetY = self.bgOffsetY + BACKGROUND_SPEED * dt
    
    if self.bgOffsetY >= BACKGROUND_SIZE then
        self.bgOffsetY = 0
    end
end

function Background:render()
    for x = 0, 4, 1 do
        for y = -1, 3, 1 do
            love.graphics.draw(gTextures[self.sprite], x * BACKGROUND_SIZE, y * BACKGROUND_SIZE + self.bgOffsetY)
        end
    end
end