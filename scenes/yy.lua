local lume = require('lume')
require('nodes')
local dark =  {0.71, 0.30, 0.11}
local light = {0.5,  0.5, 1}
scene = {
  position,
  {0, 0, 0, 3/2},
  {
    combine,
    {tint, light, {position, {-1/2, 0, 0, 1/8, 1/8}, {wrap, {edge}}}},          -- sunny dot
    {tint, dark,  {position, { 1/2, 0, 0, 1/8, 1/8}, {wrap, {edge}}}},          -- shady dot
    {tint, light, {position, { 1/2, 0, 0, 1/2, 1/2}, {wrap, {edge}}}},          -- sunny circle
    {tint, dark,  {position, {-1/2, 0, 0, 1/2, 1/2}, {wrap, {edge}}}},          -- shady circle
    {tint, light, {clip, {wrap, {edge}}, {edge}}},                        -- sunny side
    {tint, dark, {wrap, {edge}}},                                             -- shady side
    {tint, {0.64, 0.28, 0.21}, {combine, {edge}, {position, {0, 0, 1/2}, {edge}}}}, -- background
  },
}

return scene
