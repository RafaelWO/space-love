Level = Class{}

function Level:init()
    self.objects = {
        ['lasers'] = {},
        ['meteors'] = {},
        ['animations'] = {},
        ['particles'] = {}
    }
    self.player = Player (
        VIRTUAL_WIDTH / 2,
        VIRTUAL_HEIGHT / 2,
        ENTITY_DEFS['player'],
        self
    )
    
    self.enemies = { }

    self.score = 0
    self.scoreTimer = Timer.every(5, function() self.score = self.score + 5 end)

    self.bgOffsetY = 0
    self.bgScrolling = true

    self.meteorSpawnTimer = 0
    self.meteorSpawnEta = math.random(unpack(METEOR_SPAWN_INTERVAL))
    self.enemySpawnTimer = 0
    self.enemySpawnEta = math.random(unpack(ENEMY_SPAWN_INTERVAL))
end

function Level:update(dt)
    -- spawn meteors
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

    -- spawn enemies
    self.enemySpawnTimer = self.enemySpawnTimer + dt
    if self.enemySpawnTimer > self.enemySpawnEta then
        self.enemySpawnTimer = 0
        self.enemySpawnEta = math.random(unpack(ENEMY_SPAWN_INTERVAL))
        
        table.insert(self.enemies, Entity (
            math.random(0, VIRTUAL_WIDTH - 100),
            -100,
            ENTITY_DEFS['enemy'],
            self
        ))
        self.enemies[#self.enemies]:processAI({direction = "down", duration = 1}, dt)
    end

    for i, gtype in ipairs(GAME_OBJECT_TYPES) do
        for k, object in pairs(self.objects[gtype]) do
            object:update(dt)

            if gtype == "lasers" then
                if object.source.type == "player" then
                    -- check if player laser hits a meteor
                    for j, meteor in pairs(self.objects["meteors"]) do
                        if meteor:collides(object) then
                            object:changeState("hit")
                        end
                    end
                    
                    -- check if player laser hits an enemy
                    for j, enemy in pairs(self.enemies) do
                        if object.state == "fly" and enemy:collides(object) then
                            object:changeState("hit")
                            enemy:reduceHealth(object.source.attack)
                        end
                    end
                else
                    -- Enemy laser hits player
                    if object.state == "fly" and self.player:collides(object) then
                        object:changeState("hit")
                        self.player:reduceHealth(object.source.attack)
                    end
                end
            end
            
            -- check player with meteor collision
            if gtype == "meteors" and self.player:collides(object:getHitbox()) then
                self.player:takeCollisionDamage(METEOR_COLLISION_DAMAGE)
                self:playerHits()
            end

            if object.toRemove then
                table.remove(self.objects[gtype], k)
            end
        end
    end

    if self.player.dead and self.player.diedNow then
        self.scoreTimer:remove()
        self.player.diedNow = false
        self:spawnExplosion(self.player)

        Timer.after(1, function() self:gameOver() end)
    elseif not self.player.dead then
        self.player:update(dt)
    end

    for k, enemy in pairs(self.enemies) do
        enemy:processAI({}, dt)
        enemy:update(dt)

        -- Player collision with enemy
        for j, enemyHitbox in pairs(enemy:getHitboxes()) do
            if self.player:collides(enemyHitbox) then
                self.player:takeCollisionDamage(ENEMY_COLLOSION_DAMAGE)
                self:playerHits()
            end
        end

        if enemy.dead then
            -- create explosion particle effect
            self:spawnExplosion(enemy)
            table.remove(self.enemies, k)
            self.score = self.score + 20
        end
    end

    -- Update particles
    for k, pSystem in pairs(self.objects['particles']) do
        pSystem:update(dt)
        if pSystem:getCount() == 0 then
            table.remove(self.objects['particles'], k)
        end
    end


    -- Update scrollingbBackground
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

    if not self.player.dead then
        self.player:render()
    end

    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end

    for k, object in pairs(self.objects['lasers']) do
        object:render()
    end

    for k, object in pairs(self.objects['animations']) do
        object:render()
    end

    for k, pSystem in pairs(self.objects['particles']) do
        love.graphics.draw(pSystem, 0, 0)
    end

    -- render score
    local scoreString = string.rep("0", 8 - tostring(self.score):len()) .. tostring(self.score)
    local scoreOffset = 10 + (scoreString:len() * 20)
    for char in scoreString:gmatch"." do
        love.graphics.draw(gTextures['sheet'], gFrames['sheet']['numeral' .. char], VIRTUAL_WIDTH - scoreOffset, 10)
        scoreOffset = scoreOffset - 20
    end


    -- DEBUG INFO
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Health: " .. self.player.health, 10, 50, VIRTUAL_WIDTH, 'left')
    love.graphics.printf("Collision: " .. self.player.hits, 10, 70, VIRTUAL_WIDTH, 'left')
    local collisionCooldown = 1 - math.min(self.player.collisionDamageTimer, self.player.collisionDamageInterval)
    love.graphics.printf("Collision Cooldown: " .. string.format("%.1f", collisionCooldown), 10, 90, VIRTUAL_WIDTH, 'left')

    for y = 10, (#self.enemies * 20 - 10), 20 do
        local idx = (y + 10) / 20
        love.graphics.printf("Enemy #" .. idx .. " Health: " .. self.enemies[idx].health, VIRTUAL_WIDTH - 200, y + 50, VIRTUAL_WIDTH, 'left')
    end
end

function Level:playerHits()
    self.player.hits = self.player.hits + 1
end

function Level:gameOver()
    gSounds['lose']:play()
    gStateStack:pop()
    gStateStack:push(GameOverState())
end

function Level:spawnExplosion(object)
    local explosion = getExplosion(EXPLOSION_BLAST)
    explosion:setPosition(object.x + object.width/2, object.y + object.height/2)
    explosion:emit(10)
    table.insert(self.objects['particles'], explosion)

    gSounds['explosion']:stop()
    gSounds['explosion']:play()
end