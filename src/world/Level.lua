Level = Class{}

function Level:init(params)
    self.lasers = {}
    self.meteors = {}
    self.particles = {}
    self.items = {}
    
    self.player = Player (
        VIRTUAL_WIDTH / 2 - SHIP_DEFS[params.playerShipConfig.ship].width / 2,
        VIRTUAL_HEIGHT / 2 + 100,
        ENTITY_DEFS['player'],
        self,
        params.playerShipConfig
    )

    self.enemies = {}
    self.allies = {}

    self.timers = {}
    self.noPowerupCount = 0
    self.score = 0
    self.scoreTimer = Timer.every(5, function() 
        self.score = self.score + 5
        Event.dispatch('score-changed', 5)
    end):group(self.timers)

    self.background = Background()
    self.lowHealthOverlay = LowHealthOverlay({
        color = {r = 1, g = 0, b = 0},
        interval = 1,
        maxAlpha = 15/255,
        mode = 'full'
    })
    
    self.stage = 0
    self.stageDef = nil
    self.stageGoals = {
        [3] = 5000,
        [2] = 1000,
        [1] = 0
    }
    self:changeStage(1)

    self.spawner = Spawner(self)
    self:initEvents()
end

function Level:update(dt)
    self.background:update(dt)
    self.lowHealthOverlay:update(dt)

    -- update spawn timings and spawn objects/entities if it's time
    self.spawner:update(dt)

    for k, laser in pairs(self.lasers) do
        laser:update(dt)
        if laser.state == "fly" then
            if laser.source.type == "player" or laser.source.type == "ufo" then
                -- check if player/ally laser hits a meteor
                for j, meteor in pairs(self.meteors) do
                    self:checkLaserCollision(laser, meteor)
                end
                
                -- check if player/ally laser hits an enemy
                for j, enemy in pairs(self.enemies) do
                    self:checkLaserCollision(laser, enemy)
                end
            else
                -- check if enemy laser hits player
                if not self.player.dead then
                    self:checkLaserCollision(laser, self.player)
                end

                -- check if enemy laser hits ally
                for idx, ally in pairs(self.allies) do
                    self:checkLaserCollision(laser, ally)
                end
            end
        end
    end

    -- check player with meteor collision
    for k, meteor in pairs(self.meteors) do
        meteor:update(dt)
        if self.player:collides(meteor:getHitbox()) then
            self.player:takeCollisionDamage(METEOR_COLLISION_DAMAGE)
            self:playerHits()
        end
    end

    -- Check whether player has picked up an item
    for k, item in pairs(self.items) do
        item:update(dt)
        if item.consumable and self.player:collides(item) then
            item.onConsume()
            item.toRemove = true
        end
    end

    if self.player.dead and self.player.diedNow then
        self.scoreTimer:remove()
        self.player.diedNow = false
        self.spawner:spawnExplosion(self.player, 'medium')
        gSounds['health-alarm']:stop()

        Timer.after(2, function() self:gameOver() end)
            :group(self.timers)
    elseif not self.player.dead then
        self.player:update(dt)
    elseif self.player.dead then
        -- Update timer for healthbar going down to zero if dead
        Timer.update(dt, self.player.timers)
    end

    for k, ally in pairs(self.allies) do
        ally:processAI({}, dt)
        ally:update(dt)

        if ally.dead then
            self.spawner:spawnExplosion(ally, 'short')
        end
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
            self.spawner:spawnExplosion(enemy, 'short')
            
            local enemyReward = 20 * enemy:getShipType() + 10 * enemy.lvl
            self.score = self.score + enemyReward
            Event.dispatch('score-changed', enemyReward)

            -- will be between [2; 40]
            local powerupProbability = enemy:getShipType() * enemy.lvl * 2
            
            if math.random(POWERUP_PROB_MAX) <= powerupProbability or self.noPowerupCount >= NO_POWERUP_THRESH then
                -- powerup star (spawn UFO) is available from stage 2
                local powerupType = math.random(1, (self.stage >= 2 and 3 or 2))

                if powerupType == 1 or self.noPowerupCount >= NO_POWERUP_THRESH then
                    self.spawner:spawnPowerup(
                        'pill', 
                        true, 
                        function()
                            gSounds['powerup-health']:stop()
                            gSounds['powerup-health']:play()
                            self.player:increaseHealth(1)
                        end,
                        enemy:getCenter()
                    )
                elseif powerupType == 2 then
                    self.spawner:spawnPowerup(
                        'powerup-shield', 
                        false, 
                        function()
                            self.player:shieldUp(5)
                        end,
                        enemy:getCenter()
                    )
                elseif powerupType == 3 then
                    self.spawner:spawnPowerup(
                        'powerup-star', 
                        false, 
                        function()
                            self.spawner:spawnUfo()
                        end,
                        enemy:getCenter()
                    )
                end
                self.noPowerupCount = 0
            else
                self.noPowerupCount = self.noPowerupCount + 1
            end
            
            if DEBUG then
                print("Powerup probability:", powerupProbability)
                print("No powerup  (" .. self.noPowerupCount .. "/" .. NO_POWERUP_THRESH .. ")")
            end
        end
    end

    -- Update particles
    for k, pSystem in pairs(self.particles) do
        pSystem:update(dt)
        if pSystem:getCount() == 0 then
            table.remove(self.particles, k)
        end
    end

    -- Do cleanup
    for j, tbl in ipairs({self.lasers, self.meteors, self.particles, self.items, self.enemies, self.allies}) do
        self:removeDead(tbl)
    end

    self.stageProgress:setValue(self.score)
end

function Level:render()
    self.background:render()

    for j, tbl in ipairs({self.meteors, self.enemies, self.allies, self.lasers, self.items}) do
        for k, object in pairs(tbl) do
            object:render()
        end

        -- render player after meteors
        if j == 1 then
            self.player:render()
        end
    end

    self.lowHealthOverlay:render()

    for k, pSystem in pairs(self.particles) do
        love.graphics.draw(pSystem, 0, 0)
    end

    -- render player health-bar
    self.player.healthBar:render()

    -- render score
    local scoreString = string.rep("0", 8 - tostring(self.score):len()) .. tostring(self.score)
    local scoreOffset = HUD_PADDING + (scoreString:len() * 20)
    for char in scoreString:gmatch"." do
        love.graphics.draw(gTextures['sheet'], gFrames['sheet']['numeral' .. char], VIRTUAL_WIDTH - scoreOffset, HUD_PADDING)
        scoreOffset = scoreOffset - 20
    end

    -- render stage
    self.stageProgress:render()


    -- DEBUG INFO
    if DEBUG then
        love.graphics.setFont(gFonts['default-small'])
        local collisionCooldown = 1 - math.min(self.player.collisionDamageTimer, self.player.collisionDamageInterval)
        local onScreenData = {
            "Health: " .. self.player.health,
            "Collision: " .. self.player.hits,
            "Collision Cooldown: " .. string.format("%.1f", collisionCooldown),
            "Lasers: " .. #self.lasers
        }

        local yOffset = HUD_PADDING + HUD_ITEM_MARGIN * 2
        for i, item in ipairs(onScreenData) do
            love.graphics.printf(item, HUD_PADDING, yOffset + i * 20, VIRTUAL_WIDTH, 'left')
        end

        for y = 50, (#self.enemies * 20 + 30), 20 do
            local idx = (y - 30) / 20
            love.graphics.printf("Enemy #" .. idx .. " Health: " .. self.enemies[idx].health, VIRTUAL_WIDTH - 200, y + 50, VIRTUAL_WIDTH, 'left')
        end

        -- Draw screen barriers (for enemies and ufo)
        love.graphics.setColor(150/255, 150/255, 150/255, 1)
        love.graphics.line(0, SCREEN_BARRIER_SIZE, VIRTUAL_WIDTH, SCREEN_BARRIER_SIZE)
        love.graphics.line(0, VIRTUAL_HEIGHT - SCREEN_BARRIER_SIZE, VIRTUAL_WIDTH, VIRTUAL_HEIGHT - SCREEN_BARRIER_SIZE)
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

    Event.on('health-low', function()
        gSounds['health-alarm']:play()
        self.lowHealthOverlay:enable()
    end)

    Event.on('health-ok', function()
        gSounds['health-alarm']:stop()
        self.lowHealthOverlay:disable()
    end)
end

function Level:playerHits()
    self.player.hits = self.player.hits + 1
end

function Level:checkLaserCollision(laser, object)
    if object:collides(laser) then
        laser:changeState("hit")
        laser:stickToObject(object)
        if object.meta == "Entity" then
            if object:reduceHealth(laser.source.attack) and object.type == "player" then
                gSounds['impact']:stop()
                gSounds['impact']:play()
            end
        end
    end
end

function Level:removeDead(tbl)
    for i = #tbl, 1, -1 do
        if (tbl[i].meta == "Entity" and tbl[i].dead) or tbl[i].toRemove then
            table.remove(tbl, i)
        end
    end
end

function Level:gameOver()
    gSounds['music-lvl' .. self.stage]:stop()
    gStateStack:pop()
    gStateStack:push(GameOverState({score = self.score}))
end

function Level:changeStage(value)
    self.stage = value
    self.stageDef = LEVEL_DIFFICULTY[self.stage]

    if self.stage > 1 then
        gSounds['music-lvl' .. self.stage - 1]:stop()
    end
    gSounds['music-lvl' .. self.stage]:play()

    print("Entered stage " .. self.stage .. "!")
    if DEBUG then
        for name, def in pairs(self.stageDef) do
            print(name .. ":")
            for k, v in spairs(def, function(t,a,b) return t[a] < t[b] end) do
                print(k, v)
            end
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

    local pbWidth = 160
    self.stageProgress = ProgressBar {
        x = VIRTUAL_WIDTH - pbWidth - HUD_PADDING,
        y = HUD_PADDING + HUD_ITEM_MARGIN,
        width = pbWidth,
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
    if self.lowHealthOverlay.enabled then
        gSounds['health-alarm']:pause()
    end
end

function Level:resumeAudio()
    gSounds['music-lvl' .. self.stage]:play()
    if self.lowHealthOverlay.enabled then
        gSounds['health-alarm']:play()
    end
end