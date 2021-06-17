--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ProgressBar = Class{}

function ProgressBar:init(def)
    self.x = def.x
    self.y = def.y
    
    self.parent = def.parent
    self.parentOffset = def.parentOffset
    
    self.width = def.width
    self.height = def.height
    
    self.color = def.color

    self.value = def.value
    self.max = def.max
    self.text = def.text
end

function ProgressBar:setMax(max)
    self.max = max
end

function ProgressBar:setValue(value)
    self.value = value
end

function ProgressBar:update(dt)
    if self.parent then
        self.x = self.parent.x + self.parentOffset.x
        self.y = self.parent.y + self.parentOffset.y
    end
end

function ProgressBar:render()
    -- print text above bar (if set)
    local yOffset = self.text and 18 or 0
    if self.text then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.print(self.text, self.x, self.y)
    end

    -- multiplier on width based on progress
    local renderWidth = (self.value / self.max) * self.width

    -- draw main bar, with calculated width based on value / max
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 255)
    
    if self.value > 0 then
        love.graphics.rectangle('fill', self.x, self.y + yOffset, renderWidth, self.height, 2)
    end

    -- draw outline around actual bar
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('line', self.x, self.y + yOffset, self.width, self.height, 2)
    love.graphics.setColor(255, 255, 255, 255)
end