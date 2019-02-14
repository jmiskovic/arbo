require('nodes')

local moon =
    { --moon
      tint,
      {0.39, 0.33, 0.81, 1.00},
      {position, {-.3, .7, -.12, .12},
        {
          clip,
          {
            position,
            {0,0,0,1},
            { wrap, 1,  {edge}},
          },
          {
            position,
            {2.,0,0,2.2},
            { wrap, 1, {edge}},
          }
        }
      }
    }

local shrubs =
    { --far-off shrubs
      tint,
      {0.57, 0.13, 0.11, 1.00},
      {
        clip,
        {
          combine,
          {position, {0, -.345, 0, .53, .5}, {simplex, 0, 1}},
        },
        {position, {0, .2, 0}, {edge, 0, 1}},
        {position, {0, 0, 0.5}, {edge, 0, 1}},
      }
    }

return {
  position,
  {0,0,0,1},
  {
    combine,

    --[[
    { --grass
      union,
      {
        tint,
        {0.46, 0.37, 0.21, 1.00},
        {
          clip,
          {position, {0, -.8, 0}, {edge}},
          {position, {0, 0, 0, .01, 100}, {simplex, 0, 100}},
        },
      },
    },
    --]]

    ---[[
    { --reflection
      tint,
      {0, 0, .0, .01},
      {
        clip,
        {position, {0, .15, 0}, {edge, 0, 1}},
        {memo, .05,
          {
            combine,
            {
              position, {0, 0, 0, 1, -3.5},
              {
                position, {0, -.5, 0, 1, 1},
                moon
              },
            },
            {
              position, {0, 0, 0, 1, -1},
              shrubs
            }
          }
        },
      }
    },
    --]]

    { --lake
      tint,
      {0.56, 0.64, 0.22, 1.00},
      {position, {0, 0, 0}, {edge}}
    },

    moon,

    shrubs,

    {--[[sky]]     tint, {0.59, 0.51, 0.19, 1.00}, {wrap, 1, {position, {0, -2, .5}, {edge}}}},
  }
}
