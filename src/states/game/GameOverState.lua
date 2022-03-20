local utf8 = require("utf8")

GameOverState = Class{__includes = BaseState}

function GameOverState:init(params)
    self.name = "GameOverState"
    self.background = Background(MENU_BACKGROUND)
    self.score = params.score
    self.shipType = params.shipType
    self.playerName = ""
    self.cursor = "_"
    self.cursorTimer = Timer.every(0.5, function()
        local cursorSymbol = utf8.len(self.playerName) < 8 and "_" or ""
        self.cursor = (self.cursor == cursorSymbol) and " " or cursorSymbol
    end)

    self.menu = Menu {
        y = VIRTUAL_HEIGHT / 2 + 150,
        texts = {
            "Submit Score",
            "Skip"
        },
        callbacks = {
            function()
                if utf8.len(self.playerName) > 0 then
                    self:submitScore()
                    gStateStack:pop()
                    gStateStack:push(HighscoreState({background = self.background}))
                end
            end,
            function()
                gSounds['music-ending']:stop()
                gStateStack:pop()
                gStateStack:push(StartState({background = self.background}))
            end
        }
    }

    gSounds['music-ending']:setLooping(true)
    gSounds['music-ending']:play()
end

function GameOverState:update(dt)
    self.menu:update(dt)
    self.background:update(dt)

    if love.keyboard.textInput:gsub("%s+", "") ~= "" and
            love.keyboard.textInput ~= "," and utf8.len(self.playerName) < 8 then
        self.playerName = self.playerName .. love.keyboard.textInput:upper()
    end

    if love.keyboard.wasPressed('backspace') and self.playerName ~= "" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(self.playerName, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            self.playerName = self.playerName:sub(1, byteoffset - 1)
        end
    end
end

function GameOverState:render()
    self.background:render()
    self.menu:render()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 200, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your score was:', 0, VIRTUAL_HEIGHT / 2 - 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.score, 0, VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Enter name:', 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(self.playerName .. self.cursor, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + 80, VIRTUAL_WIDTH)
end

function GameOverState:exit()
    self.cursorTimer:remove()
end

function GameOverState:submitScore()
    data = self.playerName .. "," .. self.shipType .. "," .. self.score .. "\n"

    writeSaveFile(FILE_HIGHSCORES, data, 'append')
end