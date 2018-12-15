require('nodes')

local verticals =
{
  tint,
  {0.64, 0.13, 0.23},
  {
    clip,
    {
      position,
      {0, 0, 0, .2, 500},
      {simplex, .2, 5}
    },
    {
      position,
      {0, -.4, 0},
      {edge, 0, 555}
    }
  }
}

local windows =
{
  tint,
  {0.11, 0.69, 0.57},
  {
    clip,
    -- light stipes
    {
      position,
      {0, 0, 0, 5000, .05},
      {
        simplex, -.1, 15
      }
    },
    {
      position,
      {0, 0, 0, .05, 5000},
      {simplex, -.1, 2}
    },
    verticals,
  }
}

local smog =
{
  tint,
  {0.11, 0.1, 0.6},
  {
    clip,
    {
      position,
      {0, 0, 0, 5, .4},
      {
        simplex
      }
    },
    {edge, .6}
  }
}

local skyscrapers =
{
  combine,
  windows,
  verticals,
  {
    tint,
    {nil, nil, 1, .1},
    {position, {.01, 0.02}, verticals}
  }
}

local city =
{
  combine,
  -- palette
  --{position, {.6, .8, 0, .6}, {clip, {wrap, {edge}}, require('edg32')}},
  -- city
  {
    position,
    {0, 0, -.002},
    skyscrapers,
  },
  {
    tint,
    {nil, 0, 0, .3},
    {
      position,
      {1, .15, 0.003, .6, .8},
      skyscrapers,
    }
  },
  {
    tint,
    {nil, 0, 0, .6},
    {
      position,
      {2, .2, -0.003, .5, .7},
      skyscrapers
    }
  },
  {
    tint,
    {nil, 0, 0, .8},
    {
      position,
      {3, .6, -0.0, .3, .8},
      skyscrapers
    }
  },
  -- ground
  --{
  --  tint,
  --  {0.39, 0.33, 0.32},
  --  {edge}
  --},
  -- stars
  {tint, {1, 1, 1}, {position, {0, 0, 0, .01}, {simplex, -.95, 50}}},
  -- space
  {tint, {0.70, 0.30, 0.11}, {combine, {negate, {edge}}, {edge}}},

}

local scene = city

return scene