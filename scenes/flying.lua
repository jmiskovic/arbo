local lume = require('lume')
require('nodes')

local palette = require('scenes/edg32')

local earthZoom = 35

local C = {
  sky_blue = {0.55, 1.00, 0.43},
}

local cloudShape = {position, {0, .303,  0, .124, .025},  {simplex, -.2}}

local scene =
{
  position,
  {0, 0, .05, .68},
  {
    position,
    {0, -earthZoom, 0.04, earthZoom},
    {
      wrap,
      {
        combine,
        --clouds
        {tint, {0.60, 0.21, 0.63}, {
          clip,
          cloudShape,
          {position, {0.01, -.006},  cloudShape},
          {position, {0, -.2, .5}, {edge}},
          {position, {0, .06, 0}, {edge}}
        }},
        {tint, {0.00, 0.00, 1.00}, {clip, cloudShape, {position, {0, -.15, .5}, {edge}}, {position, {0, .06, 0}, {edge}},}},

        --ground
        {tint, {0.30, 0.52, 0.54}, {clip, {position, {0,  0.00, 0, .05, .03}, {simplex, .15}}, {edge}}},
        --{tint, {0.36, 0.38, 0.39}, {clip, {position, {0, -0.03, 0, .05, .03}, {simplex, .2}}, {edge}}},
        {tint, {0.58, 0.77, 0.30}, {position, {0,0,0}, {edge}}},
        -- sky
        {tint, C.sky_blue, {position, {0,-5,.5}, {edge}}},
      },
    },
    --{tint, {0.36, 0.38, 0.39}, {position, {0,0,29/count}, splat}},
  },
  --tick = function(scene, dt, t)
  --  earthZoom = lume.remap(love.mouse.getX(), 0, love.graphics.getWidth(), .4, 50)
  --  scene[3][2][2][2] = -earthZoom
  --  scene[3][2][2][4] = earthZoom
  --end
}

return scene
