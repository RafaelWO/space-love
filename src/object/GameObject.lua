GameObject = Class{}

function GameObject:init(def)
        -- string identifying this object type
        self.type = def.type

        self.texture = def.texture
        self.frame = def.frame or 1
    
        -- whether it acts as an obstacle or not
        self.solid = def.solid
    
        self.defaultState = def.defaultState
        self.state = self.defaultState
        self.states = def.states
        self.toRemove = false
    
        -- dimensions
        self.x = def.x
        self.y = def.y
        self.width = def.width
        self.height = def.height
        self.scale = def.scale or 1
    
        -- default empty collision callback
        self.onCollide = function() end
        
        self.consumable = def.consumable or false
        -- default empty consume callback
        self.onConsume = function() end
    end
    
    function GameObject:update(dt)
    
    end
    
    --[[
        Simple AABB
    ]]
    function GameObject:collides(target)
        return not (self.x + self.width < target.x or self.x > target.x + target.width or
                    self.y + self.height < target.y or self.y > target.y + target.height)
    end
    
    function GameObject:render()
        local frame
        if self.states == nil then
            frame = self.frame
        else
            frame = self.states[self.state].frame
        end
        
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][frame],
            math.floor(self.x), math.floor(self.y), 0, self.scale, self.scale)
    
        -- love.graphics.setColor(255, 0, 255, 255)
        -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
        -- love.graphics.setColor(255, 255, 255, 255)
    end