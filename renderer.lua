local module = {}

local lume = require('lume')

function module.new(width, height)
  local instance = setmetatable({}, {__index=module})
  instance.canvas = love.graphics.newCanvas(width, height)
  instance.width = width
  instance.height = height
  instance.ratio = width / height -- should be around 1.7 to 2.1, typically 16/9 = 1.77
  return instance
end

local transform = love.math.newTransform()
-- transform matrix calculation caching per node
local nodeTransforms = {}
local function getTransform(node)
    if not nodeTransforms[node] then
      nodeTransforms[node] = transform:setTransformation(node[2], node[3], node[4], node[5], node[6]):inverse()
    end
    return nodeTransforms[node]
end

local function updateTransforms(node)
  if type(node) == 'table' then
    if node.is == 'linear' then
      nodeTransforms[node] = transform:setTransformation(node[2], node[3], node[4], node[5], node[6]):inverse()
    end
    for i,child in ipairs(node) do
      updateTransforms(child)
    end
  end
end

function module:draw(scene)
  local white = {1, 1, 1}
  local t = love.timer.getTime()
  updateTransforms(scene)
  love.graphics.push('all')
  love.graphics.setCanvas(self.canvas)
  love.graphics.translate(self.width/2, self.height/2)
  love.graphics.scale(self.height/2, -self.height/2)

  while love.timer.getTime() - t < .1 do
    local x = -self.ratio + 2 * self.ratio * math.random()
    local y = -1 + 2 * math.random()

    local ray = trace(scene, white, x, y)
    --TODO: this hack makes it possible to not clear the canvas
    if ray[4] < 0.01 then ray = {0, 0, 0, 1} end
    love.graphics.setColor(unpack(ray))
    love.graphics.circle('fill', x, y, math.random() * 20 / self.height)
  end
  love.graphics.pop()
end

function trace(node, ray, x, y) -- returns ray color
  if not node.is then
    error('node has no type?!', node)
    return {1, 1, 1, 0}
  elseif node.is == 'lhp' then
  	ray[4] = 0.5 - y * 100
    return ray
  elseif node.is == 'linear' then
    if not node[1] then error('transform has no subtree', node) end
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    return trace(node[1], ray, x, y)
  elseif node.is == 'negate' then
    local ray = trace(node[1], ray, x, y)
    ray[4] = 1 - ray[4]
    return ray
  elseif node.is == 'union' then
  	local r
    local max = -math.huge
    for i,branch in ipairs(node) do
      r = trace(branch, ray, x, y)
      max = math.max(max, r[4])
    end
    --print('union', r[1],r[2],r[3],r[4])
    r[4] = max
    return r
  elseif node.is == 'join' then
  	local r
    for i,branch in ipairs(node) do
      r = trace(branch, ray, x, y)
      if r[4] > 0 then break end
    end
    return r
  elseif node.is == 'intersect' then
    local r
    local min = math.huge
    for i,branch in ipairs(node) do
      r = trace(branch, ray, x, y)
      min = math.min(min, r[4])
    end
    r[4] = min
    return r
  elseif node.is == 'wrap' then
    local r = (x^2 + y^2) - 1
    local a = -math.atan2(y, x) / math.pi
    return trace(node[1], ray, a, r)
  elseif node.is == 'tint' then
    return trace(node[1], {node[2], node[3], node[4], node[5]}, x, y)
  elseif node.is == 'interact' then
    return trace(node[1], ray, x, y)
  else
    error('unrecognized type ' .. node.is, node)
    return {1, 1, 1, 0}
  end
end

return module