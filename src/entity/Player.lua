Player = Class{__includes = Entity}

function Player:init(x, y, def, level)
    Entity.init(self, x, y, def, level)

    self.jets = {}
    for k, jetDef in pairs(SHIP_DEFS[self.ship].jetOffset) do
        table.insert(self.jets, GameObject(
            self.x + jetDef.x,
            self.y + jetDef.y,
            GAME_OBJECT_DEFS['jet'],
            {
                parent = self,
                parentOffset = jetDef
            }
        ))
    end

    self.maxHealth = self.health
    self.hits = 0
    self.collisionDamageTimer = 0
    self.collisionDamageInterval = 1

    local shieldOffset = {
        x = self.width / 2 - GAME_OBJECT_DEFS['shield'].width / 2,
        y = -35
    }
    self.shield = Shield(
        self.x,
        self.y,
        GAME_OBJECT_DEFS['shield'],
        {
            parent = self,
            parentOffset = shieldOffset
        }
    )
    self.shieldTimerBar = nil

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
        text = "health",
        separators = true
    }
end

function Player:update(dt)
    Entity.update(self, dt)
    self.collisionDamageTimer = self.collisionDamageTimer + dt
    
    for k, jet in pairs(self.jets) do
        jet:update(dt)
    end
    self.shield:update(dt)
    if self.shieldTimerBar then
        self.shieldTimerBar:update(dt)
    end

    if self.health <= 1 and not gSounds['health-alarm']:isPlaying() then
        gSounds['health-alarm']:play()
    elseif self.health > 1 and gSounds['health-alarm']:isPlaying() then
        gSounds['health-alarm']:stop()
    end
end

function Player:render()
    if not self.dead then
        for k, jet in pairs(self.jets) do
            jet:render(dt)
        end

        Entity.render(self)

        if self.health < self.maxHealth then
            love.graphics.setShader(self.whiteShader)
            self.whiteShader:send('WhiteFactor', self.blinking and 1 or 0)
            self:renderShipDamage()
            love.graphics.setShader()
        end

        self.shield:render()
        if self.shieldTimerBar then
            self.shieldTimerBar:render()
        end
    end
end

function Player:increaseHealth(amount)
    local newHealth = math.min(self.maxHealth, self.health + amount)
    Timer.tween(0.5, {
        [self.healthBar] = {value = newHealth}
    }):group(self.timers)
    self.health = newHealth
end

function Player:takeCollisionDamage(damage)
    if self.collisionDamageTimer > self.collisionDamageInterval then
        self.collisionDamageTimer = 0
        if self:reduceHealth(damage) then
            gSounds['collision']:stop()
            gSounds['collision']:play()
        end
    end
end

function Player:changeJetState(name)
    for k, jet in pairs(self.jets) do
        if name == "fly" then
            jet:changeState('pre-fly')
        elseif name == "idle" then
            jet:changeState('pre-fly')
        end
        Timer.after(0.1, function () jet:changeState(name) end):group(self.timers)
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

function Player:getHitboxes()
    if self.shield.state == "down" then
        return Entity.getHitboxes(self)
    else
        return self.shield:getHitboxes()
    end
end

function Player:shieldUp(time)
    if self.shield.state == "up" then
        return
    end

    self.invulnerable = true
    self.shield:changeState('up')
    gSounds['shield-up']:stop()
    gSounds['shield-up']:play()

    self.shieldTimerBar = ProgressBar {
        x = 10,
        y = 50,
        width = 150,
        height = 10,
        color = {r = 255, g = 255, b = 255},
        max = time,
        value = time,
        text = "shield"
    }

    Timer.tween(time, {
        [self.shieldTimerBar] = {value = 0}
    }):finish(function ()
        self.invulnerable = false
        self.shield:changeState('down')
        self.shieldTimerBar = nil
        gSounds['shield-down']:stop()
        gSounds['shield-down']:play()
    end):group(self.timers)
end
