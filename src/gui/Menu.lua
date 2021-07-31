Menu = Class{}

function Menu:init(def)
    self.x = def.x or 0
    self.y = def.y or (VIRTUAL_HEIGHT / 2)

    self.texts = def.texts
    self.callbacks = def.callbacks
    self.selected = 1
end

function Menu:next()
    self.selected = self.selected < #self.texts and self.selected + 1 or 1
end

function Menu:previous()
    self.selected = self.selected > 1 and self.selected - 1 or #self.texts
end

function Menu:update(dt)
    if love.keyboard.wasPressed('down') then
        self:next()
    elseif love.keyboard.wasPressed('up') then
        self:previous()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.callbacks[self.selected]()
    end
end

function Menu:render()
    love.graphics.setFont(gFonts['medium'])
    local offsetY = 0
    for k, text in pairs(self.texts) do
        if k == self.selected then
            love.graphics.setColor(100, 100, 200, 255)
        else
            love.graphics.setColor(50, 50, 50, 255)
        end
        love.graphics.printf(text, self.x, self.y + offsetY, VIRTUAL_WIDTH, 'center')
        offsetY = offsetY + 30
    end
end