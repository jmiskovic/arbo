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
          {-.05, .45, -.1, .7},
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
  {-1.542, 3.146, -0.014, 5.07, .71},
  {simplex}
}

local moon =
    { --moon
      tint,
      {0.13, 0.48, 0.86, 1.00},
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
    {.57, .62, .12, 1},
    {
      clip,
      pondShape,
      {edge}
    }
  },
  {
    tint,
    {.96, .26, .55, 1},
    {
      clip,
      {position, {0, .03},pondShape},
      {edge}
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

  -- horizon
  { tint, {0.65, .4, 0.24, 1}, {position, {0, 0.05}, {edge}}},
  moon,
  { --sky
    tint,
    {0.64, 0.43, 0.17, 1.00},
    {position, {0, -5, .5}, {edge}}
  },

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
