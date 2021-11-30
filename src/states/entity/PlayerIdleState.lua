PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(enterParams)
    self.entity:changeJetState("idle")
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('fly')
    end

    if love.keyboard.isDown('space') then
        self.entity:shoot("up")
    end
end