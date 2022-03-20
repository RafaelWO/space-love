VIRTUAL_WIDTH = 1600
VIRTUAL_HEIGHT = 1000

WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 1000

HUD_PADDING = 20
HUD_ITEM_MARGIN = 40

HEALTH_BAR_TEXT_OFFSET = 18

GAME_SPEED_MULTIPLIER = 1.2

BACKGROUND_SIZE = 256
BACKGROUND_SPEED = 50
BACKGROUNDS = {'bg_black', 'bg_blue', 'bg_dark-purple'}
MENU_BACKGROUND = 'bg_black'

NEBULA_COUNT = 4
NEBULA_HEIGHT = 2160
NEBULA_WIDTH = 2160
NEBULA_SPEED = 30

MENU_SELECTED_COLOR = {r = 150/255, g = 100/255, b = 255/255}

PLAYER_LASER_SPEED = 600 * GAME_SPEED_MULTIPLIER

METEOR_SPEED = 80
METEOR_TYPES = {}       -- gets filled after load
METEOR_COLLISION_DAMAGE = 0.5

ENEMY_COLLOSION_DAMAGE = 1
SCREEN_BARRIER_SIZE = 210

POWERUP_SPEED = 60
POWERUP_PROB_MAX = 80
NO_POWERUP_THRESH = 9

FILE_HIGHSCORES = "highscores"
HIGHSCORES_LIMIT = 10

FILE_SHIP = "selected_ship"

EXPLOSION_SHORT_COUNT = 17
EXPLOSION_MEDIUM_COUNT = 13

-- get set in love.load() (main.lua)
EXPLOSION_BLAST_SHIP = nil
EXPLOSION_BLAST_METEOR_SM = nil
EXPLOSION_BLAST_METEOR_MD = nil
EXPLOSION_BLAST_METEOR_LG = nil

-- https://love2d.org/forums/viewtopic.php?t=79617
-- white shader that will turn a sprite completely white when used; allows us
-- to brightly blink the sprite when it's acting
WHITE_SHADER = [[
    extern number WhiteFactor;

    vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
    {
        vec4 outputcolor = Texel(tex, texcoord) * vcolor;
        outputcolor.rgb += vec3(WhiteFactor);
        return outputcolor;
    }
]]

RED_HIGHLIGHT_SHADER = [[
    extern bool isActive;

    vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
    {
        vec4 outputcolor = Texel(tex, texcoord) * vcolor;
        if (isActive) {
            outputcolor.b = 0;
            outputcolor.r = outputcolor.r * 1.7;
        }
        return outputcolor;
    }
]]

VERSION = getVersion()
DEBUG = false