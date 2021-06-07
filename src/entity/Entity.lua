--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(x, y, def, level)
    self.def = def
    self.animations = self:createAnimations(def.animations)
    self.direction = 'up'
    self.type = def.type
    self.level = level

    self.width = def.width
    self.height = def.height

    self.x = x
    self.y = y

    self.flySpeed = def.flySpeed
    self.attack = def.attack
    self.health = def.health
    self.dead = false

    -- so that enemies cannot move randomly to the bottom of the screen
    self.bottomScreenBarrier = (self.type == "player") and 0 or 200

    self.hitboxDefs = def.hitboxDefs
    self.laserDefs = def.laserDefs

    self.shotInterval = def.shotInterval
    self.shotIntervalTimer = 0
    self.shotDuration = 0
    self.shotWaitDuration = 0
    self.shotTimer = 0
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        print(k, animationDef.texture, animationDef.frames[1])
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
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

--[[
    Called when we interact with this entity, as by pressing enter.
]]
function Entity:onInteract()

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
        
        for i, offset in ipairs(self.laserDefs.offsets) do 
            table.insert(self.level.objects['lasers'], Laser (
                self.x + offset.x,
                self.y + offset.y,
                GAME_OBJECT_DEFS[self.laserDefs.type],
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
    end
end

function Entity:update(dt)
    self.shotIntervalTimer = self.shotIntervalTimer + dt
        
    self.currentAnimation:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
end