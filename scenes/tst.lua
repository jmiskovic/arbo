local lume = require('lume')
nodes = require('nodes')

local sides = 5

local regular_polygon =
{intersect}

for i=1,sides do
  table.insert(regular_polygon,
    {linear, {0, 0, i/sides}, {linear, {0, 1}, {lhp}}}
  )
end

return
{join,
  {linear,
    {0,0,0,.5,.5},
    regular_polygon,
  },
  {tint,
    {.8, .3, .4},
    {join,
      {lhp},
      {linear,
        {0, 0, 0.5},
        {lhp},
      }
    },
  },
  update = function(scene, dt, t)
    scene[2][2][3] = t / 50
  end
}
