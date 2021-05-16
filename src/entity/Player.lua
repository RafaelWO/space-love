Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.level = def.level
    self.shotInterval = 0.4
    self.shotTimer = self.shotInterval      -- first shoot can be done immediately
end

function Player:update(dt)
    Entity.update(self, dt)
    
    self.shotTimer = self.shotTimer + dt
end

function Player:shoot(dt)
    if self.shotTimer > self.shotInterval then
        self.shotTimer = 0

        for i, xOffset in ipairs({0, self.width - 9}) do 
            table.insert(self.level.objects, Laser {
                x = self.x + xOffset,
                y = self.y + 26,
                texture = 'sheet',
                frame = 'laserBlue07'
            })
        end
        Event.dispatch('objects-changed')
    end
end