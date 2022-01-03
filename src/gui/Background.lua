Background = Class{}

function Background:init(sprite)
    self.sprite = sprite or BACKGROUNDS[math.random(#BACKGROUNDS)]
    self.bgOffsetY = 0
    self.bgRepeat = {
        x = math.ceil(VIRTUAL_WIDTH / BACKGROUND_SIZE),
        y = math.ceil(VIRTUAL_HEIGHT / BACKGROUND_SIZE)
    }

    self.nebulaType = 0
    self.nebulaTimer = 0
    self.nebulaEta = 30
    self.nebulaY = 0
    self.nebulaX = 0
    self.nebulaScale = 0
    self.drawNebula = false
end

function Background:update(dt)
    self.bgOffsetY = self.bgOffsetY + BACKGROUND_SPEED * dt
    
    if self.bgOffsetY >= BACKGROUND_SIZE then
        self.bgOffsetY = 0
    end

    if not self.drawNebula then
        self.nebulaTimer = self.nebulaTimer + dt

        if self.nebulaTimer >= self.nebulaEta then
            self.nebulaScale = math.random()
            self.nebulaY = -self.nebulaScale * NEBULA_HEIGHT
            self.nebulaX = math.random(-NEBULA_WIDTH * self.nebulaScale / 2, VIRTUAL_WIDTH - (NEBULA_WIDTH * self.nebulaScale / 2))
            self.nebulaType = math.random(1, 3)
            print("Nebula of type " .. self.nebulaType .. " spawned")
            print("X:", self.nebulaX)
            print("Y:", self.nebulaY)
            print("Scale:", self.nebulaScale)
            self.drawNebula = true
        end
    end

    if self.drawNebula then
        self.nebulaY = self.nebulaY + NEBULA_SPEED * dt
        if self.nebulaY > VIRTUAL_HEIGHT then
            self.drawNebula = false
            self.nebulaEta = math.random(20, 40)
            print("Nebula drawing done. Next one appears in " .. self.nebulaEta .. " seconds")
        end
    end
end

function Background:render()
    for x = 0, self.bgRepeat.x, 1 do
        for y = -1, self.bgRepeat.y, 1 do
            love.graphics.draw(gTextures[self.sprite], x * BACKGROUND_SIZE, y * BACKGROUND_SIZE + self.bgOffsetY)
        end
    end

    if self.drawNebula then
        love.graphics.draw(gTextures['nebula-' .. self.nebulaType], self.nebulaX, self.nebulaY, 0, self.nebulaScale, self.nebulaScale)
    end
end