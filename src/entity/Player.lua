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

    self.maxHealth = self.health
    self.hits = 0
    self.collisionDamageTimer = 0
    self.collisionDamageInterval = 1

    self:changeState('idle')
end

function Player:createDefaultStates()
    self.stateMachine = StateMachine {
        ['idle'] = function() return PlayerIdleState(self) end,
        ['fly'] = function() return PlayerFlyState(self) end
    }
end

function Player:createHealthbar()
    self.healthBar = ProgressBar {
        x = 10,
        y = 10,
        width = 150,
        height = 10,
        color = {r = 255, g = 255, b = 255},
        max = self.health,
        value = self.health,
        text = "health"
    }
end

function Player:update(dt)
    Entity.update(self, dt)
    self.collisionDamageTimer = self.collisionDamageTimer + dt
    
    self.jet:update(dt)
end

function Player:render()
    if not self.dead then
        Entity.render(self)

        if self.health < self.maxHealth then
            self:renderShipDamage()
        end
    end

    self.healthBar:render()
end

function Player:increaseHealth(amount)
    Timer.tween(0.5, {
        [self.healthBar] = {value = self.health + amount}
    })
    self.health = math.min(self.maxHealth, self.health + amount)
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

function Player:renderShipDamage()
    local shipDamage
    local damageInterval = self.maxHealth / 3
    if self.health < self.maxHealth - (damageInterval * 2) then
        shipDamage = 3
    elseif self.health < self.maxHealth - (damageInterval * 1) then
        shipDamage = 2
    elseif self.health < self.maxHealth - (damageInterval * 0) then
        shipDamage = 1
    end

    love.graphics.draw(gTextures['sheet'], gFrames['sheet'][self.ship .. '_damage' .. shipDamage],
        math.floor(self.x), math.floor(self.y))
end

function Player:getFrame()
    return self.ship .. '_' .. self.color:lower()
end
