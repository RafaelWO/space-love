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
    if self.entity.jet then
        self.entity.jet:render()
    end

    love.graphics.draw(gTextures[self.entity.texture], gFrames[self.entity.texture][self.entity:getFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))

    if self.entity.type == "player" and self.entity.health < self.entity.def.health then
        self:renderShipDamage()
    end

    if DEBUG then
        love.graphics.setColor(255, 0, 255, 255)
        love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
        love.graphics.setColor(255, 255, 255, 255)
        
        local hitboxes = self.entity:getHitboxes()
        for k, hitbox in pairs(hitboxes) do
            love.graphics.setColor(0, 255, 255, 255)
            love.graphics.rectangle('line', hitbox.x, hitbox.y, hitbox.width, hitbox.height)
            love.graphics.setColor(255, 255, 255, 255)
        end
    end
end

function EntityBaseState:renderShipDamage()
    local shipDamage
    local damageInterval = self.entity.def.health / 3
    if self.entity.health < self.entity.def.health - (damageInterval * 2) then
        shipDamage = 3
    elseif self.entity.health < self.entity.def.health - (damageInterval * 1) then
        shipDamage = 2
    elseif self.entity.health < self.entity.def.health - (damageInterval * 0) then
        shipDamage = 1
    end

    love.graphics.draw(gTextures['sheet'], gFrames['sheet'][self.entity.ship .. '_damage' .. shipDamage],
        math.floor(self.entity.x), math.floor(self.entity.y))
end