local lume = require('lume')
require('nodes')

local dial =
{position,
  {0, 0},
  {clip,
    {position,
      {0, -.05, .5 + .008, .01, .01},
      {edge},
    },
    {position,
      {0,  .05, -.008, .01, .01},
      {edge},
    },
    {position,
      {-.3,  0, .25, .01, .01},
      {edge},
    },
  },
}

local seconds =
{ tint,
  {.55, .2, .1},
  { position,
    {0, 0, .25, 1, 1},
    dial,
  },
}

local minutes =
{ tint,
  {.55, .2, .2},
  {position,
    {0, 0, .2, .8, .8},
    dial,
  },
}

local hours =
{ tint,
  {.55, .2, .3},
  {position,
    {0, 0, .5, .6, .6},
    dial,
  },
}

local face =
{ combine,
  {
    interact,
    {facehue=.15},
    { tint,
      {'facehue', .5, .8},
      { wrap, 1,
        { edge }
      },
    },
    {
      {
        case= {facehue = .15},
        name= 'enlarge',
        {set, 'facehue', .3}
      },
      {
        case= {facehue = .3},
        name= 'shrink',
        {set, 'facehue', .45}
      },
      {
        case= {facehue = .45},
        name= 'shrink',
        {set, 'facehue', .6}
      },
      {
        case= {facehue = .6},
        name= 'shrink',
        {set, 'facehue', .75}
      },
      {
        case= {facehue = .75},
        name= 'shrink',
        {set, 'facehue', .9}
      },
      {
        case= {facehue = .9},
        name= 'shrink',
        {set, 'facehue', .15}
      },

    }
  }
}

local mark =
{ tint,
  {.55, .3, .4},
  { clip,
    {position, {.9,  .04, 0}, {edge}},
    {position, {.9, -.04, .5}, {edge}},
    {position, {.9 - .06, 0,  .5/2}, {edge}},
    {position, {.9 + .06, 0, -.5/2}, {edge}},
  },
}

for hour=1,12 do
  table.insert(face, 2,
    { position,
      {0, 0, 2 * .5 * hour / 12},
      mark,
    })
end

local cap =
{ tint,
  {0, 0, .1},
  { position,
    {0, 0, 0, .1, .1},
    { wrap, 1,
      { edge}
    },
  },
}

local clock =
{
  combine,
  cap,
  seconds,
  minutes,
  hours,
  face,
  {tint, {.72,.23,.2}, {wrap, 1, {position, {0, -1, .5}, {edge}}}},
  tick = function (scene, t)
    local time = os.date('*t')
    scene[3][3][2][3] = .5/2 -time.sec  / 60 * 2 * .5
    scene[4][3][2][3] = .5/2 -time.min  / 60 * 2 * .5
    scene[5][3][2][3] = .5/2 -time.hour / 24 * 2 * .5
  end,
}

return clock