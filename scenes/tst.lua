local lume = require('lume')
nodes = require('nodes')

local sides = 3

local regular_polygon =
{clip,
  {position, {0, 0, 0, .9}, {simplex}}
}

for i=1,sides do
  table.insert(regular_polygon,
    {position, {0, 0, i/sides}, {position, {0, 1}, {edge, .05}}}
  )
end

local scene = {combine,
  {position,
    {0,0,0,.5,.5},
    {
      combine,
      regular_polygon,
    },
  },
  {tint,
    {0.71, 0.30, 0.11},
    {combine,
      {edge, .05},
      {position,
        {0, 0, 0.5},
        {edge, .05},
      }
    },
  },
  update = function(scene, dt, t)
    --scene[2][2][3] = t / 50
  end
}

return {
  tint,
  {.15, .9, .5},
  {
    clip,
    {
      position,
      {0, 0, .1},
      {
        edge
      },
    },
    {simplex}
  }
}

