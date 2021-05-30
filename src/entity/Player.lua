Player = Class{__includes = Entity}

function Player:init(x, y, def, level)
    Entity.init(self, x, y, def, level)
    self.shotInterval = 0.4

    local jetOffset = {
        x = self.width / 2 - GAME_OBJECT_DEFS['jet'].width / 2,
        y = self.height - 5
    }
    self.jet = Jet (
        self.x + jetOffset.x,
        self.y + jetOffset.y,
        GAME_OBJECT_DEFS['jet'],
        self,
        jetOffset
    )
end

function Player:update(dt)
    Entity.update(self, dt)
    
    self.jet:update(dt)
end

function Player:changeState(name)
    Entity.changeState(self, name)

    if name == "fly" then
        self.jet:changeState('pre-fly')
        Timer.after(0.1, function () self.jet:changeState(name) end)
    elseif name == "idle" then
        self.jet:changeState('pre-fly')
        Timer.after(0.1, function () self.jet:changeState(name) end)
    end
end

function Player:shoot()
    if self.shotIntervalTimer > self.shotInterval then
        self.shotIntervalTimer = 0

        for i, xOffset in ipairs({0, self.width - 9}) do 
            table.insert(self.level.objects['lasers'], Laser (
                self.x + xOffset,
                self.y + 26,
                GAME_OBJECT_DEFS['laser-blue'],
                "up"
            ))
        end
        gSounds['laser-1']:stop()
        gSounds['laser-1']:play()
        Event.dispatch('objects-changed')
    end
end