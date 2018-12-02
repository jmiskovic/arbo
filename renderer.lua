local module = {}

local lume = require('lume')
local noise = require('noise')

local pi = math.pi
local huge = math.huge
local min = math.min
local max = math.max
local abs = math.abs
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local atan2 = math.atan2
local random = math.random

function module.new(width, height, stroke)
  local instance  = setmetatable({}, {__index=module})
  instance.canvas = love.graphics.newCanvas(width, height)
  instance.width  = width
  instance.height = height
  instance.ratio  = width / height -- should be around 1.7 to 2.1, typically 16/9 = 1.77
  instance.stroke = stroke or 30 / love.graphics.getDPIScale()
  instance.currentStroke = 100 / love.graphics.getDPIScale()
  return instance
end

function module:draw(scene, duration)
  local canvas = self.canvas
  local width  = self.width
  local height = self.height

  local t = love.timer.getTime()
  local raysShot = 0

  love.graphics.push('all')
  love.graphics.reset()
  love.graphics.setCanvas(self.canvas)
  love.graphics.translate(width/2, height/2)
  love.graphics.scale(height/2, -height/2)

  while love.timer.getTime() - t < duration do
    local x = -width/height + 2 * width/height * random()
    local y = -1 + 2 * random()
    local h, s, l, d = trace(scene, x, y, {}, 1)
    if d > 0 then
      love.graphics.push()
      love.graphics.translate(x, y)
      love.graphics.rotate(.1 + random())
      local ss = self.currentStroke / height
      if false and #love.touch.getTouches() == 2 then
        -- magic (using distance from edge for stroke size)
        local ss = min(.12, .0 + .38 * abs(d))
      end
      local noise = .02 * (-.5 + random())
      local r,g,b,a = lume.hsl(h, s, l + noise, .9)
      love.graphics.setColor(r,g,b,a)
      love.graphics.ellipse('fill', 0, 0, ss, ss/3, 6)
      love.graphics.pop()
    end
    raysShot = raysShot + 1
  end
  self.currentStroke = max(self.stroke, self.currentStroke - self.currentStroke^2 * raysShot / 2000000)
  love.graphics.pop()
  return raysShot
end

function module:resetStroke()
  self.currentStroke = 100 / love.graphics.getDPIScale()
end

local memos = {}

function memoLookup(node, precision, x, y, env, depth)
  local hsld, h, s, l, d
  local xd = x + precision * (random() - .5)
  local yd = y + precision * (random() - .5)
  local xg = xd - (xd % precision) + precision / 2
  local yg = yd - (yd % precision) + precision / 2
  if love.keyboard.isDown('backspace') then
    memos[node] = nil
  end
  memos[node] = memos[node] or {count = 0}
  local memo = memos[node]
  memo[xg] = memo[xg] or {}
  local hsld = memo[xg][yg]
  if not hsld or random() > .85 then
    memo[xg] = memo[xg] or {}
    h,s,l,d = trace(node[3], xg, yg, env, depth + 1)
    memo[xg][yg] = {h,s,l,d}
    memo.count = memo.count + 1
  else
    h,s,l,d = unpack(hsld)
  end
  return h, s, l, d
end

function R(exp, env, default) -- resolve
  if type(exp) == 'number' then
    return exp
  elseif type(exp) == 'string' then
    return env[exp] or default
  elseif type(exp) == 'nil' then
    return default
  end
end

function trace(node, x, y, env, depth) -- returns ray color
  if depth > 15 then return 0, 1, 1, 0 end

  if type(node[1]) ~= 'string' then
    error('node has no type?!', node)
    return .9, 1, .5, 1 -- color errors with magenta color

  elseif node[1] == 'edge' then
    return 0, 0, 1,  -(R(node[2], env, 0) + y) * R(node[3], env, 1)

  elseif node[1] == 'simplex' then
    return 0, 1, 1, .2 * R(node[3], env, 1) * (R(node[2], env, 0) + noise.Simplex2D(x, y))

  elseif node[1] == 'position' then
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    return trace(node[3], x, y, env, depth + 1)

  elseif node[1] == 'camera' then
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    local h,s,l,d = trace(node[3], x, y, env, depth + 1)
    d = d * R(node[2][4], env, 1)
    return h,s,l,d

  elseif node[1] == 'wrap' then
    local ph = -atan2(y, x)
    local r = sqrt(x^2 + y^2) - 1
    return trace(node[2], ph, r, env, depth + 1)

  elseif node[1] == 'unwrap' then
    local ph, r = x, y
    x = (r + 1) * cos(-ph)
    y = (r + 1) * sin(-ph)
    return trace(node[2], x, y, env, depth + 1)

  elseif node[1] == 'negate' then
    local h,s,l,d = trace(node[2], x, y, env, depth + 1)
    d = -d
    return h,s,l,d

  elseif node[1] == 'replicate' then
    local h,s,l,d
    local t = getTransform(node[3])
    for i = 1, node[2] do
      h,s,l,d = trace(node[4], x, y, env, depth + 1)
      if d > 0 then break end
      x,y = t:transformPoint(x, y)
    end
    return h,s,l,d

  elseif node[1] == 'combine' then
    local h,s,l,d
    local minA = huge -- huGEE!
    for i=2, #node do
      branch = node[i]
      h,s,l,d = trace(branch, x, y, env, depth + 1)
      minA = min(minA, abs(d))
      if d > 0 then break end
    end
    d = minA * d / abs(d) -- minimal a, but with correct sign
    return h,s,l,d

  elseif node[1] == 'sum' then
    local h, s, l, d, sumD
    sumD = 0
    for i=2, #node do
      h,s,l,d = trace(node[i], x, y, env, depth + 1)
      sumD = sumD + d
    end
    d = sumD
    return h,s,l,d

  elseif node[1] == 'clip' then
    local h,s,l,d
    local minD = huge -- huge! o_O
    for i=2, #node do
      branch = node[i]
      h,s,l,d = trace(branch, x, y, env, depth + 1)
      minD = min(minD, d)
    end
    d = minD
    return h,s,l,d

  elseif node[1] == 'tint' then
    local h,s,l,d = trace(node[3], x, y, env, depth + 1)
    local intensity = R(node[2][4], env, 1)
    h = h * (1 - intensity) + R(node[2][1], env, h) * intensity
    s = s * (1 - intensity) + R(node[2][2], env, s) * intensity
    l = l * (1 - intensity) + R(node[2][3], env, l) * intensity
    if node.react then
      l = l + .2 * math.random() -- pixie dust
    end
    return h,s,l,d

  elseif node[1] == 'memo' then
    return memoLookup(node, R(node[2], env), x, y, env, depth)

  elseif node[1] == 'interact' then
    return trace(node[3], x, y, setmetatable(node[2], {__index=env}), depth + 1)

  else
    error('unrecognized type', node)
    return .9, 1, .5, 1 -- color errors with magenta color
  end
end

return module