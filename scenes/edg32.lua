local lume = require('lume')
require('nodes')

local count = 32

local splat =
  {
    "mirror",
    {
      position,
      {0, 0, .74 - .5 / count },
      {edge}
    }
  }

T = {0,0,0,1}

local palette =
{
  combine,
  {tint, {0.58, 0.77, 0.30}, {position, {0,0,0/count}, splat}}, -- sea blue
  {tint, {0.51, 0.43, 0.17}, {position, {0,0,1/count}, splat}}, -- shade tree green
  {tint, {0.42, 0.42, 0.25}, {position, {0,0,2/count}, splat}}, -- moss
  {tint, {0.36, 0.38, 0.39}, {position, {0,0,3/count}, splat}}, -- flora
  {tint, {0.30, 0.52, 0.54}, {position, {0,0,4/count}, splat}}, -- light green
  {tint, {0.14, 0.99, 0.69}, {position, {0,0,5/count}, splat}}, -- sun yellow
  {tint, {0.10, 0.99, 0.60}, {position, {0,0,6/count}, splat}}, -- orange glow
  {tint, {0.07, 0.93, 0.55}, {position, {0,0,7/count}, splat}}, -- amber
  {tint, {0.99, 0.76, 0.56}, {position, {0,0,8/count}, splat}}, -- red
  {tint, {0.98, 0.62, 0.39}, {position, {0,0,9/count}, splat}}, -- sunset
  {tint, {0.93, 0.23, 0.20}, {position, {0,0,10/count}, splat}}, -- dark brown
  {tint, {0.01, 0.34, 0.34}, {position, {0,0,11/count}, splat}}, -- pine bark
  {tint, {0.05, 0.42, 0.52}, {position, {0,0,12/count}, splat}},
  {tint, {0.08, 0.68, 0.67}, {position, {0,0,13/count}, splat}}, -- light desaturated brown
  {tint, {0.11, 0.60, 0.79}, {position, {0,0,14/count}, splat}}, -- light brown
  {tint, {0.06, 0.65, 0.55}, {position, {0,0,15/count}, splat}}, -- brown
  {tint, {0.03, 0.60, 0.46}, {position, {0,0,16/count}, splat}}, -- saturated brown
  {tint, {0.05, 0.42, 0.59}, {position, {0,0,17/count}, splat}}, -- skin shade
  {tint, {0.07, 0.64, 0.75}, {position, {0,0,18/count}, splat}}, -- skin
  {tint, {0.99, 0.88, 0.71}, {position, {0,0,19/count}, splat}}, -- peach
  {tint, {0.91, 0.41, 0.51}, {position, {0,0,20/count}, splat}},
  {tint, {0.82, 0.32, 0.32}, {position, {0,0,21/count}, splat}}, -- purple
  {tint, {0.96, 1.00, 0.50}, {position, {0,0,22/count}, splat}}, -- magenta
  {tint, {0.71, 0.30, 0.11}, {position, {0,0,23/count}, splat}},  -- dark navy
  {tint, {0.64, 0.28, 0.21}, {position, {0,0,24/count}, splat}},
  {tint, {0.63, 0.28, 0.31}, {position, {0,0,25/count}, splat}},
  {tint, {0.61, 0.20, 0.44}, {position, {0,0,26/count}, splat}},
  {tint, {0.60, 0.21, 0.63}, {position, {0,0,27/count}, splat}},
  {tint, {0.60, 0.29, 0.81}, {position, {0,0,28/count}, splat}},  -- light gray
  {tint, {0.00, 0.00, 1.00}, {position, {0,0,29/count}, splat}},  -- pure white
  {tint, {0.51, 0.91, 0.57}, {position, {0,0,30/count}, splat}},  -- aqua
  {tint, {0.55, 1.00, 0.43}, {position, {0,0,31/count}, splat}},  -- sky blue
}

local scene = {memo, .02, {position, {0, -1, 0, 1.5, 1.5}, {clip, {wrap, 1, {edge, -2}}, {wrap, .5, palette}}}}


return {position, {0, -1, 0, 1.5, 1.5}, {clip, {wrap, 1, {edge, -2}}, {wrap, .5, palette}}}