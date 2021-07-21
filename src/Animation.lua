--[[
    GD50
    Legend of Zelda

    -- Animation Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.texture = def.texture

    if def.looping ~= nil then
        self.looping = def.looping
    else
        self.looping = true
    end

    self.timer = 0
    self.currentFrame = 1

    -- used to see if we've seen a whole loop of the animation
    self.timesPlayed = 0
end

function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

function Animation:update(dt)
    -- if not a looping animation and we've played at least once, exit
    if not self.looping and self.timesPlayed > 0 then
        return
    end

    -- no need to update if animation is only one frame
    if #self.frames > 1 then
        self.timer = self.timer + dt

        if self.timer > self.interval then
            self.timer = self.timer % self.interval

            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))

            -- if we've looped back to the beginning, set frame to the last frame
            if self.currentFrame == 1 then
                self.timesPlayed = self.timesPlayed + 1
                self.currentFrame = #self.frames
            end
        end
    end
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end