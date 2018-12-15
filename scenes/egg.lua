nodes = require('nodes')

local eggShape = {position, {0,0,0,.75,1}, {wrap, {edge}}}


local egg =
{
  clip,
  eggShape,
  {position, {0, -.9, .5}, {edge}},
  {
    combine,
    {tint, {0.86, 0.99, 0.36}, {position, {0,0,0,.75,1}, {simplex, -.2}}},
    {tint, {0.60, 0.97, 0.30}, {position, {0, -100, .5}, {edge}}},
  },
}

local eggShade = {
  tint, {nil, 0, 0, .5},
  {
    clip,
    {negate, {position, {-.2, 0.3, 0, 1.1}, eggShape}},
    egg,
  }
}

local grass = {tint, {0.36, 0.38, 0.39}, {position, {0, -.4}, {edge}}}

local flowers =
{
  clip,
  grass,
  {
    combine,
    {--[[flowers]] tint, {0.96, 1.00, 0.50}, {position, {0, 0.03, .03, .5, .2}, {simplex, -.88}}},
    {--[[flowers]] tint, {0.14, 0.99, 0.69}, {position, {0, 0.03, .03, .5, .2}, {simplex, -.8}}},
    {--[[flowers]] tint, {0.42, 0.42, 0.25}, {position, {0, 0, .03, .5, .2}, {simplex, -.85}}},
  }
}

local squashTrails = {5.18, -3.42, 0.04, 7.03, 3.01}

local trails =
{tint, {0.08, 0.68, 0.67},
  {
    clip,
    grass,
    {position, squashTrails, {simplex}},
    {position, squashTrails, {negate, {simplex, -.2}}}
  }
}

local portal = {
  tint, {0,0,1,.000001},
  {
    clip,
    trails,
    {
      position, {2,-.18,0,.355,
        react = function(scene)
          scene[3] = require('scenes/tree')
        end },
      {
        wrap, {edge},
      }
    },
  },
}

local scene =
{
  combine,
  eggShade,
  egg,
  portal,
  flowers,
  trails,
  {--[[shadow]] tint, {0.71, 0.30, 0.11}, {position, {0, -.9, 0, .7, .1}, eggShape}},
  grass,
  {--[[horizon]] tint, {0.55, 0.85, 0.75}, {position, {0, -.35}, {edge}}},
  {--[[sky]] tint, {0.55, 1.00, 0.43}, {position, {0, -100, .5}, {edge}}},
}

return scene