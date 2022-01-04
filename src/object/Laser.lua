Laser = Class{__includes = GameObject}

function Laser:init(x, y, def, direction, source)
    local specificDef = self:overrideDef(def, source)
    GameObject.init(self, x, y, specificDef)
    self.x = self.x - self.width / 2
    self.source = source
    self.direction = direction or "up"

    if self.direction == "left" then
        self.x = self.x - self.height
    end
    if self.direction == "left" or self.direction == "right" then
        self.x = self.x + self.width / 2
        self.y = self.y - self.width / 2

        -- Rotate by 90° (Attention: from now on width = height and vice versa)
        local width = self.width
        self.width = self.height
        self.height = width
        self.rotation = degree2radian(-90)
        self.rotOffsetX = self.height
    end

    if self.direction == "up" then
        self.y = self.y - self.height
    end
end

function Laser:updateInDirection(dt)
    if self.direction == "up" then
        self.y = self.y - PLAYER_LASER_SPEED * dt
    elseif self.direction == "down" then
        self.y = self.y + PLAYER_LASER_SPEED * dt
    elseif self.direction == "left" then
        self.x = self.x - PLAYER_LASER_SPEED * dt
    elseif self.direction == "right" then
        self.x = self.x + PLAYER_LASER_SPEED * dt
    end
end

function Laser:update(dt)
    GameObject.update(self, dt)

    if self.state == "fly" then
        self:updateInDirection(dt)
    end
end

function Laser:prepareForHit()
    if self.direction == "up" then
        self.y = self.y - (self.height / 4)
    elseif self.direction == "down" then
        self.y = self.y + (self.height / 4)
    elseif self.direction == "left" then
        self.x = self.x - (self.width / 4)
    elseif self.direction == "right" then
        self.x = self.x + (self.width / 4)
    end
end

function Laser:changeState(name)
    local changedState = GameObject.changeState(self, name)

    if changedState == "hit" then
        self:prepareForHit()
        gSounds['laser-2']:stop()
        gSounds['laser-2']:play()
        local animationLength = #self.states['hit'].frames * self.states['hit'].interval
        Timer.after(animationLength, function ()
            self.toRemove = true
        end)
    end
end

function Laser:overrideDef(def, source)
    local color = (source.type == "player" or source.type == "ufo") and "Blue" or "Red"
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