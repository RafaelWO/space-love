--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityBaseState = Class{}

function EntityBaseState:init(entity)
    self.entity = entity
end

function EntityBaseState:update(dt)
    
end

function EntityBaseState:enter() end
function EntityBaseState:exit() end
function EntityBaseState:processAI(params, dt) end

function EntityBaseState:render()
    self.entity.jet:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))

    if DEBUG then
        love.graphics.setColor(255, 0, 255, 255)
        love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
        love.graphics.setColor(255, 255, 255, 255)
        
        local hitboxes = self.entity:getHitBoxes()
        for k, hitbox in pairs(hitboxes) do
            love.graphics.setColor(0, 255, 255, 255)
            love.graphics.rectangle('line', hitbox.x, hitbox.y, hitbox.width, hitbox.height)
            love.graphics.setColor(255, 255, 255, 255)
        end
    end
end