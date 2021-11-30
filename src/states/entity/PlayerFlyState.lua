PlayerFlyState = Class{__includes = EntityFlyState}

function PlayerFlyState:init(player)
    self.entity = player
end

function PlayerFlyState:enter(enterParams)
    self.entity:changeJetState("fly")
end

function PlayerFlyState:update(dt)
    self.entity.direction:reset()

    if love.keyboard.isDown('left') then
        self.entity.direction:add('left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction:add('right')
    end
    
    if love.keyboard.isDown('up') then
        self.entity.direction:add('up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction:add('down')
    end
    
    if self.entity.direction:isEmpty() then
        self.entity:changeState('idle')
    end

    if love.keyboard.isDown('space') then
        self.entity:shoot("up")
    end

    -- perform movement and base collision detection against window borders
    EntityFlyState.update(self, dt)
end