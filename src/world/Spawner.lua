Spawner = Class{}

function Spawner:init(level)
    self.level = level

    self.meteorSpawnTimer = 0
    self.meteorSpawnEta = math.random(unpack(self.level.stageDef['meteor-spawn-interval']))
    self.enemySpawnTimer = 0
    self.enemySpawnEta = math.random(unpack(self.level.stageDef['enemy-spawn-interval']))
end

function Spawner:update(dt)
    self.meteorSpawnTimer = self.meteorSpawnTimer + dt
    self.enemySpawnTimer = self.enemySpawnTimer + dt

    if self.meteorSpawnTimer > self.meteorSpawnEta then
        self:spawnMeteor()
    end
    
    if self.enemySpawnTimer > self.enemySpawnEta then
        self:spawnEnemy()
    end
end

function Spawner:spawnMeteor()
    self.meteorSpawnTimer = 0
    self.meteorSpawnEta = math.random(unpack(self.level.stageDef['meteor-spawn-interval']))
    
    local meteorDef = GAME_OBJECT_DEFS['meteor-' .. math.random(4)]
    table.insert(self.level.meteors, Meteor (
        math.random(0, VIRTUAL_WIDTH),
        -100,
        meteorDef,
        {
            speed = METEOR_SPEED
        }
    ))
end

function Spawner:spawnEnemy()
    self.enemySpawnTimer = 0
    self.enemySpawnEta = math.random(unpack(self.level.stageDef['enemy-spawn-interval']))

    local enemyType = self:getValueFromProbs(self.level.stageDef['enemy-spawn-probs'])
    local enemyLvl = self:getValueFromProbs(self.level.stageDef['enemy-level-probs'])

    if DEBUG then
        print("Spawning: " .. enemyType .. " | lvl " .. enemyLvl)
    end
    local enemy = Entity (
        math.random(0, VIRTUAL_WIDTH - 100),
        -100,
        ENTITY_DEFS[enemyType],
        self.level,
        { enemyLvl = enemyLvl }
    )
    table.insert(self.level.enemies, enemy)
end

function Spawner:spawnUfo()
    -- flies in from right to left or vice versa
    local direction = math.random(1,2) == 1 and "left" or "right"

    -- There is no orange UFO -> use yellow for orange
    local color = self.level.player.color == "Orange" and "Yellow" or self.level.player.color

    local ufo = Ufo (
        direction == "right" and -50 - SHIP_DEFS['ufo'].width or VIRTUAL_WIDTH + 50,
        math.random(SCREEN_BARRIER_SIZE, VIRTUAL_HEIGHT - 100),
        ENTITY_DEFS['ufo'],
        self.level,
        { color = color, direction = direction }
    )
    table.insert(self.level.allies, ufo)
end

function Spawner:spawnPowerup(name, colorLower, onConsume, x, y)
    local object_def = GAME_OBJECT_DEFS[name]
    local x = x - object_def.width / 2
    local y = y - object_def.height / 2

    -- There are no orange powerups -> use red for orange
    local color = self.level.player.color == "Orange" and "Red" or self.level.player.color
    if colorLower then
        color = color:lower()
    end

    local object = GameObject(
        x,
        y,
        object_def,
        {
            color = color,
            speed = POWERUP_SPEED
        }
    )
    object.onConsume = onConsume
    if DEBUG then
        print("Spawning powerup", name)
    end
    table.insert(self.level.items, object)
end

function Spawner:spawnExplosion(object, blast, length, source)
    local explosion = getExplosion(blast, source or 'ship')
    explosion:setPosition(object.x + object.width/2, object.y + object.height/2)
    explosion:emit(10)
    table.insert(self.level.particles, explosion)

    if length == 'short' then
        expl_num = math.random(1, EXPLOSION_SHORT_COUNT)
    elseif length == 'medium' then
        expl_num = math.random(1, EXPLOSION_MEDIUM_COUNT)
    end
    gSounds['explosion-' .. length .. '-' .. expl_num]:stop()
    gSounds['explosion-' .. length .. '-' .. expl_num]:play()
end

function Spawner:getValueFromProbs(probabilityMap)
    local probs = {}
    for k, _ in pairs(probabilityMap) do
        table.insert(probs, k)
    end
    table.sort(probs)

    local value
    local rnd = math.random()
    --print("Spawn RNG: " .. string.format("%.2f", rnd))

    for i, prob in ipairs(probs) do
        if rnd <= prob then
            value = probabilityMap[prob]
            break
        end
    end

    return value
end