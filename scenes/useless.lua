local lume = require('lume')
require('nodes')

local leverShape =
{join,
  {intersect,
    {linear,
      {0, -.1, .5 - .016, .01, .01},
      {lhp},
    },
    {linear,
      {0,  .1, .016, .01, .01},
      {lhp},
    },
    {wrap,
      {lhp}
    },
    {linear,
      {0, 0, .25},
      {lhp},
    }
  },
  {linear,
    {1, 0, 0, .2, .2},
    {wrap,
      {lhp}
    },
  }
}

local lever =
{linear,
  {0, -.35, .25 - .5/6,
      react = {
      {
        case= {active= 1},
        name= 'off',
        {set, 'active', 0},
        {set, 3, .25 - .5/6,}
      },
      {
        case= {active= 0},
        name= 'on',
        {set, 'active', 1},
        {set, 3, .25 + .5/6,}
      },
    },
    active= 0,
  },
  {join,
    {tint, -- highlight
      {0.77, 0.70, 0.57},
      {intersect,
        leverShape,
        {linear,
          {-0.0, -.08, 0, .9, .9},
          leverShape,
        }
      },
    },
    {tint,
      {0.77, 0.94, 0.43},
      leverShape,
    },
  },
}

return
{join,
  {tint, -- the floor
    {0.72, 0.70, 0.37},
    {linear,
      {0, -.3},
      {lhp},
    },
  },
  lever,       -- the lever
  {tint, -- background
    {0.75, 1.00, 0.09},
    {linear,
      {0, -10, .5},
      {lhp},
    },
  },

  update = function(scene, dt, t)
    --scene[3][2][3] = .25 - .5/6 * math.atan(20 * math.sin(t))
    --print(scene[2].active)
  end
}
