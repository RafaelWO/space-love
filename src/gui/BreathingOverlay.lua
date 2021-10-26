BreathingOverlay = Class{}

function BreathingOverlay:init(def)
    self.color = def.color
    self.interval = def.interval
    self.maxAlpha = def.maxAlpha
    self.alpha = 0
    self.width = def.width
    self.enabled = false
    self.timer = nil
    self.timers = {}
end

function BreathingOverlay:enable()
    self.enabled = true

    self.timer = Timer.every(self.interval, function()
        Timer.tween(self.interval / 2, {
            [self] = {alpha = self.maxAlpha}
        }):group(self.timers)
        :finish(function()
            Timer.tween(self.interval / 2, {
                [self] = {alpha = 0}
            }):group(self.timers)
        end)
    end)
end

function BreathingOverlay:disable()
    self.enabled = false
    if self.timer then
        self.timer:remove()
    end
end

function BreathingOverlay:update(dt)
    if self.enabled then
        Timer.update(dt, self.timers)
    end
end

function BreathingOverlay:render()
    if self.enabled then
        loc = {
            {x = 0, y = 0, w = self.width, h = VIRTUAL_HEIGHT},
            {x = VIRTUAL_WIDTH - self.width, y = 0, w = self.width, h = VIRTUAL_HEIGHT},
            {x = 0, y = 0, w = VIRTUAL_WIDTH, h = self.width},
            {x = 0, y = VIRTUAL_HEIGHT - self.width, w = VIRTUAL_WIDTH, h = self.width},
        }

        local locIdx = 1
        for k, direction in pairs({'vertical', 'horizontal'}) do
            for i = 1, 2, 1 do
                local gradArgs = {
                    direction = direction;
                    {self.color.r, self.color.g, self.color.b};
                    {self.color.r, self.color.g, self.color.b};
                }
                -- Set alpha of colorized part
                gradArgs[i][4] = self.alpha
                
                -- Set other gradient color to be transparted, i.e. alpha = 0
                if i == 1 then
                    gradArgs[2][4] = 0
                else
                    gradArgs[1][4] = 0
                end

                local redGradient = gradient(gradArgs)
                drawinrect(redGradient, loc[locIdx].x, loc[locIdx].y, loc[locIdx].w, loc[locIdx].h)
                locIdx = locIdx + 1
            end
        end
    end
end