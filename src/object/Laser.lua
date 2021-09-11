Laser = Class{__includes = GameObject}

function Laser:init(x, y, def, direction, source)
    local specificDef = self:overrideDef(def, source)
    GameObject.init(self, x, y, specificDef)
    self.x = self.x - self.width / 2
    self.source = source
    self.direction = direction or "up"
    self.directionMultiplier = (self.direction == "up") and -1 or 1

    if self.direction == "up" then
        self.y = self.y - self.height
    end
end

function Laser:update(dt)
    GameObject.update(self, dt)

    if self.state == "fly" then
        self.y = self.y + PLAYER_LASER_SPEED * self.directionMultiplier * dt
    end
end

function Laser:changeState(name)
    local changedState = GameObject.changeState(self, name)

    if changedState == "hit" then
        self.y = self.y + (self.height / 4) * self.directionMultiplier
        gSounds['laser-2']:stop()
        gSounds['laser-2']:play()
        local animationLength = #self.states['hit'].frames * self.states['hit'].interval
        Timer.after(animationLength, function ()
            self.toRemove = true
        end)
    end
end

function Laser:overrideDef(def, source)
    local color = (source.type == "player") and "Blue" or "Red"
    local newDef = table.deepcopy(def)
    newDef.frame = newDef.frame:gsub("<color>", color):gsub("<type>", source.laserType)
    for k, state in pairs(newDef.states) do
        for j, frame in pairs(state.frames) do
            newDef.states[k].frames[j] = frame:gsub("<color>", color):gsub("<type>", source.laserType)
        end
    end

    return newDef
end

function Laser:stickToObject(object)
    self.parent = object
    self.parentOffset = {
        x = self.x - object.x,
        y = self.y - object.y
    }
end