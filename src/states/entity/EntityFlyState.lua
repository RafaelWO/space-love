EntityFlyState = Class{__includes = EntityBaseState}

function EntityFlyState:init(entity)
    self.entity = entity

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
    self.initialMove = false
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

        if self.entity.y <= 25 + self.entity.screenBarrier.top then
            self.entity.y = 25 + self.entity.screenBarrier.top
            self.bumped = true
        end
    elseif self.entity.direction:contains('down') then
        self.entity.y = self.entity.y + self.entity.flySpeed * dt

        if self.entity.y + self.entity.height >= VIRTUAL_HEIGHT - 20 - self.entity.screenBarrier.bottom then
            self.entity.y = VIRTUAL_HEIGHT - 20 - self.entity.height - self.entity.screenBarrier.bottom
            self.bumped = true
        end
    end
end

function EntityFlyState:processAI(params, dt)
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 then
        -- set an initial move duration
        self.initialMove = true
        self.moveDuration = params.duration or math.random(2, 5)
    elseif self.bumped then
        self.moveDuration = math.random(2, 5)
        self.entity.direction:reset()
        self.entity.direction:add(directions[math.random(#directions)])
    elseif self.movementTimer > self.moveDuration and not self.initialMove then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(5) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(2, 5)
            self.entity.direction:reset()
            self.entity.direction:add(directions[math.random(#directions)])
        end
    end

    if self.initialMove and self.entity.y > 25 and self.entity.x > 0
            and self.entity.x < VIRTUAL_WIDTH - self.entity.width then
        self.initialMove = false
    end

    self.movementTimer = self.movementTimer + dt
end