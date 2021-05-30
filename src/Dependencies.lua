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
require 'src/entity/Entity'
require 'src/entity/Player'

require 'src/world/Level'

require 'src/object/object_defs'
require 'src/object/GameObject'
require 'src/object/Laser'
require 'src/object/Meteor'
require 'src/object/Jet'

gFonts = {
    ['small'] = love.graphics.newFont('SpaceShooterRedux/Bonus/kenvector_future.ttf', 8),
    ['medium'] = love.graphics.newFont('SpaceShooterRedux/Bonus/kenvector_future.ttf', 16),
    ['large'] = love.graphics.newFont('SpaceShooterRedux/Bonus/kenvector_future.ttf', 32),
    ['thin-small'] = love.graphics.newFont('SpaceShooterRedux/Bonus/kenvector_future_thin.ttf', 8),
    ['thin-medium'] = love.graphics.newFont('SpaceShooterRedux/Bonus/kenvector_future_thin.ttf', 16),
    ['thin-large'] = love.graphics.newFont('SpaceShooterRedux/Bonus/kenvector_future_thin.ttf', 32),
}

gSounds = {
    ['laser-1'] = love.audio.newSource('SpaceShooterRedux/Bonus/sfx_laser1.ogg'),
    ['laser-2'] = love.audio.newSource('SpaceShooterRedux/Bonus/sfx_laser2.ogg'),
    ['lose'] = love.audio.newSource('SpaceShooterRedux/Bonus/sfx_lose.ogg'),
    ['shield-down'] = love.audio.newSource('SpaceShooterRedux/Bonus/sfx_shieldDown.ogg'),
    ['shield-up'] = love.audio.newSource('SpaceShooterRedux/Bonus/sfx_shieldUp.ogg'),
    ['two-tone'] = love.audio.newSource('SpaceShooterRedux/Bonus/sfx_twoTone.ogg'),
    ['zap'] = love.audio.newSource('SpaceShooterRedux/Bonus/sfx_zap.ogg'),

    ['music-title-screen'] = love.audio.newSource('sounds/music-title-screen.wav'),
    ['music-lvl1'] = love.audio.newSource('sounds/music-lvl1.wav'),
    ['music-lvl2'] = love.audio.newSource('sounds/music-lvl2.wav'),
    ['music-lvl3'] = love.audio.newSource('sounds/music-lvl3.wav'),
    ['music-ending'] = love.audio.newSource('sounds/music-ending.wav'),
}

for k, sound in pairs(gSounds) do
    if string.match(k, "music") then
        print(k)
        sound:setVolume(0.5)
    end
end


gTextures = {
    ['sheet'] = love.graphics.newImage('SpaceShooterRedux/Spritesheet/sheet.png'),

    ['bg_black'] = love.graphics.newImage('SpaceShooterRedux/Backgrounds/black.png'),
    ['bg_blue'] = love.graphics.newImage('SpaceShooterRedux/Backgrounds/blue.png'),
    ['bg_dark-purple'] = love.graphics.newImage('SpaceShooterRedux/Backgrounds/darkPurple.png'),
    ['bg_purple'] = love.graphics.newImage('SpaceShooterRedux/Backgrounds/purple.png'),
}

gFrames = {
    ['sheet'] = generateQuadsFromXml('SpaceShooterRedux/Spritesheet/sheet.xml', gTextures['sheet'])
}