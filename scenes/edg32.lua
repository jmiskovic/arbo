local lume = require('lume')
require('nodes')

local count = 32

local splat =
  {intersect,
    {linear,
      {0, 0, .5 - 1/count/2},
      {lhp},
    },
    {linear,
      {0, 0, 0 + 1/count/2},
      {lhp},
    },
  }

local scene =
{join,
  {tint, {0.58, 0.77, 0.30}, {linear, {0,0,32/count}, splat}}, -- sea blue
  {tint, {0.51, 0.43, 0.17}, {linear, {0,0,31/count}, splat}}, -- shade tree green
  {tint, {0.42, 0.42, 0.25}, {linear, {0,0,30/count}, splat}}, -- moss
  {tint, {0.36, 0.38, 0.39}, {linear, {0,0,29/count}, splat}}, -- flora
  {tint, {0.30, 0.52, 0.54}, {linear, {0,0,28/count}, splat}}, -- light green
  {tint, {0.14, 0.99, 0.69}, {linear, {0,0,27/count}, splat}}, -- sun yellow
  {tint, {0.10, 0.99, 0.60}, {linear, {0,0,26/count}, splat}}, -- orange glow
  {tint, {0.07, 0.93, 0.55}, {linear, {0,0,25/count}, splat}}, -- amber
  {tint, {0.99, 0.76, 0.56}, {linear, {0,0,24/count}, splat}}, -- red
  {tint, {0.98, 0.62, 0.39}, {linear, {0,0,23/count}, splat}}, -- sunset
  {tint, {0.93, 0.23, 0.20}, {linear, {0,0,22/count}, splat}}, -- dark brown
  {tint, {0.01, 0.34, 0.34}, {linear, {0,0,21/count}, splat}}, -- pine bark
  {tint, {0.05, 0.42, 0.52}, {linear, {0,0,20/count}, splat}},
  {tint, {0.08, 0.68, 0.67}, {linear, {0,0,19/count}, splat}}, -- light desaturated brown
  {tint, {0.11, 0.60, 0.79}, {linear, {0,0,18/count}, splat}}, -- light brown
  {tint, {0.06, 0.65, 0.55}, {linear, {0,0,17/count}, splat}}, -- brown
  {tint, {0.03, 0.60, 0.46}, {linear, {0,0,16/count}, splat}}, -- saturated brown
  {tint, {0.05, 0.42, 0.59}, {linear, {0,0,15/count}, splat}}, -- skin shade
  {tint, {0.07, 0.64, 0.75}, {linear, {0,0,14/count}, splat}}, -- skin
  {tint, {0.99, 0.88, 0.71}, {linear, {0,0,13/count}, splat}}, -- peach
  {tint, {0.91, 0.41, 0.51}, {linear, {0,0,12/count}, splat}},
  {tint, {0.82, 0.32, 0.32}, {linear, {0,0,11/count}, splat}}, -- purple
  {tint, {0.96, 1.00, 0.50}, {linear, {0,0,10/count}, splat}}, -- magenta
  {tint, {0.71, 0.30, 0.11}, {linear, {0,0,9/count}, splat}}, -- dark navy
  {tint, {0.64, 0.28, 0.21}, {linear, {0,0,8/count}, splat}},
  {tint, {0.63, 0.28, 0.31}, {linear, {0,0,7/count}, splat}},
  {tint, {0.61, 0.20, 0.44}, {linear, {0,0,6/count}, splat}},
  {tint, {0.60, 0.21, 0.63}, {linear, {0,0,5/count}, splat}},
  {tint, {0.60, 0.29, 0.81}, {linear, {0,0,4/count}, splat}},
  {tint, {0.00, 0.00, 1.00}, {linear, {0,0,3/count}, splat}}, -- pure white
  {tint, {0.51, 0.91, 0.57}, {linear, {0,0,2/count}, splat}}, -- aqua
  {tint, {0.55, 1.00, 0.43}, {linear, {0,0,1/count}, splat}}, -- sky blue
}
return scene