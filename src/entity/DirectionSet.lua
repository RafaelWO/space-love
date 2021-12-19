DirectionSet = Class{}

function DirectionSet:init(initialDirection)
    self.set = {
        ["left"] = false,
        ["right"] = false,
        ["up"] = false,
        ["down"] = false
    }

    if initialDirection ~= nil then
        self.set[initialDirection] = true
    end

end

function DirectionSet:add(key)
    self.set[key] = true
end

function DirectionSet:remove(key)
    self.set[key] = false
end

function DirectionSet:reset()
    for direction, enabled in pairs(self.set) do
        self.set[direction] = false
    end
end

function DirectionSet:contains(key)
    return self.set[key]
end

function DirectionSet:isEmpty()
    for direction, enabled in pairs(self.set) do
        if enabled then
            return false
        end
    end
    return true
end

function DirectionSet:current()
    local msg = ""
    for direction, enabled in pairs(self.set) do
        if enabled then
            msg = direction .. ", " .. msg
        end
    end
    return msg:sub(0, msg:len()-2)
end
