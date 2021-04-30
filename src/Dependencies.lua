--[[
    Libraries
]]

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'

require 'src/states/StateStack'
require 'src/states/BaseState'

require 'src/states/game/StartState'

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
}