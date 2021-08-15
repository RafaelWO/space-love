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
require 'src/states/game/PauseState'
require 'src/states/game/GameOverState'
require 'src/states/game/HighscoreState'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityFlyState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/PlayerFlyState'
require 'src/states/entity/PlayerIdleState'

require 'src/object/object_defs'
require 'src/entity/entity_defs'
require 'src/entity/ship_defs'
require 'src/world/level_defs'

require 'src/entity/Entity'
require 'src/entity/Player'

require 'src/world/Level'


require 'src/object/GameObject'
require 'src/object/Laser'
require 'src/object/Meteor'
require 'src/object/Shield'

require 'src/gui/ProgressBar'
require 'src/gui/Menu'
require 'src/gui/Table'

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
    ['powerup-health'] = love.audio.newSource('sounds/sfx_sounds_powerup12.wav'),
    ['health-alarm'] = love.audio.newSource('sounds/sfx_alarm_loop6.wav'),
    ['impact'] = love.audio.newSource('sounds/sfx_sounds_impact8.wav'),
    ['collision'] = love.audio.newSource('sounds/sfx_sounds_impact11.wav'),

    ['music-title-screen'] = love.audio.newSource('sounds/music/music-title-screen.wav'),
    ['music-lvl1'] = love.audio.newSource('sounds/music/music-lvl1.wav'),
    ['music-lvl2'] = love.audio.newSource('sounds/music/music-lvl2.wav'),
    ['music-lvl3'] = love.audio.newSource('sounds/music/music-lvl3.wav'),
    ['music-ending'] = love.audio.newSource('sounds/music/music-ending.wav'),

    ['menu-move'] = love.audio.newSource('sounds/menu/sfx_menu_move1.wav'),
    ['menu-select'] = love.audio.newSource('sounds/menu/sfx_menu_select2.wav'),
    ['pause-start'] = love.audio.newSource('sounds/menu/sfx_sounds_pause6_in.wav'),
    ['pause-end'] =  love.audio.newSource('sounds/menu/sfx_sounds_pause6_out.wav'),

    ['explosion'] = love.audio.newSource('sounds/explosion.wav')
}

for i = 1, EXPLOSION_SHORT_COUNT, 1 do
    gSounds['explosion-short-' .. i] = love.audio.newSource('sounds/explosion_short/sfx_exp_short_hard' .. i ..'.wav')
end

for i = 1, EXPLOSION_MEDIUM_COUNT, 1 do
    gSounds['explosion-medium-' .. i] = love.audio.newSource('sounds/explosion_medium/sfx_exp_medium' .. i ..'.wav')
end

for k, sound in pairs(gSounds) do
    if string.match(k, "music") then
        sound:setVolume(0.4)
        sound:setLooping(true)
    end
end
gSounds['explosion']:setVolume(0.7)
gSounds['health-alarm']:setLooping(true)


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