local lume = require('lume')

sky =
{is= 'tint',
  {is= 'join',
    {is= 'join',
      {is= 'lhp'},
      {is= 'linear',
        {is= 'lhp'},
        0, 0, math.pi,
      }
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

cloudLayer =
{is= 'join',
{is= 'tint',
  {is= 'simplex'},
  lume.hsl(0.2, 0.38, 0.86),
},
{is= 'tint',
  {is= 'linear',
    {is= 'simplex'},
    0, -0.12, 0, 1, 1,
  },
  lume.hsl(0.1, 0.53, 0.65),
}
}

clouds =
{is= 'linear',
    cloudLayer,
  0, 0.2, 0, .7, .15,
}

mirror_sun =
{is= 'linear',
  sun,
  0, .05, 0, 1, -1,
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

  -- finding accelerometer
  local joysticks = love.joystick.getJoysticks()
  for i, joystick in ipairs(joysticks) do
    if joystick:getName() == 'Android Accelerometer' then
      readTilt = function()
          return joystick:getAxis(1), joystick:getAxis(2), joystick:getAxis(3)
        end
      break
    end
  end


return
{is= 'join',
  clouds,
  reflection,
  sea,
  sun,
  sky,
  update = function(scene, dt, t)
    local hour = lume.remap(love.mouse.getX(), 0, love.graphics.getWidth(), 15, 23)
    clouds[2] = t / 100 -- + readTilt()
    --16 + ((t/6 + 3.5) % 8)

    -- sun location
    sun[1][2] = lume.remap(hour, 16, 21, -.1, -.3)
    sun[1][3] = lume.remap(hour, 16, 20.5, .51, 0)
    -- sun shade
    sun[2], sun[3], sun[4] = lume.hsl(
      lume.remap(gaussian(hour, .3), 16, 21, .15, .05),
      .95,
      lume.remap(gaussian(hour, .3), 16, 21, .97, .4))
    -- reflection shade
    --reflection[2], reflection[3], reflection[4] = sea[2], sea[3], sea[4]
    reflection[2], reflection[3], reflection[4] = lume.hsl(
      lume.remap(gaussian(hour, .1), 16, 21, .15, .05),
      .95,
      lume.remap(hour, 16, 21, .97, .4))
    -- cloud shade
    clouds[1][1][2], clouds[1][1][3], clouds[1][1][4] = lume.hsl(
      lume.remap(hour, 16, 21, 0.2, 0.05),
      lume.remap(hour, 16, 21, .38, .7),
      lume.remap(hour, 16, 20, .96, .3))
    clouds[1][2][2], clouds[1][2][3], clouds[1][2][4] = lume.hsl(
      lume.remap(hour, 16, 21, 0.1, 0.02),
      lume.remap(hour, 16, 21, .53, .6),
      lume.remap(hour, 16, 20, .65, .4))
    -- sky shade
    sky[2], sky[3], sky[4] = lume.hsl(
      lume.remap(hour, 14, 21, .17, .07),
      lume.remap(hour, 14, 21, .3, .9),
      lume.remap(hour, 14, 23, .97, .02, 'clamp'))
    -- sea shade
    sea[2], sea[3], sea[4] = lume.hsl(
      lume.remap(hour, 16, 21, .6, .38, 'clamp'),
      lume.remap(hour, 16, 19, .6, .3),
      lume.remap(hour, 16, 22, .37, .08))
  end
}