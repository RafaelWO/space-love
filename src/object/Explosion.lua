Explosion = Class{__includes = GameObject}

function Explosion:createAnimations(animations)
    local animationsReturned = {}
    local animationDef = animations['explode']
    local frames = {}
    for i = 1, #gFrames[animationDef.texture] do
        table.insert(frames, i)
    end

    animationsReturned['explode'] = Animation {
        texture = animationDef.texture,
        frames = frames,
        interval = animationDef.interval,
        looping = animationDef.looping
    }

    return animationsReturned
end