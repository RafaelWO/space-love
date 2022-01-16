GameObject = Class{}

function GameObject:init(x, y, def, params)
    self.meta = "GameObject"
    self.type = def.type

    if not params then
        params = {}
    end

    self.texture = def.texture
    self.frame = def.frame or 1
    if params.color then
        self.frame = self.frame:gsub("<color>", params.color)
    end

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states
    self.toRemove = false

    if self.states then
        self.animations = self:createAnimations(self.states)
        self.currentAnimation = self.animations[self.state]
    end

    -- for moving down the screen
    self.speed = params.speed or 0

    -- follow a parent object
    self.parent = params.parent or nil
    self.parentOffset = params.parentOffset or { x = 0, y = 0}

    -- dimensions
    self.x = x
    self.y = y
    self.scale = def.scale or 1
    self.rotation = def.rotation or 0
    self.rotOffsetX = 0
    self.rotOffsetY = 0
    self.color = {r = 1, g = 1, b = 1, a = 1}

    -- get width and height from associated Quad
    if def.width and def.height then
        self.width, self.height = def.width, def.height
    else
        _, _, self.width, self.height = gFrames[self.texture][self.frame]:getViewport()
    end

    -- default empty collision callback
    self.onCollide = function() end
    
    self.consumable = def.consumable or false
    -- default empty consume callback
    self.onConsume = function() end
    
    -- for making an object blink
    self.blinking = false
    self.blinkTimer = 0
    self.blinkDuration = 0
    self.blinkDurationTimer = 0
    self.blinkInterval = 0

    self.timers = {}
end

function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'sheet',
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping
        }
    end

    return animationsReturned
end

function GameObject:changeState(name)
    if self.states == nil then
        return false
    end

    local newState = nil
    for key, value in pairs(self.states) do
        if key == name then
            newState = name
        end
    end
    if newState and newState ~= self.state then
        self.state = newState
        self.currentAnimation = self.animations[newState]

        -- Sometimes the sprite for the new state differs in terms of size
        if self.states[newState].width ~= nil then
            self.x = self.x + self.width / 2 - self.states[newState].width / 2
            self.width = self.states[newState].width
        elseif self.states[newState].height ~= nil then
            self.y = self.y + self.height / 2 - self.states[newState].height / 2
            self.height = self.states[newState].height or self.height
        end

        return newState
    end

    return false
end

function GameObject:update(dt)
    Timer.update(dt, self.timers)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.y > VIRTUAL_HEIGHT or self.y < -200 or self.x > VIRTUAL_WIDTH or self.x < -self.width then
        self.toRemove = true
    else
        self.y = self.y + self.speed * dt
    end

    if self.parent then
        self.x = self.parent.x + self.parentOffset.x
        self.y = self.parent.y + self.parentOffset.y
    end

    if self.blinking then
        self.blinkTimer = self.blinkTimer + dt
        self.blinkDurationTimer = self.blinkDurationTimer + dt

        if self.blinkDurationTimer > self.blinkDuration then
            self.blinking = false
            self.blinkTimer = 0
            self.blinkDurationTimer = 0
        end
    end
end

--[[
    Simple AABB
]]
function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:getCenter()
    return self.x + self.width / 2, self.y + self.height / 2
end

function GameObject:blink(duration, interval)
    self.blinking = true
    self.blinkDuration = duration or 1
    self.blinkInterval = interval or 0.2
end

function GameObject:render()
    if self.blinking then
        if self.blinkTimer > self.blinkInterval / 2 then
            love.graphics.setColor(self.color.r, self.color.b, self.color.g, 16/255)
        end
        if self.blinkTimer > self.blinkInterval then
            self.blinkTimer = 0
        end
    else
        love.graphics.setColor(self.color.r, self.color.b, self.color.g, self.color.a)
    end

    local frame
    if self.states == nil then
        frame = self.frame
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][frame],
            math.floor(self.x), math.floor(self.y), self.rotation, self.scale, self.scale, self.rotOffsetX, self.rotOffsetY)
    else
        local anim = self.currentAnimation
        if self.currentAnimation:getCurrentFrame() then
            love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
                math.floor(self.x), math.floor(self.y), self.rotation, self.scale, self.scale, self.rotOffsetX, self.rotOffsetY)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
    
    if DEBUG then
        love.graphics.setColor(100/255, 100/255, 100/255, 1)
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1, 1)

        if self.type == "meteor" then
            local hitbox = self:getHitbox()
            love.graphics.setColor(0, 1, 1, 1)
            love.graphics.rectangle('line', hitbox.x, hitbox.y, hitbox.width, hitbox.height)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end