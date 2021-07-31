Table = Class{}

function Table:init(def)
    self.x = def.x or 0
    self.y = def.y or (VIRTUAL_HEIGHT / 2)

    self.rows = def.rows
    self.rowOffset = def.rowOffset or 30
    self.itemOffsets = def.itemOffsets
end

function Table:update(dt)

end

function Table:render()
    love.graphics.setFont(gFonts['medium'])
    local offsetY = 0
    for i, row in ipairs(self.rows) do
        love.graphics.printf(i .. ".", self.x, self.y + offsetY, VIRTUAL_WIDTH, 'left')
        for j, item in ipairs(row) do
            -- print last item right aligned
            align = j == #row and "right" or "left"
            wrap = j == #row and 100 or VIRTUAL_WIDTH
            love.graphics.printf(item, self.x + self.itemOffsets[j], self.y + offsetY, wrap, align)
        end
        offsetY = offsetY + self.rowOffset
    end
end