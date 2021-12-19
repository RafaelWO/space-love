PlayState = Class{__includes = BaseState}

function PlayState:init(params)
    self.name = "PlayState"

    -- start our level # label off-screen
    self.stageLabelY = -64
    self.stageLabelText = ""

    self.timers = {}

    --[[
        Based on GD50 Assignment 3 (Match-3)
    ]]
    Event.on('stage-changed', function(stage)
        self.stageLabelText = stage
        self.transitionAlpha = 80/255

        -- first, over a period of 1 second, transition our alpha to 0
        Timer.tween(1, {
            [self] = {transitionAlpha = 0}
        })
        
        -- once that's finished, start a transition of our text label to
        -- the center of the screen over 0.25 seconds
        :finish(function()
            Timer.tween(0.25, {
                [self] = {stageLabelY = VIRTUAL_HEIGHT / 2 - 8}
            }):group(self.timers)
            
            -- after that, pause for one second with Timer.after
            :finish(function()
                Timer.after(1, function()
                    
                    -- then, animate the label going down past the bottom edge
                    Timer.tween(0.25, {
                        [self] = {stageLabelY = VIRTUAL_HEIGHT + 30}
                    }):group(self.timers)
                    
                    -- once that's complete, reset the variables
                    :finish(function()
                        self.stageLabelY = -64
                    end)
                end):group(self.timers)
            end)
        end):group(self.timers)
    end)

    self.level = Level(params)
end

function PlayState:update(dt)
    Timer.update(dt, self.timers)
    Timer.update(dt, self.level.timers)
    self.level:update(dt)

    if love.keyboard.wasPressed('p') then
        -- Pass in level music so that it is paused (and resumed again on pause exit)
        gStateStack:push(PauseState(self.level))
    end
end

function PlayState:render()
    self.level:render()

    -- render Stage # label and background rect
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.stageLabelY - 2, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.stageLabelText, 0, self.stageLabelY, VIRTUAL_WIDTH, 'center')

    -- our transition foreground rectangle
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function PlayState:exit()
    
end