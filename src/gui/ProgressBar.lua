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
    
    self.color = def.color or {r = 255, g = 255, b = 255}           -- defaults to white
    self.outlineColor = def.outlineColor or {r = 0, g = 0, b = 0}   -- defaults to black
    self.textColor = def.textColor or {r = 255, g = 255, b = 255}   -- defaults to white

    self.value = def.value or 0
    self.min = def.min or 0
    self.max = def.max
    self.text = def.text
    self.font = def.font or gFonts['small']
    self.separators = def.separators or false
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
        love.graphics.setColor(self.textColor.r, self.textColor.g, self.textColor.b, 255)
        love.graphics.setFont(self.font)
        love.graphics.print(self.text, self.x, self.y)
    end

    local value = self.value - self.min
    local max = self.max - self.min
    -- multiplier on width based on progress
    local renderWidth = math.min(value / max, 1) * self.width

    if value > 0 then
        -- draw main bar, with calculated width based on value / max
        love.graphics.setColor(self.color.r, self.color.g, self.color.b, 255)
        love.graphics.rectangle('fill', self.x, self.y + yOffset, renderWidth, self.height, 2)
    end

    -- draw outline around actual bar
    love.graphics.setColor(self.outlineColor.r, self.outlineColor.g, self.outlineColor.b, 255)
    love.graphics.rectangle('line', self.x, self.y + yOffset, self.width, self.height, 2)

    if self.separators then
        love.graphics.setLineWidth(1)
        for x = self.x, (self.x + self.width), (self.width / max) do
            love.graphics.line(x, self.y + yOffset, x, self.y + yOffset + self.height)
        end
    end
    
    love.graphics.setColor(255, 255, 255, 255)
end