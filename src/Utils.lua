function generateQuadsFromXml(sheetXml, atlas)
    local document = xmlparser.parseFile(sheetXml)

    local rootNode = document.children[1]
    local textures = {}
    for i, texture in pairs(rootNode.children) do
        quad = love.graphics.newQuad(texture.attrs.x, texture.attrs.y, texture.attrs.width, texture.attrs.height, atlas:getDimensions())
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