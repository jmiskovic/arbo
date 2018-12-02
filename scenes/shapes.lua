local nodes = require('nodes')

local shapes = {}

shapes.circle =
{
  wrap,
  {edge}
}

shapes.rectangle =
{
  clip,
  {position, { 0,  1, .0}, {edge}},
  {position, { 0, -1, .5}, {edge}},
  {position, { 1,  0,-.25}, {edge}},
  {position, {-1,  0, .25}, {edge}},
}

function shapes.makePolygon(n)
  local polygon = {
    clip,
  }
  for i= 1,n do
    table.insert(polygon,
      {position, {0, 0, i/n}, {position, {0, 1}, {edge}}})
  end
  return polygon
end

return shapes