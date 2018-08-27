local lume = require('lume')
--[[ commands
{is= 'lhp'}
{is= 'linear',
{is= 'negate',
{is= 'union',
{is= 'intersect',
{is= 'wrap',
{is= 'tint',
--]]

--[[ rotating rays
local ray =
  {is= 'linear',
    {is= 'intersect',
      {is= 'linear',
        {is= 'lhp'},
        0, -.5, math.pi, .01, .01
      },
      {is= 'linear',
        {is= 'lhp'},
        0,  .5, 0, .01, .01
      },
    },
    0, 0, 0, .2, .2
  }

local rays = {is= 'join'}

local count = 6
for i=1,count do
  table.insert(rays,
    {is= 'tint',
      {is= 'linear',
        ray,
        0, 0, math.pi / count * i
      },
      lume.hsl(i/count, .75, .6),
    }
  )
end

return
{is= 'linear',
  {is= 'join',
    {is= 'tint',
      {is= 'wrap',
        {is= 'linear',
          {is= 'lhp'},
          0, -.95, 0, .01, .01
        }
      },
      lume.hsl(0,0,0),
    },
    rays,
  },
  0, 0, 0,
  update= function(scene, dt, t)
    scene[4] = t / 10
  end
}
--]]

---[[ pulsating circle
local pulsating_circle =
  {is= 'wrap',
    {is= 'linear',
      {is= 'lhp'},
      0, -.8, 0, .01, .01,
    },
  }

return {is= 'join',
  {is= 'linear',
    {is= 'interact',
      {is= 'tint',
        {is= 'intersect',
          {is= 'linear', -- top
            {is= 'lhp'},
            0, 1, 0
          },
          {is= 'linear', -- left
            {is= 'lhp'},
            -1, 0, math.pi/2
          },
          {is= 'linear', -- bottom
            {is= 'lhp'},
            0, -1, math.pi
          },
          {is= 'linear', -- right
            {is= 'lhp'},
            1, 0, -math.pi/2
          },
        },
        lume.hsl(0, .7, .5),
      },
    },
    0, -.6, 0, .1, .1
  },

  {is= 'tint',
    {is= 'negate',
      pulsating_circle
    },
    lume.hsl(.55, .7, .5),
  },

  {is= 'linear',
    {is= 'tint',
      {is= 'wrap',
        {is= 'lhp'},
      },
      lume.hsl(.15, .7, .5),
    },
    0, 0, 0, .3, .3
  },

  update = function(scene, dt, t)
    local node = pulsating_circle[1]
    node[3] = -.5 + .3 * math.sin(t/3)
  end
}
--]]
