local utf8 = require("utf8")

HighscoreState = Class{__includes = BaseState}

function HighscoreState:init(enterParams)
    self.name = "HighscoreState"
    self.table = nil
    self.scoreRows = self:readScores()
    if self.scoreRows ~= nil then
        self.table = Table({
            x = 490,
            y = 200,
            rows = self.scoreRows,
            itemOffsets = { 50, 200 }
        })
    end

    self.menu = Menu {
        y = 200 + (HIGHSCORES_LIMIT + 2) * 30,
        texts = {
            "Return to main menu"
        },
        callbacks = {
            function()
                gSounds['music-ending']:stop()
                gStateStack:pop()
                gStateStack:push(StartState())
            end
        }
    }
end

function HighscoreState:update(dt)
    self.menu:update(dt)
end

function HighscoreState:render()
    love.graphics.setColor(250, 250, 250, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Highscores', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    if self.table then
        self.table:render()
    else
        love.graphics.printf("No scores", 0, 200 + 30, VIRTUAL_WIDTH, 'center')
    end
    
    self.menu:render()
end

function HighscoreState:readScores(limit)
    if love.filesystem.exists(FILE_HIGHSCORES) then
        content, size = love.filesystem.read(FILE_HIGHSCORES)
        limitedContent = ""
        local rows = {}
        for row in content:gmatch("([^\n]*)\n?") do
            if row:gsub("%s+", "") == "" then
                break
            end
            local items = {} 
            for item in row:gmatch("([^,]+)") do
                table.insert(items, item)
            end
            table.insert(rows, items)
        end

        -- Sort scores descending
        local sortedRows = {}
        local count = 0
        for k,v in spairs(rows, function(t,a,b) return tonumber(t[a][2]) > tonumber(t[b][2]) end) do
            table.insert(sortedRows, v)
            count = count + 1
            if count == 10 then
                break
            end
        end

        -- Write top 10 scores back to file
        data = ""
        for i, row in ipairs(sortedRows) do
            row_str = ""
            for j, item in ipairs(row) do
                row_str = row_str .. item .. ","
            end
            data = data .. row_str:sub(1, row_str:len()-1) .. "\n"
        end

        writeSaveFile(FILE_HIGHSCORES, data)

        return sortedRows
    else
        return nil
    end
end