Menu = Class{}

function Menu:init(def)
    self.x = def.x or 0
    self.y = def.y or (VIRTUAL_HEIGHT / 2)

    self.texts = def.texts
    self.callbacks = def.callbacks
    self.sideOptions = def.sideOptions or {}
    self.sideOptionsSelected = {}
    for k, opt in pairs(self.sideOptions) do
        table.insert(self.sideOptionsSelected, 1)
    end
    self.selected = 1
end

--[[
    Functions for moving to the next or pervious menu entry in the "normal" menu (vertically)
]]
function Menu:next()
    gSounds['menu-move']:play()
    self.selected = self.selected < #self.texts and self.selected + 1 or 1
end

function Menu:previous()
    gSounds['menu-move']:play()
    self.selected = self.selected > 1 and self.selected - 1 or #self.texts
end

--[[
    Functions for moving to the next (right) or pervious (left) side option of a menu entry (horizontally)
]]
function Menu:right()
    gSounds['menu-move']:play()
    local curr_sel = self.sideOptionsSelected[self.selected]
    self.sideOptionsSelected[self.selected] = curr_sel < #self.sideOptions[self.selected] and curr_sel + 1 or 1
end

function Menu:left()
    gSounds['menu-move']:play()
    local curr_sel = self.sideOptionsSelected[self.selected]
    self.sideOptionsSelected[self.selected] = curr_sel > 1 and curr_sel - 1 or #self.sideOptions[self.selected]
end

function Menu:getSelectedSideText(menuIdx)
    return self.sideOptions[menuIdx][self.sideOptionsSelected[menuIdx]]
end

function Menu:update(dt)
    if love.keyboard.wasPressed('down') then
        self:next()
    elseif love.keyboard.wasPressed('up') then
        self:previous()
    end

    if self.sideOptions[self.selected] then
        if love.keyboard.wasPressed('right') then
            self:right()
        elseif love.keyboard.wasPressed('left') then
            self:left()
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['menu-select']:play()
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

        if self.sideOptions[k] then
            -- First print quotes in same color as the menu entry (it's a description in this case) one line below 
            -- The quotes should show that one can use the left/a´right arrow key to change the option
            local quotes = "«" .. string.rep("\t", 7) .. "»"
            offsetY = offsetY + 20
            love.graphics.printf(quotes, self.x, self.y + offsetY, VIRTUAL_WIDTH, 'center')
            
            -- Then print the option text
            if k == self.selected then
                love.graphics.setColor(200, 200, 200, 255)
            else
                love.graphics.setColor(50, 50, 50, 255)
            end
            love.graphics.printf(self:getSelectedSideText(k), self.x, self.y + offsetY, VIRTUAL_WIDTH, 'center')
        end
        offsetY = offsetY + 30
    end
end