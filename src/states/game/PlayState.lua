PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"

    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        flySpeed = ENTITY_DEFS['player'].flySpeed,
        
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2,
        
        width = 99,
        height = 75,
    }

    self.player.stateMachine = StateMachine {
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['fly'] = function() return PlayerFlyState(self.player) end
    }
    self.player:changeState('idle')

    self.level = {}
end

function PlayState:update(dt)
    self.player:update(dt)
end

function PlayState:render()
    self.player:render()
    love.graphics.printf('Playing...', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
end