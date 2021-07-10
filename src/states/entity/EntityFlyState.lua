--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityFlyState = Class{__includes = EntityBaseState}

function EntityFlyState:init(entity)
    self.entity = entity

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityFlyState:update(dt)
    self.bumped = false

    if self.entity.direction:contains('left') then
        self.entity.x = self.entity.x - self.entity.flySpeed * dt
        
        if self.entity.x <= 0 then 
            self.entity.x = 0
            self.bumped = true
        end
    elseif self.entity.direction:contains('right') then
        self.entity.x = self.entity.x + self.entity.flySpeed * dt

        if self.entity.x + self.entity.width >= VIRTUAL_WIDTH then
            self.entity.x = VIRTUAL_WIDTH - self.entity.width
            self.bumped = true
        end
    end

    if self.entity.direction:contains('up') then
        self.entity.y = self.entity.y - self.entity.flySpeed * dt

        if self.entity.y <= 0 then 
            self.entity.y = 0
            self.bumped = true
        end
    elseif self.entity.direction:contains('down') then
        self.entity.y = self.entity.y + self.entity.flySpeed * dt

        if self.entity.y + self.entity.height >= VIRTUAL_HEIGHT - self.entity.bottomScreenBarrier then
            self.entity.y = VIRTUAL_HEIGHT - self.entity.height - self.entity.bottomScreenBarrier
            self.bumped = true
        end
    end
end

function EntityFlyState:processAI(params, dt)
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = params.duration or math.random(3)
        self.entity.direction:reset()
        self.entity.direction:add(params.direction or directions[math.random(#directions)])
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction:reset()
            self.entity.direction:add(directions[math.random(#directions)])
        end
    end

    self.movementTimer = self.movementTimer + dt
end