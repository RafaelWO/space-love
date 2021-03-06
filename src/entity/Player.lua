Player = Class{__includes = Entity}

function Player:init(x, y, def, level, params)
    Entity.init(self, x, y, def, level, params)

    self.jets = {}
    for _, jetDef in pairs(SHIP_DEFS[self.ship].jetOffset) do
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
    self.collisionDamageTimer = 0
    self.collisionDamageInterval = 1
    self.hasLowHealth = false

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
    self.healthBar = PlayerHealthBar {
        x = 20,
        y = 20,
        width = 150,
        height = 10,
        max = self.health,
        value = self.health
    }
end

function Player:update(dt)
    Entity.update(self, dt)
    self.collisionDamageTimer = self.collisionDamageTimer + dt

    for _, jet in pairs(self.jets) do
        jet:update(dt)
    end
    self.shield:update(dt)
    if self.shieldTimerBar then
        self.shieldTimerBar:update(dt)

        -- if shield is gone in 1 sec, it will blink
        if self.shieldTimerBar.value < 1 then
            self.shield:blink(1)
        end
    end

    if self.health <= 1 and not self.hasLowHealth then
        self.hasLowHealth = true
        Event.dispatch('health-low')
    elseif self.health > 1 and self.hasLowHealth then
        self.hasLowHealth = false
        Event.dispatch('health-ok')
    end
end

function Player:render()
    if not self.dead then
        for _, jet in pairs(self.jets) do
            jet:render()
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
            return true
        end
    end
    return false
end

function Player:changeJetState(name)
    for _, jet in pairs(self.jets) do
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
        x = HUD_PADDING,
        y = HUD_PADDING + HUD_ITEM_MARGIN,
        width = 150,
        height = 10,
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
