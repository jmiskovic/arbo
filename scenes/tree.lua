local lume =require('lume')
require('nodes')

local branch = {
  tint, {0.02, 0.34, 0.051, 1},
  {
    clip,
    {position, {0,   0, .52}, {edge}},
    {position, {-.1, 0, .22}, {edge}},
    {position, {.1,  0, .77}, {edge}},
  }
}

local tree = {
  memo, .02,
  {
    tint, {0.10, 0.95, 0.58, .07},
    {
      combine,
      branch,
      {
        position,
        {0, .35, .1, .7},
        branch
      },
      {
        position,
        {-.05, .45, -.1, .6},
        branch
      },
      {
        position,
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
  position,
  {-.4, -.52, .5, 3.2, .54},
  {
    clip,
    {
      position,
      {6, -2.83, 0, 2.25},
      {simplex}
    },
    { wrap, {edge}},
  }
}


local scene = {
  position,
  {.4, -.3, 0.01, 1.1},
  {
    combine,
    { -- tree
      position,
      {.5, -.15, 0, 1},
      tree,
    },

    { -- reflection
      tint,
      {.44, .26, .42, 1},
      {
        clip,
        {
          position, {.5, -.15, 0, 1, -.85},
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
      {position, {0, .03},
        pondShape
      }
    },

    { -- grass
      tint,
      {0.10, 0.95, 0.58, 1.00},
      {
        clip,
        {
          position, {1.8, 0, -.02, 3.2, .28},
          {simplex, 0, 50}
        },
        {edge}
      }
    },
    {tint, {.95, .58, .43, 1}, {edge}},

    {tint, {0.55, .28, 0.63, 1},
      {position, {0, 0.05}, {edge}},
    },
    {tint, {0.53, .81, .37, 1.00}, {combine, {position, {0, 0, .5}, {edge}}, {edge}}},
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
        position,
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
