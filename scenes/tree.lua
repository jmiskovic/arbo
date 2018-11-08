local lume =require('lume')
require('nodes')

local branch = {
  tint, {0.75, .30, 0.09},
  {
    clip,
    {position, {0,   0, .52}, {edge}},
    {position, {-.1, 0, .22}, {edge}},
    {position, {.1,  0, .77}, {edge}},
  }
}

local tree = {
  position,
  {.5, -.15, 0, 1},
  {
    memo, .03,
    {
      tint, {0.77, 0.94, 0.43, .07},
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
}

-- inject recursive reference
tree[3][3][3][3][3] = tree[3]
tree[3][3][3][4][3] = tree[3]
tree[3][3][3][5][3] = tree[3]

local pondShape = {
  position,
  {-.4, -.52, .52, 3.2, .54},
  {
    clip,
    {
      position,
      {-.73, 2.71, 0, 1.6},
      {simplex}
    },
    { wrap, {edge}},
  }
}

local moon =
    { --moon
      tint,
      {0.39, 0.33, 0.81, 1.00},
      {position, {-.63, .55, 0.03, .3},
        {
          clip,
          {
            position,
            {0,0,0,1},
            { wrap, {edge}},
          },
          {
            position,
            {.5,0,0,.9},
            {negate, {wrap, {edge}}},
          }
        }
      }
    }

local scene =
{
  position,
  {.4, -.3, 0.01, 1.1},
  {
    combine,
    tree,
    { -- reflection
      clip,
      pondShape,
      {
        memo, .04,
        {position, {0, -.0, 0, 1, -.9},
          {combine,
            tree,
            moon
          }
        }
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

    moon,


    {tint, {0.65, .4, 0.4, 1},
      {position, {0, 0.05}, {edge}},
    },

    { --sky
      tint,
      {0.59, 0.51, 0.19, 1.00},
      {position, {0, -100, .5}, {edge}}
    },

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
