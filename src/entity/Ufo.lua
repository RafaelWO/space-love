Ufo = Class{__includes = Entity}

function Ufo:init(x, y, def, level, params)
    Entity.init(self, x, y, def, level, params)
    print(self:getFrame())
end

function Ufo:getFrame()
    return self.ship .. self.color
end

function Ufo:processAI(params, dt)
    self.stateMachine:processAI(params, dt)

    if self.shotDuration == 0 then
        self.shotDuration = math.random(4)
        self.shotWaitDuration = math.random(3)
    elseif self.shotTimer < self.shotDuration then
        self:shoot("up")
    elseif self.shotTimer > (self.shotDuration + self.shotWaitDuration) then
        self.shotDuration = math.random(4)
        self.shotWaitDuration = math.random(3)
        self.shotTimer = 0
    end

    self.shotTimer = self.shotTimer + dt
end