local lume = require('lume')

sky =
{is= 'tint',
  {is= 'join',
    {is= 'lhp'},
    {is= 'linear',
      {is= 'lhp'},
      0, 0, math.pi
    },
  },
  lume.hsl(0.14, 0.5, 0.8),
}

sun =
{is= 'tint',
  {is= 'linear',
    {is= 'wrap',
      {is= 'lhp'},
    },
    0, 0, 0, .2,
  },
  lume.hsl(0.15, 0.73, 0.97),
}

sea =
{is= 'tint',
  {is= 'lhp' },
  lume.hsl(0.58, 0.38, 0.16),
}

mirror_sun =
{is= 'linear',
  sun,
  0, 0, 0, 1, -1,
}

reflection =
{is= 'tint',
  {is= 'join',
    {is= 'intersect',
      {is= 'linear',
        mirror_sun,
        0, 0, 0, 1, 5,
      },
      sea,
    },
    {is= 'linear',
      mirror_sun,
      0, 50, 0, 1, .06,
    },
  },
  lume.hsl(.10, .78, .35),
}

function gaussian (mean, variance)
    return  math.sqrt(-2 * variance * math.log(math.random())) *
            math.cos(2 * math.pi * math.random()) + mean
end

return
{is= 'join',
  reflection,
  sea,
  sun,
  sky,
  update = function(scene, dt, t)
    local hour = love.mouse.getX() / love.graphics.getWidth() * 24
    --16 + ((t/6 + 3.5) % 8)

    -- sun location
    scene[3][1][2] = lume.remap(hour, 16, 21, -0.2, .1)
    scene[3][1][3] = lume.remap(hour, 16, 21, 1, 0)
    -- sun shade
    scene[3][2], scene[3][3], scene[3][4] = lume.hsl(
      lume.remap(hour, 16, 21, .15, .05),
      .95,
      lume.remap(hour - (math.random() > .6 and .2 or 0), 16, 21, .97, .4))
    -- reflection shade
    --scene[1][2], scene[1][3], scene[1][4] = scene[3][2], scene[3][3], scene[3][4]
    scene[1][2], scene[1][3], scene[1][4] = lume.hsl(
      lume.remap(hour, 16, 21, .15, .05),
      .95,
      lume.remap(hour - (math.random() > .6 and .2 or 0), 16, 21, .97, .4))
    -- sky shade
    scene[4][2], scene[4][3], scene[4][4] = lume.hsl(
      lume.remap(hour, 16, 21, .17, .07),
      lume.remap(hour, 16, 21, .3, .9),
      lume.remap(hour, 16, 23, .97, .0, 'clamp'))
    -- sea shade
    scene[2][2], scene[2][3], scene[2][4] = lume.hsl(
      lume.remap(hour, 16, 21, .6, .56, 'clamp'),
      lume.remap(hour, 16, 21, .6, .38),
      lume.remap(hour, 16, 23, .3, .06))
  end
}