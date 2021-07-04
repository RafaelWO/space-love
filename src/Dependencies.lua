--[[
    Libraries
]]

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
require 'lib/xmlparser'

require 'src/Utils'
require 'src/constants'
require 'src/Animation'
require 'src/Hitbox'

require 'src/states/StateStack'
require 'src/states/BaseState'
require 'src/states/StateMachine'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'
require 'src/states/game/GameOverState'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityFlyState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/PlayerFlyState'
require 'src/states/entity/PlayerIdleState'

require 'src/entity/entity_defs'
require 'src/entity/ship_defs'
require 'src/entity/Entity'
require 'src/entity/Player'

require 'src/world/Level'

require 'src/object/object_defs'
require 'src/object/GameObject'
require 'src/object/Laser'
require 'src/object/Meteor'
require 'src/object/Jet'

require 'src/gui/ProgressBar'
require 'src/gui/Menu'

gFonts = {
    ['small'] = love.graphics.newFont('fonts/kenvector_future.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/kenvector_future.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/kenvector_future.ttf', 32),
    ['thin-small'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 8),
    ['thin-medium'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 16),
    ['thin-large'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 32),
}

gSounds = {
    ['laser-1'] = love.audio.newSource('sounds/sfx_laser1.ogg'),
    ['laser-2'] = love.audio.newSource('sounds/sfx_laser2.ogg'),
    ['lose'] = love.audio.newSource('sounds/sfx_lose.ogg'),
    ['shield-down'] = love.audio.newSource('sounds/sfx_shieldDown.ogg'),
    ['shield-up'] = love.audio.newSource('sounds/sfx_shieldUp.ogg'),
    ['two-tone'] = love.audio.newSource('sounds/sfx_twoTone.ogg'),
    ['zap'] = love.audio.newSource('sounds/sfx_zap.ogg'),

    ['music-title-screen'] = love.audio.newSource('sounds/music-title-screen.wav'),
    ['music-lvl1'] = love.audio.newSource('sounds/music-lvl1.wav'),
    ['music-lvl2'] = love.audio.newSource('sounds/music-lvl2.wav'),
    ['music-lvl3'] = love.audio.newSource('sounds/music-lvl3.wav'),
    ['music-ending'] = love.audio.newSource('sounds/music-ending.wav'),

    ['explosion'] = love.audio.newSource('sounds/explosion.wav')
}

for k, sound in pairs(gSounds) do
    if string.match(k, "music") then
        print(k)
        sound:setVolume(0.5)
    end
end
gSounds['explosion']:setVolume(0.7)


gTextures = {
    ['sheet'] = love.graphics.newImage('graphics/sheet_edited.png'),

    ['bg_black'] = love.graphics.newImage('graphics/backgrounds/black.png'),
    ['bg_blue'] = love.graphics.newImage('graphics/backgrounds/blue.png'),
    ['bg_dark-purple'] = love.graphics.newImage('graphics/backgrounds/darkPurple.png'),
    ['bg_purple'] = love.graphics.newImage('graphics/backgrounds/purple.png'),
}

gFrames = {
    ['sheet'] = generateQuadsFromXml('graphics/sheet_edited.xml', gTextures['sheet']),
}