--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(x, y, def, level)
    self.direction = 'down'
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

    -- https://love2d.org/forums/viewtopic.php?t=79617
    -- white shader that will turn a sprite completely white when used; allows us
    -- to brightly blink the sprite when it's acting
    self.whiteShader = love.graphics.newShader[[
        extern float WhiteFactor;

        vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
        {
            vec4 outputcolor = Texel(tex, texcoord) * vcolor;
            outputcolor.rgb += vec3(WhiteFactor);
            return outputcolor;
        }
    ]]
    self.blinking = false

    self:createDefaultStates()
    self:createHealthbar()
end

function Entity:createDefaultStates()
    self.stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self) end,
        ['fly'] = function() return EntityFlyState(self) end
    }

    self:changeState('fly')
end

function Entity:createHealthbar()
    local barWidth = 100
    local offset = {
        x = self.width / 2 - barWidth / 2,
        y = -20
    }
    self.healthBar = ProgressBar {
        x = self.x + offset.x,
        y = self.y + offset.y,
        parent = self,
        parentOffset = offset,
        width = barWidth,
        height = 3,
        color = {r = 255, g = 255, b = 255},
        max = self.health,
        value = self.health
    }
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

    if self.y < 0 then
        return
    end

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
    if self.healthBar then
        Timer.tween(0.25, {
            [self.healthBar] = {value = self.health - damage}
        })
    end
    self.health = math.max(0, self.health - damage)

    if self.health <= 0 and not self.dead then
        self.dead = true
        self.diedNow = true
    end

    Timer.every(0.1, function()
        self.blinking = not self.blinking
    end)
    :limit(4)
end

function Entity:update(dt)
    self.shotIntervalTimer = self.shotIntervalTimer + dt
        
    self.stateMachine:update(dt)
    self.healthBar:update(dt)
end

function Entity:render()
    -- if blinking is set to true, we'll send 1 to the white shader, which will
    -- convert every pixel of the sprite to pure white
    love.graphics.setShader(self.whiteShader)
    self.whiteShader:send('WhiteFactor', self.blinking and 1 or 0)
    self.stateMachine:render()
    love.graphics.setShader()

    if self.type ~= "player" then
        self.healthBar:render()
    end
end