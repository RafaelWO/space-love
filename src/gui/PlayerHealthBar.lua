PlayerHealthBar = Class{__includes = ProgressBar}

function PlayerHealthBar:init(def)
    ProgressBar.init(self, def)
    self.color = {r = 0, g = 1, b = 0} 
    self.text = "health"
    self.separators = true
end

function PlayerHealthBar:update(dt)
    ProgressBar.update(self, dt)

    local frac = self.value / self.max

    if frac > 0.5 then
        self.color = {r = 0, g = 1, b = 0} 
    elseif self.value > 1 then
        self.color = {r = 1, g = 1, b = 0} 
    else
        self.color = {r = 1, g = 0, b = 0} 
    end
end