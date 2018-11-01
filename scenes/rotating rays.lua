local lume = require('lume')
require('nodes')

local count = 20

local ray =
  {position,
    {0, 0, 0, .2, .2},
    {clip,
      {position,
        {0, 0, .5 - 1/count/2},
        {edge},
      },
      {position,
        {0, 0, 0 + 1/count/2},
        {edge},
      },
      {negate,
        {wrap,
          {edge},
        },
      },
    },
  }

local rays = {combine}

for i=1,count do
  table.insert(rays,
    {tint,
      {i/count, .75, .6},
      {position,
        {0, 0, 1 / count * i},
        ray,
      },
    }
  )
end

local scene =
{position,
  {0, 0, 0,},
  rays,
  update= function(scene, dt, t)
    scene[2][3] = -t / 200
  end
}

return scene