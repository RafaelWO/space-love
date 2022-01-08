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
require 'src/states/game/SelectShipState'

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
require 'src/entity/Ufo'
require 'src/entity/DirectionSet'

require 'src/world/Level'
require 'src/world/Spawner'

require 'src/object/GameObject'
require 'src/object/Laser'
require 'src/object/Meteor'
require 'src/object/Shield'

require 'src/gui/ProgressBar'
require 'src/gui/Menu'
require 'src/gui/Table'
require 'src/gui/Background'
require 'src/gui/PlayerHealthBar'
require 'src/gui/LowHealthOverlay'

gFonts = {
    ['small'] = love.graphics.newFont('fonts/kenvector_future.ttf', 14),
    ['medium'] = love.graphics.newFont('fonts/kenvector_future.ttf', 20),
    ['large'] = love.graphics.newFont('fonts/kenvector_future.ttf', 40),
    ['thin-small'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 14),
    ['thin-medium'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 20),
    ['thin-large'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 40),
    ['default-small'] = love.graphics.newFont(12)
}

gSounds = {
    ['laser-1'] = love.audio.newSource('sounds/sfx_laser1.ogg', 'static'),
    ['laser-2'] = love.audio.newSource('sounds/sfx_laser2.ogg', 'static'),
    ['lose'] = love.audio.newSource('sounds/sfx_lose.ogg', 'static'),
    ['shield-down'] = love.audio.newSource('sounds/sfx_shieldDown.ogg', 'static'),
    ['shield-up'] = love.audio.newSource('sounds/sfx_shieldUp.ogg', 'static'),
    ['two-tone'] = love.audio.newSource('sounds/sfx_twoTone.ogg', 'static'),
    ['zap'] = love.audio.newSource('sounds/sfx_zap.ogg', 'static'),
    ['powerup-health'] = love.audio.newSource('sounds/sfx_sounds_powerup12.wav', 'static'),
    ['health-alarm'] = love.audio.newSource('sounds/sfx_alarm_loop6.wav', 'static'),
    ['impact'] = love.audio.newSource('sounds/sfx_sounds_impact8.wav', 'static'),
    ['collision'] = love.audio.newSource('sounds/sfx_sounds_impact11.wav', 'static'),

    ['music-title-screen'] = love.audio.newSource('sounds/music/music-title-screen.wav', 'stream'),
    ['music-lvl1'] = love.audio.newSource('sounds/music/music-lvl1.wav', 'stream'),
    ['music-lvl2'] = love.audio.newSource('sounds/music/music-lvl2.wav', 'stream'),
    ['music-lvl3'] = love.audio.newSource('sounds/music/music-lvl3.wav', 'stream'),
    ['music-ending'] = love.audio.newSource('sounds/music/music-ending.wav', 'stream'),

    ['menu-move'] = love.audio.newSource('sounds/menu/sfx_menu_move1.wav', 'static'),
    ['menu-select'] = love.audio.newSource('sounds/menu/sfx_menu_select2.wav', 'static'),
    ['pause-start'] = love.audio.newSource('sounds/menu/sfx_sounds_pause6_in.wav', 'static'),
    ['pause-end'] =  love.audio.newSource('sounds/menu/sfx_sounds_pause6_out.wav', 'static'),
}

for i = 1, EXPLOSION_SHORT_COUNT, 1 do
    gSounds['explosion-short-' .. i] = love.audio.newSource('sounds/explosion_short/sfx_exp_short_hard' .. i ..'.wav', 'static')
end

for i = 1, EXPLOSION_MEDIUM_COUNT, 1 do
    gSounds['explosion-medium-' .. i] = love.audio.newSource('sounds/explosion_medium/sfx_exp_medium' .. i ..'.wav', 'static')
end

for k, sound in pairs(gSounds) do
    if string.match(k, "music") then
        sound:setVolume(0.4)
        sound:setLooping(true)
    end
end

gSounds['health-alarm']:setLooping(true)


gTextures = {
    ['sheet'] = love.graphics.newImage('graphics/sheet_edited.png'),

    ['bg_black'] = love.graphics.newImage('graphics/backgrounds/black.png'),
    ['bg_blue'] = love.graphics.newImage('graphics/backgrounds/blue.png'),
    ['bg_dark-purple'] = love.graphics.newImage('graphics/backgrounds/darkPurple.png'),
    ['bg_purple'] = love.graphics.newImage('graphics/backgrounds/purple.png'),

    ['arrow-left'] = love.graphics.newImage('graphics/ui/arrowSilver_left.png'),
    ['arrow-right'] = love.graphics.newImage('graphics/ui/arrowSilver_right.png'),

    ['nebula-1'] = love.graphics.newImage('graphics/backgrounds/nebula_blue_yellow.png'),
    ['nebula-2'] = love.graphics.newImage('graphics/backgrounds/nebula_pink_turqoise.png'),
    ['nebula-3'] = love.graphics.newImage('graphics/backgrounds/nebula_violet_green.png'),
    ['nebula-4'] = love.graphics.newImage('graphics/backgrounds/nebula_green_red.png'),
}

gFrames = {
    ['sheet'] = generateQuadsFromXml('graphics/sheet_edited.xml', gTextures['sheet']),
}