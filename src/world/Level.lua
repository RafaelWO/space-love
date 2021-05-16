Level = Class{}

function Level:init()
    self.objects = {}
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        flySpeed = ENTITY_DEFS['player'].flySpeed,
        
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2,
        
        width = 99,
        height = 75,

        level = self
    }

    self.player.stateMachine = StateMachine {
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['fly'] = function() return PlayerFlyState(self.player) end
    }
    self.player:changeState('idle')

    Event.on('objects-changed', function()
        local logString = ""
        for k, object in pairs(self.objects) do
            logString = logString .. " | " .. object.type
        end
        print(logString)
    end
    )

    self.bgOffsetY = 0
    self.bgSpeed = 100
    self.bgScrolling = true
end

function Level:update(dt)
    for k, object in pairs(self.objects) do
        object:update(dt)

        if object.toRemove then
            table.remove(self.objects, k)
        end
    end
    self.player:update(dt)

    if self.bgScrolling then
        self.bgOffsetY = self.bgOffsetY + self.bgSpeed * dt
    end
    
    if self.bgOffsetY >= BACKGROUND_SIZE then
        self.bgOffsetY = 0
    end
end

function Level:render()
    for x = 0, 4, 1 do
        for y = -1, 3, 1 do
            love.graphics.draw(gTextures['bg_blue'], x * BACKGROUND_SIZE, y * BACKGROUND_SIZE + self.bgOffsetY)
        end
    end

    for k, object in pairs(self.objects) do
        object:render()
    end
    self.player:render()
end