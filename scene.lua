local lume = require('lume')
--[[ commands
{is= 'lhp'}
{is= 'transform',
  {is= 'linear', 0, 0}
{is= 'negate',
{is= 'union',
{is= 'intersect',
{is= 'wrap',
{is= 'tint',
--]]

--[[ rotating rays
local ray =
  {is= 'transform',
    {is= 'intersect',
      {is= 'transform',
        {is= 'lhp'},
        {is= 'linear', 0, -.5, math.pi, .01, .01}
      },
      {is= 'transform',
        {is= 'lhp'},
        {is= 'linear', 0,  .5, 0, .01, .01}
      },
    },
    {is= 'linear', 0, 0, 0, .2, .2}
  }

local rays = {is= 'union'}

local count = 6
for i=1,count do
  table.insert(rays,
    {is= 'transform',
      ray,
      {is= 'linear', 0, 0, math.pi / count * i}
    }
  )
end

return
{is= 'transform',
  {is= 'intersect',
    rays,
    {is= 'negate',
      {is= 'wrap',
        {is= 'transform',
          {is= 'lhp'},
          {is= 'linear', 0, -.85, 0, .01, .01}
        }
      }
    }
  },
  {is= 'linear', 0, 0, 0},
  update= function(scene, dt, t)
    scene[2][3] = t / 10
  end
}
--]]

---[[ pulsating circle
local pulsating_circle =
  {is= 'wrap',
    {is= 'transform',
      {is= 'lhp'},
      {is= 'linear', 0, -.8, 0, .01, .01},
    },
  }

return {is= 'join',
  {is= 'tint',
    {is= 'negate',
      pulsating_circle
    },
    lume.hsl(.55, .7, .5),
  },

  {is= 'tint',
    {is= 'wrap',
      {is= 'transform',
        {is= 'lhp'},
        {is= 'linear', 0, -.95, 0, .01, .01},
      },
    },
    lume.hsl(.15, .7, .5),
  },

  update = function(scene, dt, t)
    local node = pulsating_circle[1][2]
    node[2] = -.5 + .3 * math.sin(t)
  end
}
--]]
