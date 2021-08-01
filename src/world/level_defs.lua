LEVEL_DIFFICULTY = {
    {   
        --[[
            Spawn probabilites for enemies
            The key is the "less-than-probability", i.e. 'enemy-1' spawns with a probability of 1 - 0.6 = 0.4
        ]]
        ['enemy-spawn-probs'] = {
            [1] = 'enemy-1',
            [0.6] = 'enemy-2',
            [0.3] = 'enemy-3',
            [0.1] = 'enemy-4',
            [0.05] = 'enemy-5',
        },
        --[[
            Level probabilites for enemies
            The probabilties below define the level of an enemey that is spawned (higher = stronger).
            The calculation is done in the same way as above. In this case the enemy will be level 3 with a 
            probability of 0.1 - 0.0 = 0.1
        ]]
        ['enemy-level-probs'] = {
            [1] = 1,
            [0.3] = 2,
            [0.1] = 3,
            [0.0] = 4
        },
        --[[
            The enemy spawn interval contains a range for which a random integer is sampled, 
            i.e. in this case it is a random value between 3 and 7 seconds.
        ]]
        ['enemy-spawn-interval'] = {3, 7},
        --[[
            The meteor spawn interval works in the same way as the enemy spawn interval.
        ]]
        ['meteor-spawn-interval'] = {1, 5}
    },
    {
        ['enemy-spawn-probs'] = {
            [1] = 'enemy-1',
            [0.7] = 'enemy-2',
            [0.5] = 'enemy-3',
            [0.3] = 'enemy-4',
            [0.1] = 'enemy-5',
        },
        ['enemy-level-probs'] = {
            [1] = 1,
            [0.5] = 2,
            [0.2] = 3,
            [0.1] = 4
        },
        ['enemy-spawn-interval'] = {2, 6},
        ['meteor-spawn-interval'] = {1, 4}
    },
    {
        ['enemy-spawn-probs'] = {
            [1] = 'enemy-1',
            [0.9] = 'enemy-2',
            [0.8] = 'enemy-3',
            [0.6] = 'enemy-4',
            [0.3] = 'enemy-5',
        },
        ['enemy-level-probs'] = {
            [1] = 1,
            [0.8] = 2,
            [0.5] = 3,
            [0.3] = 4
        },
        ['enemy-spawn-interval'] = {1, 3},
        ['meteor-spawn-interval'] = {1, 3}
    }
}