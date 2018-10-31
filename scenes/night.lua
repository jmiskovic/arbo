require('nodes')
--require('palette-edg16')

local verticals =
{
  tint,
  {0.64, 0.13, 0.23},
  {
    intersect,
    {
      linear,
      {0, 0, 0, .2, 500},
      {simplex, .2, 5}
    },
    {
      linear,
      {0, -.4, .005},
      {lhp}
    }
  }
}

local windows =
{
  tint,
  {0.11, 0.69, 0.57},
  {
    intersect,
    -- light stipes
    {
      linear,
      {0, 0, 0, 5000, .05},
      {
        simplex, -.1, 15
      }
    },
    verticals,
    {
      linear,
      {0, 0, 0, .05, 5000},
      {simplex, -.1, 2}
    }
  }
}

local smog =
{
  tint,
  {0.11, 0.1, 0.6},
  {
    intersect,
    {
      linear,
      {0, 0, 0, 5, .4},
      {
        simplex
      }
    },
    {lhp, -2.3, .02}
  }
}

local skyscrapers =
{
  join,
  --smog,
  windows,
  verticals,
  {
    tint,
    {nil, nil, 1, .1},
    {linear, {.01, 0.02}, verticals}
  }
}

return
{
  linear, {0, 0, 0, 1},
  {
    join,
    -- palette
    --{linear, {.6, .8, 0, .6}, {intersect, {wrap, {lhp}}, require('edg32')}},
    -- city
    {
      linear,
      {0, 0, -.002},
      skyscrapers,
    },
    {
      tint,
      {nil, 0, 0, .3},
      {
        linear,
        {1, .15, 0.003, .6, .8},
        skyscrapers,
      }
    },
    {
      tint,
      {nil, 0, 0, .6},
      {
        linear,
        {2, .2, -0.003, .5, .7},
        skyscrapers
      }
    },
    {
      tint,
      {nil, 0, 0, .8},
      {
        linear,
        {3, .5, -0.01, .3, .8},
        skyscrapers
      }
    },
    -- ground
    --{
    --  tint,
    --  {0.39, 0.33, 0.32},
    --  {lhp}
    --},
    -- stars
    {tint, {1, 1, 1}, {linear, {0, 0, 0, .01}, {simplex, -.9, 5}}},
    -- space
    {tint, {0.70, 0.30, 0.11}, {join, {negate, {lhp}}, {lhp}}},
  },
  --update = function(scene, dt, t)
  --  --scene[3][2][3][2][2] = -1.2 + .5 * math.sin(30 * t)
  --  scene[3][2][3][2][3][2][2][1] = t / 50
  --end

}
