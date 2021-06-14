--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(x, y, def, level)
    self.def = def
    self.direction = 'up'
    self.type = def.type
    self.level = level

    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.ship = def.ship
    self.color = def.color
    self.laser = def.laser
    
    self.x = x
    self.y = y

    self.flySpeed = def.flySpeed
    self.attack = def.attack
    self.health = def.health
    self.dead = false
    self.diedNow = false

    -- so that enemies cannot move randomly to the bottom of the screen
    self.bottomScreenBarrier = (self.type == "player") and 0 or 200

    self.hitboxDefs = SHIP_DEFS[self.ship].hitboxDefs
    self.laserOffsets = SHIP_DEFS[self.ship].laserOffsets

    self.shotInterval = def.shotInterval
    self.shotIntervalTimer = 0
    self.shotDuration = 0
    self.shotWaitDuration = 0
    self.shotTimer = 0
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:getFrame()
    local typeIdx = self.ship:len()
    return self.ship:sub(0, typeIdx - 1) .. self.color .. self.ship:sub(typeIdx)
end

--[[
    Simple AABB
]]
function Entity:collides(target)
    local hitboxes = self:getHitboxes()
    local collides = false
    for k, hitbox in pairs(hitboxes) do
        if hitbox:collides(target) then
            return true
        end
    end
    return false
end

function Entity:getHitboxes()
    if not self.hitboxDefs then
        return { Hitbox(self.x, self.y, self.width, self.height) }
    end

    local hitboxes = {}
    for k, def in pairs(self.hitboxDefs) do
        table.insert(hitboxes, getHitboxFromDef(self, def))
    end
    return hitboxes
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)

    if self.shotDuration == 0 then
        self.shotDuration = math.random(4)
        self.shotWaitDuration = math.random(3)
    elseif self.shotTimer < self.shotDuration then
        self:shoot("down")
    elseif self.shotTimer > (self.shotDuration + self.shotWaitDuration) then
        self.shotDuration = math.random(4)
        self.shotWaitDuration = math.random(3)
        self.shotTimer = 0
    end

    self.shotTimer = self.shotTimer + dt
end

function Entity:shoot(direction)
    if self.shotIntervalTimer > self.shotInterval then
        self.shotIntervalTimer = 0
        
        for i, offset in ipairs(self.laserOffsets) do 
            table.insert(self.level.objects['lasers'], Laser (
                self.x + offset.x,
                self.y + offset.y,
                GAME_OBJECT_DEFS[self.laser],
                direction,
                self
            ))
        end

        gSounds['laser-1']:stop()
        gSounds['laser-1']:play()
        Event.dispatch('objects-changed')
    end
end

function Entity:reduceHealth(damage)
    local dmg = damage or 1
    self.health = math.max(0, self.health - dmg)
    if self.health <= 0 then
        self.dead = true
        self.diedNow = true
    end
end

function Entity:update(dt)
    self.shotIntervalTimer = self.shotIntervalTimer + dt
        
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
end