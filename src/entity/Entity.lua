--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(x, y, def)
    self.animations = self:createAnimations(def.animations)
    self.direction = 'up'

    self.width = def.width
    self.height = def.height

    self.x = x
    self.y = y

    self.flySpeed = def.flySpeed

    self.hitboxMargins = def.hitboxMargins
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
    local hitboxes = self:getHitBoxes()
    local collides = false
    for k, hitbox in pairs(hitboxes) do
        if hitbox:collides(target) then
            return true
        end
    end
    return false
end

function Entity:getHitBoxes()
    local hitboxes = {}
    for k, margin in pairs(self.hitboxMargins) do
        table.insert(hitboxes, getHitboxFromMargins(self, margin))
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
end

function Entity:update(dt)
    self.currentAnimation:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
end