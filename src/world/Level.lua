Level = Class{}

function Level:init()
    self.objects = {
        ['lasers'] = {},
        ['meteors'] = {}
    }
    self.player = Player (
        VIRTUAL_WIDTH / 2,
        VIRTUAL_HEIGHT / 2,
        ENTITY_DEFS['player'],
        self
    )

    self.player.stateMachine = StateMachine {
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['fly'] = function() return PlayerFlyState(self.player) end
    }
    self.player:changeState('idle')
    
    self.enemies = { 
        Entity (
            VIRTUAL_WIDTH / 2,
            100,
            ENTITY_DEFS['enemy'],
            self
        )
    }
    self.enemies[1].stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self.enemies[1]) end,
        ['fly'] = function() return EntityFlyState(self.enemies[1]) end
    }
    self.enemies[1]:changeState('idle')

    -- Event.on('objects-changed', function()
    --     local logString = ""
    --     for k, object in pairs(self.objects) do
    --         logString = logString .. " | " .. object.type
    --     end
    --     print(logString)
    -- end
    -- )

    self.bgOffsetY = 0
    self.bgScrolling = true

    self.meteorSpawnTimer = 0
    self.meteorSpawnEta = math.random(unpack(METEOR_SPAWN_INTERVAL))
end

function Level:update(dt)
    self.meteorSpawnTimer = self.meteorSpawnTimer + dt
    if self.meteorSpawnTimer > self.meteorSpawnEta then
        self.meteorSpawnTimer = 0
        self.meteorSpawnEta = math.random(unpack(METEOR_SPAWN_INTERVAL))
        
        local meteorDef = GAME_OBJECT_DEFS['meteor']
        meteorDef.frame = METEOR_TYPES[math.random(#METEOR_TYPES)]
        table.insert(self.objects['meteors'], Meteor (
            math.random(0, VIRTUAL_WIDTH),
            -100,
            meteorDef
        ))
    end

    for i, gtype in ipairs(GAME_OBJECT_TYPES) do
        for k, object in pairs(self.objects[gtype]) do
            object:update(dt)

            if gtype == "lasers" then
                if object.source == "player" then
                    -- check if player laser hits a meteor
                    for j, meteor in pairs(self.objects["meteors"]) do
                        if meteor:collides(object) then
                            object:changeState("hit")
                        end
                    end
                    
                    -- check if player laser hits an enemy
                    for j, enemy in pairs(self.enemies) do
                        if enemy:collides(object) then
                            object:changeState("hit")
                        end
                    end
                else
                    -- Enemy laser hits player
                    if self.player:collides(object) then
                        object:changeState("hit")
                        self:gameOver()
                    end
                end
            end
            
            -- check player with meteor collision
            if gtype == "meteors" and self.player:collides(object:getHitbox()) then
                self:gameOver()
            end

            if object.toRemove then
                table.remove(self.objects[gtype], k)
            end
        end
    end
    self.player:update(dt)

    for k, enemy in pairs(self.enemies) do
        enemy:processAI({}, dt)
        enemy:update(dt)

        for j, enemyHitbox in pairs(enemy:getHitboxes()) do
            if self.player:collides(enemyHitbox) then
                self:gameOver()
            end
        end
    end

    if self.bgScrolling then
        self.bgOffsetY = self.bgOffsetY + BACKGROUND_SPEED * dt
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

    for k, object in pairs(self.objects['meteors']) do
        object:render()
    end
    self.player:render()

    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end

    for k, object in pairs(self.objects['lasers']) do
        object:render()
    end

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(self.player.hits, 10, 10, VIRTUAL_WIDTH, 'left')
end

function Level:gameOver()
    self.player.hits = self.player.hits + 1
    -- gSounds['lose']:play()
    -- gStateStack:pop()
    -- gStateStack:push(GameOverState())
end