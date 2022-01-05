Meteor = Class{__includes = GameObject}

function Meteor:init(x, y, def, params)
    local specificDef = self:overrideDef(def)
    GameObject.init(self, x, y, specificDef, params)

    self.hitmargin = 2
    if string.match(self.frame, "_big") then
        -- hitbox for big meteors is smaller by 10 on each side
        self.hitmargin = 10 
    elseif string.match(self.frame, "_med") then
        self.hitmargin = 5
    end

    self.health = def.health
    self.dead = false
    self.showHealth = false
    self.showHealthTimer = nil
    self:createHealthbar()
end

function Meteor:update(dt)
    GameObject.update(self, dt)
    self.healthBar:update(dt)
end

function Meteor:render()
    GameObject.render(self)
    if self.showHealth then
        self.healthBar:render()
    end
end

function Meteor:collides(target)
    local hitbox = self:getHitbox()
    return not (hitbox.x + hitbox.width < target.x or hitbox.x > target.x + target.width or
                hitbox.y + hitbox.height < target.y or hitbox.y > target.y + target.height)
end

function Meteor:getHitbox()
    local x = self.x + self.hitmargin
    local y = self.y + self.hitmargin
    local width = self.width - self.hitmargin * 2
    local height = self.height - self.hitmargin * 2
    
    return { x = x, y = y, width = width, height = height }
end

function Meteor:reduceHealth(damage)
    if self.healthBar then
        Timer.tween(0.25, {
            [self.healthBar] = {value = self.health - damage}
        }):group(self.timers)
    end
    self.health = math.max(0, self.health - damage)

    if self.health <= 0 and not self.dead then
        self.dead = true
    end

    self:blink(0.4, 0.2)

    self.showHealth = true
    if self.showHealthTimer then
        self.showHealthTimer:remove()
    end
    self.showHealthTimer = Timer.after(2, function()
        self.showHealth = false
    end)

    return true
end

function Meteor:overrideDef(def)
    local newDef = table.deepcopy(def)
    local color = math.random() < 0.5 and "Grey" or "Brown"
    
    newDef.frame = newDef.frame:gsub("<color>", color):gsub("<type>", math.random(def.frame:match("big") and 4 or 2))
    return newDef
end

function Meteor:createHealthbar()
    local barWidth = 50
    local offset = {
        x = self.width / 2 - barWidth / 2,
        y = -20
    }
    self.healthBar = ProgressBar {
        x = self.x + offset.x,
        y = self.y + offset.y,
        parent = self,
        parentOffset = offset,
        width = barWidth,
        height = 5,
        max = self.health,
        value = self.health,
        separators = true,
        color = {r = 0.5, g = 0.5, b = 0.5},
        cornerRadius = 0
    }
end