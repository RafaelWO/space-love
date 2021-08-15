PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"

    -- start our level # label off-screen
    self.stageLabelY = -64
    self.stageLabelText = ""

    --[[
        Based on GD50 Assignment 3 (Match-3)
    ]]
    Event.on('stage-changed', function(stage)
        self.stageLabelText = stage
        self.transitionAlpha = 150

        -- first, over a period of 1 second, transition our alpha to 0
        Timer.tween(1, {
            [self] = {transitionAlpha = 0}
        })
        
        -- once that's finished, start a transition of our text label to
        -- the center of the screen over 0.25 seconds
        :finish(function()
            Timer.tween(0.25, {
                [self] = {stageLabelY = VIRTUAL_HEIGHT / 2 - 8}
            })
            
            -- after that, pause for one second with Timer.after
            :finish(function()
                Timer.after(1, function()
                    
                    -- then, animate the label going down past the bottom edge
                    Timer.tween(0.25, {
                        [self] = {stageLabelY = VIRTUAL_HEIGHT + 30}
                    })
                    
                    -- once that's complete, reset the variables
                    :finish(function()
                        self.stageLabelY = -64
                    end)
                end)
            end)
        end)
    end)

    self.level = Level()
end

function PlayState:update(dt)
    self.level:update(dt)

    if love.keyboard.wasPressed('p') then
        gStateStack:push(PauseState(gSounds['music-lvl' .. self.level.stage]))
    end
end

function PlayState:render()
    self.level:render()

    -- render Stage # label and background rect
    love.graphics.setColor(95, 205, 228, 200)
    love.graphics.rectangle('fill', 0, self.stageLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.stageLabelText, 0, self.stageLabelY, VIRTUAL_WIDTH, 'center')

    -- our transition foreground rectangle
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function PlayState:exit()
    
end