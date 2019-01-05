local lume = require('lume')
require('nodes')

local leverShape =
{combine,
  {clip,
    {position,
      {0, -.1, .5 - .016, .01, .01},
      {edge},
    },
    {position,
      {0,  .1, .016, .01, .01},
      {edge},
    },
    {wrap, 1,
      {edge}
    },
    {position,
      {0, 0, .25},
      {edge},
    }
  },
  {position,
    {1, 0, 0, .2, .2},
    {wrap, 1,
      {edge}
    },
  }
}

local lever =
{
  interact,
  {onoff = .25 - .5/6},
  {position,
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
    {combine,
      {tint, -- highlight
        {0.77, 0.70, 0.57},
        {clip,
          leverShape,
          {position,
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
}

return
{combine,
  {tint, -- the floor
    {0.72, 0.70, 0.37},
    {position,
      {0, -.3},
      {edge},
    },
  },
  lever,       -- the lever
  {tint, -- background
    {0.75, 1.00, 0.09},
    {position,
      {0, -10, .5},
      {edge},
    },
  },
}
