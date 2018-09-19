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

function module:draw(scene)
  local white = {1, 1, 1}
  local t = love.timer.getTime()
  local frames = 0
  love.graphics.push('all')
  love.graphics.setCanvas(self.canvas)
  love.graphics.translate(self.width/2, self.height/2)
  love.graphics.scale(self.height/2, -self.height/2)
  while love.timer.getTime() - t < .1 do --lume.remap(love.mouse.getY(), 0, love.graphics.getHeight(), .1, .001) do
    local x = -self.ratio + 2 * self.ratio * math.random()
    local y = -1 + 2 * math.random()

    local ray = trace(scene, white, x, y)
    --TODO: this hack makes it possible to not clear the canvas
    if ray[4] < 0.01 then ray = {0, 0, 0, 1} end
    love.graphics.setColor(unpack(ray))
    love.graphics.circle('fill', x, y, math.random() * 10 / self.height)
    frames = frames + 1
  end
  --love.timer.sleep(.1)
  love.graphics.pop()
  return frames
end

function trace(node, ray, x, y) -- returns ray color
  if not node.is then
    error('node has no type?!', node)
    return {1, 1, 1, 0}
  elseif node.is == 'lhp' then
  	ray[4] = 0.5 - y * 10000
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
  	local ray = ray
    local max = -math.huge
    for i,branch in ipairs(node) do
      ray = trace(branch, ray, x, y)
      max = math.max(max, r[4])
    end
    --print('union', r[1],r[2],r[3],r[4])
    ray[4] = max
    return ray
  elseif node.is == 'join' then
  	local ray = ray
    for i,branch in ipairs(node) do
      ray = trace(branch, ray, x, y)
      if ray[4] > 0 then break end
    end
    return ray
  elseif node.is == 'intersect' then
    local ray = ray
    local min = math.huge
    for i,branch in ipairs(node) do
      min = math.min(min, trace(branch, ray, x, y)[4])
    end
    ray[4] = min
    return ray
  elseif node.is == 'wrap' then
    local r = (x^2 + y^2) - 1
    local a = -math.atan2(y, x) / math.pi
    return trace(node[1], ray, a, r)
  elseif node.is == 'tint' then
    return trace(node[1], {node[2], node[3], node[4], node[5]}, x, y)
  --elseif node.is == 'react' then
  --  return trace(node[1], ray, x, y)
  else
    error('unrecognized type ' .. node.is, node)
    return {1, 1, 1, 0}
  end
end

return module