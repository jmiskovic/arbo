local lume = require('lume')

local ray =
  {is= 'linear',
    {is= 'intersect',
      {is= 'linear',
        {is= 'lhp'},
        0, -.7, math.pi, .01, .01
      },
      {is= 'linear',
        {is= 'lhp'},
        0,  .7, 0, .01, .01
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
          0, -.92, 0, .01, .01
        }
      },
      lume.hsl(0,0,0),
    },
    rays,
  },
  0, 0, 0,
  update= function(scene, dt, t)
    scene[4] = t / 4
  end
}
