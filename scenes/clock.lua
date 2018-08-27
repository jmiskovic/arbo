local lume = require('lume')

local dial =
{is= 'linear',
  {is= 'intersect',
    {is= 'linear',
      {is= 'lhp'},
      0, -.05, math.pi + .05, .01, .01
    },
    {is= 'linear',
      {is= 'lhp'},
      0,  .05, -.05, .01, .01
    },
    {is= 'linear',
      {is= 'lhp'},
      -.3,  0, math.pi/2, .01, .01
    },
  },
  0, 0
}

local seconds =
{ is= 'tint',
  { is= 'linear',
    dial,
    0, 0, .4, 1, 1
  },
  lume.hsl(.55, .2, .1)
}

local minutes =
{ is= 'tint',
  { is= 'linear',
    dial,
    0, 0, .2, .8, .8,
  },
  lume.hsl(.55, .2, .2)
}

local hours =
{ is= 'tint',
  { is= 'linear',
    dial,
    0, 0, .5, .6, .6
  },
  lume.hsl(.55, .2, .3)
}

local face =
{ is= 'join',
  { is= 'tint',
    { is= 'wrap',
      { is= 'lhp'}
    },
    lume.hsl(.15, .2, .8)
  }
}

local mark =
{ is= 'tint',
  { is= 'intersect',
    { is= 'linear', { is = 'lhp'}, .9,  .04, 0 },
    { is= 'linear', { is = 'lhp'}, .9, -.04, math.pi },
    { is= 'linear', { is = 'lhp'}, .9 - .06, 0,  math.pi/2 },
    { is= 'linear', { is = 'lhp'}, .9 + .06, 0, -math.pi/2 },
  },
  lume.hsl(.55, .3, .4)
}

for hour=1,12 do
  table.insert(face, 1,
    { is= 'linear',
      mark,
      0, 0, 2 * math.pi * hour / 12
    })
end

local cap =
{ is= 'tint',
  { is= 'linear',
    { is= 'wrap',
      { is= 'lhp'}
    },
    0, 0, 0, .1, .1
  },
  lume.hsl(0, 0, .1)
}

local clock =
{ is= 'join',
  cap,
  seconds,
  minutes,
  hours,
  face,
  update = function (scene, dt, t)
    local time = os.date('*t')
    scene[2][1][4] = math.pi/2 -time.sec  / 60 * 2 * math.pi
    scene[3][1][4] = math.pi/2 -time.min  / 60 * 2 * math.pi
    scene[4][1][4] = math.pi/2 -time.hour / 24 * 2 * math.pi
    --print(Now.hour)
    --print(Now.min)
    --print(Now.sec)
  end,
}

return clock