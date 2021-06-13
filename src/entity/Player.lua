Player = Class{__includes = Entity}

function Player:init(x, y, def, level)
    Entity.init(self, x, y, def, level)

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

    self.hits = 0
    self.collisionDamageTimer = 0
    self.collisionDamageInterval = 1
end

function Player:update(dt)
    Entity.update(self, dt)
    self.collisionDamageTimer = self.collisionDamageTimer + dt
    
    self.jet:update(dt)
end

function Player:increaseHealth(amount)
    self.health = math.min(self.def.health, self.health + amount)
    if self.health <= 0 then
        self.level:gameOver()
    end
end

function Player:takeCollisionDamage(damage)
    if self.collisionDamageTimer > self.collisionDamageInterval then
        self.collisionDamageTimer = 0
        self:reduceHealth(damage)
    end
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
