--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerFlyState = Class{__includes = EntityFlyState}

function PlayerFlyState:init(player)
    self.entity = player
end

function PlayerFlyState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
    else
        self.entity:changeState('idle')
    end

    if love.keyboard.isDown('space') then
        self.entity:shoot("up")
    end

    -- perform base collision detection against window borders
    EntityFlyState.update(self, dt)
end