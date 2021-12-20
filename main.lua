--[[
    SpaceLove

    Rafael WO
]]


require 'src/Dependencies'

function love.load()
    print(_VERSION)
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.audio.setVolume(0.7)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- comment out the following lines to print the StateStack to the console (requires game to be started with 'love . --console')
    if DEBUG then
        Event.on('stack-changed', function()
            local stateString = ""
            for k, state in ipairs(gStateStack.states) do
                stateString = stateString .. " | " .. state.name
            end
            print(stateString)
        end
        )
    end

    love.graphics.setFont(gFonts['small'])
    gStateStack = StateStack()
    gStateStack:push(StartState({}))

    love.keyboard.keysPressed = {}
    love.keyboard.textInput = ""

    METEOR_TYPES = getFrameNamesFromSheet('sheet', 'meteor')
    EXPLOSION_BLAST = getBlast(100)

    local menuBlinkInterval = 0.6
    Timer.every(menuBlinkInterval, function()
        Timer.tween(menuBlinkInterval / 2, {
            [MENU_SELECTED_COLOR] = { r = 100/255, g = 100/255, b = 100/255}
        }):finish(function ()
            Timer.tween(menuBlinkInterval / 2, {
                [MENU_SELECTED_COLOR] = {r = 150/255, g = 100/255, b = 255/255}
            })
        end)
    end)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


function love.textinput(t)
    love.keyboard.textInput = t
end

function love.update(dt)
    if DEBUG then
        require("lovebird").update()
    end
    Timer.update(dt)
    gStateStack:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    love.keyboard.keysPressed = {}
    love.keyboard.textInput = ""
end

function love.draw()
    push:start()
    
    gStateStack:render()
    love.graphics.setColor(150/255, 150/255, 150/255, 255/255)
    love.graphics.setFont(gFonts['default-small'])
    love.graphics.printf(VERSION, 10, VIRTUAL_HEIGHT-25, VIRTUAL_WIDTH, 'left')

    push:finish()
end