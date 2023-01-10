Config = Config or {}

Config.GiveItemProbability = 100 -- 100% 75% 50% 25% 0% this is change to giving item

Config.Items = {'stone', 'stone', 'stone', 'stone', 'stone', 'coal', 'coal','coal','coal','silver', 'silver', 'silver', 'copper', 'copper', 'diamond', 'emerald'}

Config.Prices = {
    stone = 5,
    coal = 10,
    silver = 20,
    copper = 40,
    diamond = 80,
    emerald = 160
}

Config.DrawMarkers = {
    Distance = 10.0,
    Type = 2,
    Size = {x = 1.0, y = 1.0, z = 0.5},
    Color = {r = 109, g = 30, b = 166},
}

Config.CoolDoownForEachRock = 30 -- Cooldown so you can't mine the same stone, you need to wait this seconds

Config.RockBlips = {
    sprite = 12,
    scale = 1.2,
    colour = 64,
}

Config.RockSkillCheck = {
    difficulty = 'easy', -- easy, medium, hard
    repeatTimes = math.random(5, 10), -- How many times the skill check repeats until finish
}

Config.MiningZones = {
    DavisQuartz = {
        ped = {
            model = 'a_m_m_bevhills_01',
            coords = vec4(2956.95, 2744.58, 43.56, 286.29),
            spriteBlip = 486,
            scaleBlip = 1.2,
            colourBlip = 0,
        },

        rocksPositions = {
            vec3(2951.82, 2769.76, 39.03),
            vec3(2969.16, 2777, 38.43),
            vec3(2973.73, 2775.26, 38.20)
        }
    }
}

Config.SellZones = {
    [1] = {
        ped = {
            model = 'a_m_m_farmer_01',
            coords = vec4(1109.35, -2007.79, 31.03, 56.69),
            spriteBlip = 605,
            scaleBlip = 1.2,
            colourBlip = 66,
        },
    }
}