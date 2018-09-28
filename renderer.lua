local module = {}

local lume = require('lume')
local noise = require('noise')


function module.new(width, height)
  local instance = setmetatable({}, {__index=module})
  instance.canvas = love.graphics.newCanvas(width, height)
  instance.width = width
  instance.lastFrameTime = love.timer.getTime()
  instance.height = height
  instance.ratio = width / height -- should be around 1.7 to 2.1, typically 16/9 = 1.77
  return instance
end

function module:draw(scene)
  local white = {1, 1, 1}
  local t = love.timer.getTime()
  local frames = 0
  local size = 20 + 50 * love.mouse.getY() / love.graphics.getHeight()
  -- local size =  1 + 50 * math.exp(- (love.timer.getTime() - self.lastFrameTime))
  love.graphics.push('all')
  love.graphics.setCanvas(self.canvas)
  love.graphics.translate(self.width/2, self.height/2)
  love.graphics.scale(self.height/2, -self.height/2)
  while love.timer.getTime() - t < .15 do
    local x = -self.ratio + 2 * self.ratio * math.random()
    local y = -1 + 2 * math.random()

    local ray = trace(scene, white, x, y)
    --TODO: this hack makes it possible to not clear the canvas
    if ray[4] < 0.01 then ray = {0, 0, 0, 1} end
    love.graphics.setColor(lume.hsl(unpack(ray)))
    --love.graphics.circle('fill', x, y, math.random() * size / self.height)
    love.graphics.push()
      love.graphics.translate(x, y)
      love.graphics.rotate(.1+math.random())
      local d = math.random() * size / self.height
      --love.graphics.rectangle('fill', 0, 0, d, d)
      love.graphics.ellipse('fill', 0, 0, d, d/7)
    love.graphics.pop()
    frames = frames + 1
  end
  love.timer.sleep(.015)
  love.graphics.pop()
  return frames
end

function trace(node, ray, x, y) -- returns ray color
  if (not node.is) and (type(node[1]) ~= 'string') then
    error('node has no type?!', node)
    return {1, 1, 1, 0}
  elseif node[1] == 'lhp' then
    ray[4] = 0.5 - y * 10
    return ray
  elseif node[1] == 'simplex' then
    ray[4] = (math.exp(-(y * 1.9)^2)*noise.Simplex2D(x, y) + .1) * 1
    return ray
  elseif node[1] == 'linear' then
    --if not node[1] then error('transform has no subtree', node) end
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    return trace(node[3], ray, x, y)
  elseif node[1] == 'negate' then
    local ray = trace(node[2], ray, x, y)
    ray[4] = 1 - ray[4]
    return ray
  elseif node[1] == 'union' then
  	local ray = ray
    local max = -math.huge
    for i=2, #node do
      branch = node[i]
      ray = trace(branch, ray, x, y)
      max = math.max(max, r[4])
    end
    ray[4] = max
    return ray
  elseif node[1] == 'join' then
  	local ray = ray
    for i=2, #node do
      branch = node[i]
      ray = trace(branch, ray, x, y)
      if ray[4] > 0.2 then break end
    end
    return ray
  elseif node[1] == 'intersect' then
    local ray = ray
    local min = math.huge
    for i=2, #node do
      branch = node[i]
      min = math.min(min, trace(branch, ray, x, y)[4])
    end
    ray[4] = min
    return ray
  elseif node[1] == 'wrap' then
    local r = (x^2 + y^2) - 1
    local a = -math.atan2(y, x) / math.pi
    return trace(node[2], ray, a, r)
  elseif node[1] == 'tint' then
    return trace(node[3], {node[2][1], node[2][2], node[2][3], node[2][4]}, x, y)
  --elseif node.is == 'react' then
  --  return trace(node[1], ray, x, y)
  else
    error('unrecognized type', node)
    return {1, 1, 1, 0}
  end
end

return module