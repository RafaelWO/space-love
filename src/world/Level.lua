Level = Class{}

function Level:init(params)
    self.objects = {
        ['lasers'] = {},
        ['meteors'] = {},
        ['particles'] = {},
        ['items'] = {},
        ['visuals'] = {}
    }
    self.player = Player (
        VIRTUAL_WIDTH / 2 - SHIP_DEFS[params.playerShipConfig.ship].width / 2,
        VIRTUAL_HEIGHT / 2,
        ENTITY_DEFS['player'],
        self,
        params.playerShipConfig
    )
    
    self.enemies = { }

    self.timers = {}
    self.score = 0
    self.scoreTimer = Timer.every(5, function() 
        self.score = self.score + 5
        Event.dispatch('score-changed', 5)
    end):group(self.timers)

    self.bgOffsetY = 0
    self.bgScrolling = true
    self.background = BACKGROUNDS[math.random(#BACKGROUNDS)]
    
    self.stage = 0
    self.stageDef = nil
    self.stageGoals = {
        [3] = 5000,
        [2] = 1000,
        [1] = 0
    }
    self:changeStage(1)

    self.meteorSpawnTimer = 0
    self.meteorSpawnEta = math.random(unpack(self.stageDef['meteor-spawn-interval']))
    self.enemySpawnTimer = 0
    self.enemySpawnEta = math.random(unpack(self.stageDef['enemy-spawn-interval']))

    self:initEvents()
end

function Level:update(dt)
    -- update timers
    self.meteorSpawnTimer = self.meteorSpawnTimer + dt
    self.enemySpawnTimer = self.enemySpawnTimer + dt

    -- spawn meteor
    if self.meteorSpawnTimer > self.meteorSpawnEta then
        self.meteorSpawnTimer = 0
        self.meteorSpawnEta = math.random(unpack(self.stageDef['meteor-spawn-interval']))
        
        local meteorDef = GAME_OBJECT_DEFS['meteor']
        meteorDef.frame = METEOR_TYPES[math.random(#METEOR_TYPES)]
        table.insert(self.objects['meteors'], Meteor (
            math.random(0, VIRTUAL_WIDTH),
            -100,
            meteorDef,
            {
                speed = METEOR_SPEED
            }
        ))
    end
    
    if self.enemySpawnTimer > self.enemySpawnEta then
        self:spawnEnemy(dt)
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
                            object:stickToObject(meteor)
                        end
                    end
                    
                    -- check if player laser hits an enemy
                    for j, enemy in pairs(self.enemies) do
                        if object.state == "fly" and enemy:collides(object) then
                            object:changeState("hit")
                            object:stickToObject(enemy)
                            enemy:reduceHealth(object.source.attack)
                        end
                    end
                else
                    -- Enemy laser hits player
                    if object.state == "fly" and self.player:collides(object) and not self.player.dead then
                        object:changeState("hit")
                        object:stickToObject(self.player)
                        if self.player:reduceHealth(object.source.attack) then
                            gSounds['impact']:stop()
                            gSounds['impact']:play()
                        end
                    end
                end            
            -- check player with meteor collision
            elseif gtype == "meteors" and self.player:collides(object:getHitbox()) then
                self.player:takeCollisionDamage(METEOR_COLLISION_DAMAGE)
                self:playerHits()
            elseif object.consumable and self.player:collides(object) then
                object.onConsume()
                object.toRemove = true
            end

            if object.toRemove then
                table.remove(self.objects[gtype], k)
            end
        end
    end

    if self.player.dead and self.player.diedNow then
        self.scoreTimer:remove()
        self.player.diedNow = false
        self:spawnExplosion(self.player, 'medium')
        gSounds['health-alarm']:stop()

        Timer.after(2, function() self:gameOver() end)
            :group(self.timers)
    elseif not self.player.dead then
        self.player:update(dt)
    elseif self.player.dead then
        -- Update timer for healthbar going down to zero if dead
        Timer.update(dt, self.player.timers)
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
            self:spawnExplosion(enemy, 'short')
            table.remove(self.enemies, k)
            
            local enemyReward = 20 * enemy:getShipType() + 10 * enemy.lvl
            self.score = self.score + enemyReward
            Event.dispatch('score-changed', enemyReward)

            local powerupProbability = enemy:getShipType() * enemy.lvl * 2
            
            if math.random(100) <= powerupProbability then
                self:spawnPowerup('pill', true, enemy:getCenter())
            elseif math.random(100) <= powerupProbability then
                self:spawnPowerup('powerup-shield', false, enemy:getCenter())
            end
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

    self.stageProgress:setValue(self.score)
end

function Level:render()
    for x = 0, 4, 1 do
        for y = -1, 3, 1 do
            love.graphics.draw(gTextures[self.background], x * BACKGROUND_SIZE, y * BACKGROUND_SIZE + self.bgOffsetY)
        end
    end

    for k, object in pairs(self.objects['meteors']) do
        object:render()
    end

    self.player:render()

    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end

    for i, gtype in ipairs({'lasers', 'items'}) do
        for k, object in pairs(self.objects[gtype]) do
            object:render()
        end
    end

    for k, pSystem in pairs(self.objects['particles']) do
        love.graphics.draw(pSystem, 0, 0)
    end

    -- render player health-bar
    self.player.healthBar:render()

    -- render score
    local scoreString = string.rep("0", 8 - tostring(self.score):len()) .. tostring(self.score)
    local scoreOffset = 10 + (scoreString:len() * 20)
    for char in scoreString:gmatch"." do
        love.graphics.draw(gTextures['sheet'], gFrames['sheet']['numeral' .. char], VIRTUAL_WIDTH - scoreOffset, 10)
        scoreOffset = scoreOffset - 20
    end

    -- render stage
    self.stageProgress:render()


    -- DEBUG INFO
    if DEBUG then
        love.graphics.setFont(gFonts['thin-medium'])
        love.graphics.printf("Health: " .. self.player.health, 10, 50, VIRTUAL_WIDTH, 'left')
        love.graphics.printf("Collision: " .. self.player.hits, 10, 70, VIRTUAL_WIDTH, 'left')
        local collisionCooldown = 1 - math.min(self.player.collisionDamageTimer, self.player.collisionDamageInterval)
        love.graphics.printf("Collision Cooldown: " .. string.format("%.1f", collisionCooldown), 10, 90, VIRTUAL_WIDTH, 'left')

        for y = 10, (#self.enemies * 20 - 10), 20 do
            local idx = (y + 10) / 20
            love.graphics.printf("Enemy #" .. idx .. " Health: " .. self.enemies[idx].health, VIRTUAL_WIDTH - 200, y + 50, VIRTUAL_WIDTH, 'left')
        end
    end
end

function Level:initEvents()
    Event.on('score-changed', function(amountAdded)
        for stage, goal in spairs(self.stageGoals, function(t,a,b) return a > b end) do
            if stage <= self.stage then
                break
            end
            
            if self.score >= goal then
                self:changeStage(stage)
                break
            end
        end
    end)
end

function Level:playerHits()
    self.player.hits = self.player.hits + 1
end

function Level:spawnEnemy(dt)
    self.enemySpawnTimer = 0
    self.enemySpawnEta = math.random(unpack(self.stageDef['enemy-spawn-interval']))


    local enemyType = self:getValueFromProbs(self.stageDef['enemy-spawn-probs'])
    local enemyLvl = self:getValueFromProbs(self.stageDef['enemy-level-probs'])

    print("Spawning: " .. enemyType .. " | lvl " .. enemyLvl)
    table.insert(self.enemies, Entity (
        math.random(0, VIRTUAL_WIDTH - 100),
        -100,
        ENTITY_DEFS[enemyType],
        self,
        { enemyLvl = enemyLvl }
    ))
    self.enemies[#self.enemies]:processAI({direction = "down"}, dt)
end

function Level:getValueFromProbs(probabilityMap)
    local probs = {}
    for k, _ in pairs(probabilityMap) do
        table.insert(probs, k)
    end
    table.sort(probs)

    local value
    local rnd = math.random()
    print("Spawn RNG: " .. string.format("%.2f", rnd))

    for i, prob in ipairs(probs) do
        if rnd <= prob then
            value = probabilityMap[prob]
            break
        end
    end

    return value
end

function Level:gameOver()
    gSounds['music-lvl' .. self.stage]:stop()
    gStateStack:pop()
    gStateStack:push(GameOverState({score = self.score}))
end

function Level:spawnExplosion(object, length)
    local explosion = getExplosion(EXPLOSION_BLAST)
    explosion:setPosition(object.x + object.width/2, object.y + object.height/2)
    explosion:emit(10)
    table.insert(self.objects['particles'], explosion)

    if length == 'short' then
        expl_num = math.random(1, EXPLOSION_SHORT_COUNT)
    elseif length == 'medium' then
        expl_num = math.random(1, EXPLOSION_MEDIUM_COUNT)
    end
    gSounds['explosion-' .. length .. '-' .. expl_num]:stop()
    gSounds['explosion-' .. length .. '-' .. expl_num]:play()
end

function Level:spawnPowerup(name, colorLower, x, y)
    local object_def = GAME_OBJECT_DEFS[name]
    local x = x - object_def.width / 2
    local y = y - object_def.height / 2
    local color = colorLower and self.player.color:lower() or self.player.color

    local object = GameObject(
        x,
        y,
        object_def,
        {
            color = color,
            speed = POWERUP_SPEED
        }
    )

    if name == "pill" then
        object.onConsume = function()
            gSounds['powerup-health']:stop()
            gSounds['powerup-health']:play()
            self.player:increaseHealth(1)
        end
    elseif name == "powerup-shield" then
        object.onConsume = function()
            self.player:shieldUp(5)
        end
    end
    
    table.insert(self.objects['items'], object)
end

function Level:changeStage(value)
    self.stage = value
    self.stageDef = LEVEL_DIFFICULTY[self.stage]
    print("Music: " .. self.stage)
    if self.stage > 1 then
        gSounds['music-lvl' .. self.stage - 1]:stop()
    end
    gSounds['music-lvl' .. self.stage]:play()
    print("Entered stage " .. self.stage .. "!")
    for name, def in pairs(self.stageDef) do
        print(name .. ":")
        for k, v in spairs(def, function(t,a,b) return t[a] < t[b] end) do
            print(k, v)
        end
    end

    local pb_max, pb_text
    if #self.stageGoals > self.stage then
        pb_max = self.stageGoals[self.stage+1]
        pb_text = "Stage  " .. self.stage
    else
        pb_max = self.stageGoals[self.stage]
        pb_text = "Stage  " .. self.stage .. "  (max)"
    end
    Event.dispatch('stage-changed', pb_text)

    self.stageProgress = ProgressBar {
        x = VIRTUAL_WIDTH - 170,
        y = 60,
        width = 160,
        height = 7,
        color = {r = 230, g = 230, b = 0},
        min = self.stageGoals[self.stage],
        max = pb_max,
        value = self.score,
        text = pb_text
    }
end

function Level:pauseAudio()
    gSounds['music-lvl' .. self.stage]:pause()
    gSounds['health-alarm']:pause()
end

function Level:resumeAudio()
    gSounds['music-lvl' .. self.stage]:resume()
    gSounds['health-alarm']:resume()
end