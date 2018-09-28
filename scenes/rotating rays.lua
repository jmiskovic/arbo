local lume = require('lume')
require('nodes')

local ray =
  {linear,
    {0, 0, 0, .2, .2},
    {intersect,
      {linear,
        {0, -.7, .5, .01, .01},
        {lhp},
      },
      {linear,
        {0,  .7, 0, .01, .01},
        {lhp},
      },
    },
  }

local rays = {join}

local count = 6
for i=1,count do
  table.insert(rays,
    {tint,
      {i/count, .75, .6},
      {linear,
        {0, 0, .5 / count * i},
        ray,
      },
    }
  )
end

return
{linear,
  {0, 0, 0,},
  {join,
    {tint,
      {0,0,0},
      {wrap,
        {linear,
          {0, -.92, 0, .01, .01},
          {lhp},
        }
      },
    },
    rays,
  },
  update= function(scene, dt, t)
    scene[2][3] = t / 100
  end
}
