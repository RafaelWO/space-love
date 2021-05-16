--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityFlyState = Class{__includes = EntityBaseState}

function EntityFlyState:init(entity)
    self.entity = entity
end

function EntityFlyState:update(dt)
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.flySpeed * dt
        
        if self.entity.x <= 0 then 
            self.entity.x = 0
            self.bumped = true
        end
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.flySpeed * dt

        if self.entity.x + self.entity.width >= VIRTUAL_WIDTH then
            self.entity.x = VIRTUAL_WIDTH - self.entity.width
            self.bumped = true
        end
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.flySpeed * dt

        if self.entity.y <= 0 then 
            self.entity.y = 0
            self.bumped = true
        end
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.flySpeed * dt

        if self.entity.y + self.entity.height >= VIRTUAL_HEIGHT then
            self.entity.y = VIRTUAL_HEIGHT - self.entity.height
            self.bumped = true
        end
    end
end

function EntityFlyState:processAI(params, dt)
    
end