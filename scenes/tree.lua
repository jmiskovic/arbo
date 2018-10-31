local lume =require('lume')
require('nodes')

local branch = {
  tint, {0.02, 0.34, 0.051, 1},
  {
    intersect,
    {linear, {0,   0, .52}, {lhp}},
    {linear, {-.1, 0, .22}, {lhp}},
    {linear, {.1,  0, .77}, {lhp}},
  }
}

local tree = {
  memo, .02,
  {
    tint, {0.10, 0.95, 0.58, .07},
    {
      join,
      branch,
      {
        linear,
        {0, .35, .1, .7},
        branch
      },
      {
        linear,
        {-.05, .45, -.1, .6},
        branch
      },
      {
        linear,
        {.01, .55, .1, .4},
        branch
      },
    },
  }
}

-- inject recursive reference
tree[3][3][3][3] = tree
tree[3][3][4][3] = tree
tree[3][3][5][3] = tree

local pondShape = {
  linear,
  {-.4, -.52, .5, 3.2, .54},
  {
    intersect,
    {
      linear,
      {6, -2.83, 0, 2.25},
      {simplex}
    },
    { wrap, {lhp}},
  }
}


local scene = {
  linear,
  {.4, -.3, 0.01, 1.1},
  {
    join,
    { -- tree
      linear,
      {.5, -.15, 0, 1},
      tree,
    },

    { -- reflection
      tint,
      {.44, .26, .42, 1},
      {
        intersect,
        {
          linear, {.5, -.15, 0, 1, -.85},
          tree
        },
        pondShape,
      },
    },

    { -- pond
      tint,
      {.28, .31, .7, 1},
      pondShape
    },
    {
      tint,
      {.44, .26, .42, 1},
      {linear, {0, .03},
        pondShape
      }
    },

    { -- grass
      tint,
      {0.10, 0.95, 0.58, 1.00},
      {
        intersect,
        {
          linear, {1.8, 0, -.02, 3.2, .28},
          {simplex, 0, 50}
        },
        {lhp}
      }
    },
    {tint, {.95, .58, .43, 1}, {lhp}},

    {tint, {0.55, .28, 0.63, 1},
      {linear, {0, 0.05}, {lhp}},
    },
    {tint, {0.53, .81, .37, 1.00}, {join, {linear, {0, 0, .5}, {lhp}}, {lhp}}},
  }
}

--[[
local count = 30
math.randomseed(love.timer.getTime())
for i= 1, 0, -1 / count do
  table.insert(scene[3], 2,
    {
      tint, {nil, .01, nil, i},
      {
        linear,
        {
          lume.remap(math.random(), 0, 1, -2, 2),
          -1 + i * .5,
          lume.remap(math.random(), 0, 1, -.03, .03),
          lume.remap(math.random(), 1, 0, .5, 1),
          --.4 + .6 * (1 - i),
        },
        tree,
      }
    }
  )
end
--]]

return scene
