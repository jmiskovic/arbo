local nodes = require('nodes')
local colors = require('scenes/colors')

local vars =
{
  mouthSX = .15,
  mouthSY = .03,
}

local blinkPos = {0,1}
local mouthPos = {0, -.67, 0, .15, .03}

local face =
  {
    --'combine',
    'smooth', .81,
    {
      position, {0,.2,0,.57}, {wrap, {edge}}
    },
    {
      position, {0,-.4,0,.42,.48}, {wrap, {edge}}
    }
--    clip,
--    {
--      position, {0,.2,0,.6,1.3}, {wrap, {edge}}
--    },
--    {
--      position, {0,-.16,0,.61,.75}, {wrap, {edge}}
--    }
  }

local eye =
{
  clip,
  {position, blinkPos, {edge} },
  -- check this out!
  {position, {0, 0, .5, 1}, {position, blinkPos, {edge}}},

  {
    combine,
    {
      tint, colors.black,
      {
        position, {0,0,0,1}, {wrap, {edge}}
      },
    },
    {
      tint, colors.white,
      {
        position, {0,0,0,1.5}, {wrap, {edge}}
      },
    },
  },
}

local eyes = {
  combine,
  {position,{.25,0,0,.1}, eye},
  {position,{-.25,0,0,.1}, eye},
}


local mouth = {
  tint, {0.99, .88, .57},-- 'mouthCl'},
  {
    position, mouthPos,
    require('scenes/shapes').makePolygon(4),
  }
}

local neck =
{
  tint, colors.skinShade,
  {
    position, {0, -1, 0, .3, .3},
    require('scenes/shapes').makePolygon(4)
  }
}

local hair = {tint, colors.hair, {position, {.02, -.19, .0174, 1.258, 1.459}, face}}
local frontHair = {clip, {position, {.03, .77, .0453, 1.02, .53}, {wrap, {edge}}}, hair}
local frontHairShade = {tint, colors.hairShade, {clip, {position, {.0, .74, .0576, 1.02, .53}, {wrap, {edge}}}, face}}

local head =
{
  combine,
  frontHair,
  frontHairShade,
  eyes,
  mouth,
  --{--[[faceShade]] tint, {0.07, 0.42, 0.65}, {clip, face, {position, {0, 0, 0, 1}, {negate, face}}}},
  {--[[face]] tint, colors.skin, face },
  neck,
  hair,
  --{--[[sky]]     tint, {0.55, 1.00, 0.43}, {wrap, {position, {0, -1, .5}, {edge}}}},
}

local scene =
{
  interact,
  {mouthCl = 0.71},
  head,
  {
    {
      case= {mouthCl = .71},
      name = 'redden',
      {set, 'mouthCl', .57},
    },
    {
      case= {mouthCl = .57},
      name = 'lighten',
      {set, 'mouthCl', .71},
    },
  }
}

local bunch =
{
  combine,
  --{'mod', {position, { 0, 0, 0, 1}, head}},

  --{clip,
  --  {position,  {0,  1, .0}, {edge}},
  --  {position, {0, -1, .5}, {edge}},
  --  {position, { 0, 0, 0, 1}, {'mod', head}},
  --  },

  -- {'mirror', {position, { 0, 0, 0, 1}, head}},
---[[
  {position, { .25, 0, 0, .2}, head},
  {position, { .75, 0, 0, .2}, head},
  {position, {-.75, 0, 0, .2}, head},
  {position, { .25 + .25, -.5, 0, .2}, head},
  {position, { .75 + .25, -.5, 0, .2}, head},
  {position, {-.75 + .25, -.5, 0, .2}, head},
  {position, { .25 + .25, .5, 0, .2}, head},
  {position, { .75 + .25, .5, 0, .2}, head},
  {position, {-.75 + .25, .5, 0, .2}, head},


  {position, {-.25, 0, 0, .2}, head},
  {position, {-.25, 0, 0, .24}, {wrap, {edge}}},
--]]
  {--[[sky]]     tint, {0.55, 1.00, 0.43}, {position, {0, -100, .5}, {edge}}},
}

return head