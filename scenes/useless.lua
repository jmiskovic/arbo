local lume = require('lume')


local leverShape =
{is= 'join',
  {is= 'intersect',
    {is= 'linear',
      {is= 'lhp'},
      0, -.1, math.pi - .1, .01, .01
    },
    {is= 'linear',
      {is= 'lhp'},
      0,  .1, .1, .01, .01
    },
    {is= 'wrap',
      {is= 'lhp'}
    },
    {is= 'linear',
      {is= 'lhp'},
      0, 0, math.pi/2
    }
  },
  {is= 'linear',
    {is= 'wrap',
      {is= 'lhp'}
    },
    1, 0, 0, .2, .2
  }
}

local lever =
{is= 'linear',
  {is= 'join',
    {is= 'tint', -- highlight
      {is= 'intersect',
        leverShape,
        {is= 'linear',
          leverShape,
          -0.0, -.08, 0, .9, .9
        }
      },
      lume.hsl(0.77, 0.70, 0.57),
    },
    {is= 'tint',
      leverShape,
      lume.hsl(0.77, 0.94, 0.43)
    },
  },
  0, -.35, math.pi/2 - math.pi/6,
  active= 0,
  react = {
    {
      case= {active= 1},
      name= 'off',
      {is= 'set', 'active', 0},
      {is= 'set', 4, math.pi/2 - math.pi/6,}
    },
    {
      case= {active= 0},
      name= 'on',
      {is= 'set', 'active', 1},
      {is= 'set', 4, math.pi/2 + math.pi/6,}
    },
  }
}

return
{is= 'join',
  {is= 'tint', -- the floor
    {is= 'linear',
      {is= 'lhp'},
      0, -.3,
    },
    lume.hsl(0.72, 0.70, 0.37),
  },
  lever,       -- the lever
  {is= 'tint', -- background
    {is= 'linear',
      {is= 'lhp'},
      0, -10, math.pi
    },
    lume.hsl(0.75, 1.00, 0.09)
  },

  update = function(scene, dt, t)
    --scene[2][4] = math.pi/2 - math.pi/6 --* math.atan(20 * math.sin(t/10))
    --scene[2][2] = -.5 * math.cos(t)
    --print(scene[2].active)
  end
}
