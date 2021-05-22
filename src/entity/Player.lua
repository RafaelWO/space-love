Player = Class{__includes = Entity}

function Player:init(x, y, def, level)
    Entity.init(self, x, y, def)
    self.level = level
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
            table.insert(self.level.objects['lasers'], Laser (
                self.x + xOffset,
                self.y + 26,
                GAME_OBJECT_DEFS['laser-blue']
            ))
        end
        gSounds['laser-1']:stop()
        gSounds['laser-1']:play()
        Event.dispatch('objects-changed')
    end
end