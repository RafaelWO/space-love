EntityBaseState = Class{}

function EntityBaseState:init(entity)
    self.entity = entity
end

function EntityBaseState:update(dt)
end

function EntityBaseState:enter() end
function EntityBaseState:exit() end
function EntityBaseState:processAI(params, dt) end

function EntityBaseState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures[self.entity.texture], gFrames[self.entity.texture][self.entity:getFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))

    if DEBUG then
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
        love.graphics.setColor(1, 1, 1, 1)

        local hitboxes = self.entity:getHitboxes()
        for k, hitbox in pairs(hitboxes) do
            love.graphics.setColor(0, 1, 1, 1)
            love.graphics.rectangle('line', hitbox.x, hitbox.y, hitbox.width, hitbox.height)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end
