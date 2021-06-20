--[[
    SpaceLove

    Rafael WO
]]


require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.audio.setVolume(0.4)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- comment out the following lines to print the StateStack to the console (requires game to be started with 'love . --console')
    Event.on('stack-changed', function()
        local stateString = ""
        for k, state in ipairs(gStateStack.states) do
            stateString = stateString .. " | " .. state.name
        end
        print(stateString)
    end
    )

    love.graphics.setFont(gFonts['small'])
    gStateStack = StateStack()
    gStateStack:push(StartState())

    love.keyboard.keysPressed = {}

    METEOR_TYPES = getFrameNamesFromSheet('sheet', 'meteor')
    EXPLOSION_BLAST = getBlast(100)
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

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()


    push:finish()
end