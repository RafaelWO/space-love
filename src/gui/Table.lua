Table = Class{}

function Table:init(def)
    self.x = def.x or 0
    self.y = def.y or (VIRTUAL_HEIGHT / 2)

    self.rows = def.rows
    self.header = def.header
    self.rowNumbering = def.rowNumbering or true
    self.rowOffset = def.rowOffset or 40
    self.itemOffsets = def.itemOffsets
    self.lastWrap = def.lastWrap or 100
end

function Table:update(dt)

end

function Table:render()
    love.graphics.setFont(gFonts['medium'])
    if self.header then
        self:renderHeader()
    end
    local offsetY = 0
    for i, row in ipairs(self.rows) do
        self:printRow(row, i, offsetY)
        offsetY = offsetY + self.rowOffset
    end
end

function Table:renderHeader()
    love.graphics.setColor(150/255, 150/255, 150/255, 1)
    local offsetY = -40
    self:printRow(self.header, "#", offsetY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.line(
        self.x, self.y - 10,
        self.x + self.itemOffsets[#self.itemOffsets] + self.lastWrap, self.y - 10
    )
end

function Table:printRow(row, rowNumber, offsetY)
    if offsetY == nil then
        offsetY = 0
    end
    if self.rowNumbering and rowNumber then
        love.graphics.printf(rowNumber .. ".", self.x, self.y + offsetY, VIRTUAL_WIDTH, 'left')
    end
    for j, item in ipairs(row) do
        -- print last item right aligned
        align = j == #row and "right" or "left"
        wrap = j == #row and self.lastWrap or VIRTUAL_WIDTH
        love.graphics.printf(item, self.x + self.itemOffsets[j], self.y + offsetY, wrap, align)
    end
end