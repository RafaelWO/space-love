GameObject = Class{}

function GameObject:init(x, y, def)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

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

    -- dimensions
    self.x = x
    self.y = y
    self.scale = def.scale or 1

    -- get width and height from associated Quad
    if def.width and def.height then
        self.width, self.height = def.width, def.height
    else
        print(self.texture, self.frame)
        _, _, self.width, self.height = gFrames[self.texture][self.frame]:getViewport()
    end

    -- default empty collision callback
    self.onCollide = function() end
    
    self.consumable = def.consumable or false
    -- default empty consume callback
    self.onConsume = function() end
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

        -- Sometimes the sprite changes is terms of size for another state
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
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

--[[
    Simple AABB
]]
function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:render()
    local frame
    if self.states == nil then
        frame = self.frame
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][frame],
            math.floor(self.x), math.floor(self.y), 0, self.scale, self.scale)
    else
        local anim = self.currentAnimation
        love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            math.floor(self.x), math.floor(self.y))
    end
    
    if DEBUG then
        love.graphics.setColor(255, 0, 255, 255)
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
        love.graphics.setColor(255, 255, 255, 255)

        if self.type == "meteor" then
            love.graphics.setColor(0, 255, 255, 255)
            love.graphics.rectangle('line', self:getHitBox())
            love.graphics.setColor(255, 255, 255, 255)
        end
    end
end