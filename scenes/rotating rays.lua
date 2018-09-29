local lume = require('lume')
require('nodes')

local count = 20

local ray =
  {linear,
    {0, 0, 0, .2, .2},
    {intersect,
      {linear,
        {0, 0, .5 - 1/count/2},
        {lhp},
      },
      {linear,
        {0, 0, 0 + 1/count/2},
        {lhp},
      },
      {negate,
        {wrap,
          {lhp},
        },
      },
    },
  }

local rays = {join}

for i=1,count do
  table.insert(rays,
    {tint,
      {i/count, .75, .6},
      {linear,
        {0, 0, 1 / count * i},
        ray,
      },
    }
  )
end

local scene =
{linear,
  {0, 0, 0,},
  rays,
  update= function(scene, dt, t)
    scene[2][3] = -t / 200
  end
}

return scene