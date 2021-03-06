function generateQuadsFromXml(sheetXml, atlas)
    local sheetFile = love.filesystem.read(sheetXml)
    local document = xmlparser.parse(sheetFile)

    local rootNode = document.children[1]
    local textures = {}
    for i, texture in pairs(rootNode.children) do
        quad = love.graphics.newQuad(
            texture.attrs.x, texture.attrs.y, texture.attrs.width, texture.attrs.height, atlas:getDimensions()
        )
        textureName = string.sub(texture.attrs.name, 1, string.len(texture.attrs.name) - 4)
        textures[textureName] = quad
    end
    return textures
end


--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
function generateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end


function getVersion()
    local version = love.filesystem.read("VERSION")
    return version:sub(1, 1) .. "" .. version:sub(2)
end


--[[
    Print utils for xmlparser; from https://github.com/jonathanpoelen/xmlparser
]]
function printelem(e, prefix)
    prefix = prefix or ''
    if e.tag then
        print(prefix .. '<' .. e.tag .. '>')
        prefix = '  ' .. prefix
        for name, value in pairs(e.attrs) do
            print(prefix .. '@' .. name .. ': ' .. value)
        end
        for i, child in pairs(e.children) do
            printelem(child, prefix)
        end
    else
        print(prefix .. '<> ' .. e.text)
    end
end


function printdoc(doc)
    print('Entities:')
    for i, e in pairs(doc.entities) do
        print('  ' .. e.name .. ': ' .. e.value)
    end
    print('Data:')
    for i, child in pairs(doc.children) do
        printelem(child, '  ')
    end
end


function getFrameNamesFromSheet(sheet, name)
    local matchedNames = {}
    for frame, quad in pairs(gFrames['sheet']) do
        if string.match(frame, name) then
            table.insert(matchedNames, frame)
        end
    end
    return matchedNames
end


function getHitboxFromDef(object, hitbox)
    return Hitbox (object.x + hitbox.xOffset, object.y + hitbox.yOffset, hitbox.width, hitbox.height)
end

--[[
    See http://lua-users.org/wiki/CopyTable
]]
function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[
    See https://dev.to/jeansberg/make-a-shooter-in-lualove2d---animations-and-particles
]]
function getBlast(size)
    local blast = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(blast)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", size/2, size/2, size/2)
    love.graphics.setCanvas()
    return blast
end

--[[
    See https://dev.to/jeansberg/make-a-shooter-in-lualove2d---animations-and-particles
]]
function getExplosion(image, source)
    pSystem = love.graphics.newParticleSystem(image, 50)
    pSystem:setParticleLifetime(0.8, 0.8)
    pSystem:setLinearAcceleration(-100, -100, 100, 100)
    if source == "ship" then
        pSystem:setColors(
            255/255, 255/255, 0, 255/255,
            255/255, 153/255, 51/255, 255/255,
            64/255, 64/255, 64/255, 0
        )
    elseif source == "meteor" then
        pSystem:setColors(
            100/255, 100/255, 100/255, 255/255,
            180/255, 180/255, 180/255, 255/255,
            64/255, 64/255, 64/255, 0
        )
    end
    pSystem:setSizes(0.5, 0.7)
    return pSystem
end

--[[
    See https://stackoverflow.com/a/15706820/9478384
]]
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


function printTable(tbl)
    for k, val in pairs(tbl) do
        print(k, val)
    end
end


function writeSaveFile(file, data, mode)
    if mode == "append" and love.filesystem.getInfo(file) then
        success, message = love.filesystem.append(file, data)
        fsType = "fs-append"
    else
        success, message = love.filesystem.write(file, data)
        fsType = "fs-write"
    end

    if success then
        print(fsType .. " success")
    else
        print(fsType .. " failure: " .. message)
    end
end


function color2rgb(color)
    color = color:lower()
    if color == "red" then
        return {r = 1, g = 0, b = 0}
    elseif color == "green" then
        return {r = 0, g = 1, b = 0}
    elseif color == "blue" then
        return {r = 0, g = 0, b = 1}
    elseif color == "white" then
        return {r = 1, g = 1, b = 1}
    elseif color == "black" then
        return {r = 0, g = 0, b = 0}
    elseif color == "orange" then
        return {r = 1, g = 140/255, b = 0}
    end
end

--[[
    From https://love2d.org/wiki/Gradients
]]
function gradient(colors)
    local direction = colors.direction or "horizontal"
    if direction == "horizontal" then
        direction = true
    elseif direction == "vertical" then
        direction = false
    else
        error("Invalid direction '" .. tostring(direction) .. "' for gradient.  Horizontal or vertical expected.")
    end
    local result = love.image.newImageData(direction and 1 or #colors, direction and #colors or 1)
    for i, color in ipairs(colors) do
        local x, y
        if direction then
            x, y = 0, i - 1
        else
            x, y = i - 1, 0
        end
        result:setPixel(x, y, color[1], color[2], color[3], color[4] or 1)
    end
    result = love.graphics.newImage(result)
    result:setFilter('linear', 'linear')
    return result
end

--[[
    From https://love2d.org/wiki/Gradients
]]
function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
    return -- tail call for a little extra bit of efficiency
    love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end


function degree2radian(degree)
    return degree * math.pi / 180
end
