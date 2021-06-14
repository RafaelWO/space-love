Jet = Class{__includes = GameObject}

function Jet:init(x, y, def, parent, parentOffset)
    GameObject.init(self, x, y, def)
    self.parent = parent
    self.parentOffset = parentOffset

    self.x = x
    self.y = y
end

function Jet:update(dt)
    GameObject.update(self, dt)

    self.x = self.parent.x + self.parentOffset.x
    self.y = self.parent.y + self.parentOffset.y
end
