local module = {}

local traceDistance     = not true
local progressiveVision = not true

local maxStroke = 150 / love.graphics.getDPIScale()
local strokeDecay = traceDistance and 500000 or 1000000

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

function module.new(width, height, stroke, opacity)
  local instance  = setmetatable({}, {__index=module})
  instance.canvas = love.graphics.newCanvas(width, height)
  instance.stroke = stroke or maxStroke
  instance.currentStroke = progressiveVision and maxStroke or instance.stroke
  instance.opacity = progressiveVision and .1 or (opacity or .9)
  return instance
end

function module:draw(scene, duration, canvas, stroke, opacity)
  canvas  = canvas or self.canvas
  local width  = canvas:getWidth()
  local height = canvas:getHeight()
  stroke  = stroke or self.currentStroke / height
  opacity =  opacity or self.opacity

  local t = love.timer.getTime()
  local raysShot = 0

  love.graphics.push('all')
  love.graphics.reset()
  love.graphics.setCanvas(canvas)
  love.graphics.translate(width/2, height/2)
  love.graphics.scale(height/2, -height/2)

  while love.timer.getTime() - t < duration do
    local x = -width/height + 2 * width/height * random()
    local y = -1 + 2 * random()
    local r,g,b,a
    local h, s, l, d = module.trace(scene, x, y, {}, 1)
    local ss = stroke
    love.graphics.push()
      love.graphics.translate(x, y)
      love.graphics.rotate(.1 + random())
      if traceDistance then -- trace distance from edge for stroke size
        ss = max(stroke, min(maxStroke, .0 + .39 * abs(d)))
      end
      -- l = l * d / abs(d)  -- backify if d < 0 by setting negative lightness
      if d < 0 then --noise background
        l = .03 + .8 * l + .1 * math.random()
        s = s * .3
      end
      r,g,b,a = lume.hsl(h, s, l, opacity)
      --a = d > 0 and d * 100 or 0
      love.graphics.setColor(r,g,b,a)
      love.graphics.ellipse('fill', 0, 0, ss, ss/2, 17)
    love.graphics.pop()

    raysShot = raysShot + 1
  end
  if progressiveVision then
    self.opacity = min(.9, self.opacity + 10 * raysShot / strokeDecay)
    self.currentStroke = max(self.stroke, self.currentStroke - self.currentStroke^2 * raysShot / strokeDecay)
  else
    self.currentStroke = self.stroke
  end
  love.graphics.pop()
  return raysShot
end

function module:resetStroke()
  if progressiveVision then
    self.currentStroke = maxStroke
    self.opacity = 0.3
  end
end


-- local memos = {}
--
-- local ffi = require('ffi')
-- ffi.cdef[[
-- typedef struct { double h,s,l,d; } memoryT;
-- ]]
--
-- function memoLookup(node, precision, x, y, env, depth, tracefun)
--   tracefun = tracefun or module.trace
--   local hsld, h, s, l, d
--   ---[[
--   -- introduce dithering
--   local xd = x + precision * (random() - .5)
--   local yd = y + precision * (random() - .5)
--   -- snap x,y to grid
--   local xg = xd - (xd % precision) + precision / 2
--   local yg = yd - (yd % precision) + precision / 2
--   --]]
--
--   memos[node] = memos[node] or {count = 0}
--   local memo = memos[node] -- this is memo table for specific node
--   --memo[xg] = memo[xg] or {} -- search by x
--   local mem = memo[xg] and memo[xg][yg] -- search by y
--   if not mem or random() > .95 then
--     h, s, l, d = tracefun(node[3], x, y, env, depth + 1)
--     if true or d > 0 then
--       mem = ffi.new("memoryT")
--       --mem = {}
--       mem.h, mem.s, mem.l, mem.d = h,s,l,d
--       memo[xg] = memo[xg] or {}
--       memo[xg][yg] = mem
--     end
--     -- print(mem)
--     -- memo[xg][yg] = {h,s,l,d}
--     memo.count = memo.count + 1
--   else
--     -- h,s,l,d = unpack(hsld)
--     h,s,l,d = mem.h, mem.s, mem.l, mem.d
--   end
--   --print(h, s, l, d)
--   return h, s, l, d
-- end

---[[
local memos = {}
local ffi = require('ffi')
--local hash = ffi.new('int32_t[1]', 0)

function memoLookup(node, precision, x, y, env, depth, tracefun)
  local h, s, l, d
  local memo = memos[node]
  if not memo then
    memo = {}
    memo.count = 0
    memos[node] = memo
  end
  x = x - x % precision + precision / 2
  y = y - y % precision + precision / 2
  hash = x .. y
  local stored = memo[hash]
  --print(x, y, hash + 0.00, stored)
  if not stored or random() > .95 then
    h,s,l,d = tracefun(node[3], x, y, env, depth + 1)
    stored = ffi.new('double[4]')
    stored[0], stored[1], stored[2], stored[3] = h, s, l, d
    memo[hash] = stored
    memo.count = memo.count + 1
  end
  return stored[0], stored[1], stored[2], stored[3]
end
--]]

function memoReset(node)
  memos[node] = nil
end

function R(exp, env, default) -- resolve
  return exp or default
  --[[
  if type(exp) == 'number' then
    return exp
  elseif type(exp) == 'string' then
    return env[exp] or default
  elseif type(exp) == 'nil' then
    return default
  end
  --]]
end

function module.trace(node, x, y, env, depth, tracefun) -- returns ray color
  tracefun = tracefun or module.trace
  if depth > 28 then return 0, 1, 1, 0 end

  if type(node[1]) ~= 'string' then
    error('node has no type?!', node)
    return .9, 1, .5, 1 -- color errors with magenta color

  elseif node[1] == 'disable' then
    return 0, 0, 1, -1

  elseif node[1] == 'edge' then
    --     H  S  L  distance from edge
    return 0, 0, 1, -(R(node[2], env, 0) + y) * R(node[3], env, 1)

  elseif node[1] == 'simplex' then
    --     H  S  L  distance from edge
    return 0, 0, 1, .2 * R(node[3], env, 1) * (R(node[2], env, 0) + noise.Simplex2D(x, y))

  elseif node[1] == 'position' then
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    local h,s,l,d = tracefun(node[3], x, y, env, depth + 1)
    if traceDistance then
      d = d * math.min(R(node[2][4], env, 1), R(node[2][5], env, 1))
    end
    return h,s,l,d

  elseif node[1] == 'wrap' then
    local ph = -atan2(x, y)
    local r = sqrt(x^2 + y^2)
    return tracefun(node[3], ph / pi, r^node[2] -1, env, depth + 1)

  elseif node[1] == 'unwrap' then
    local ph, r = x, y
    x = (r + 1) * cos(-ph)
    y = (r + 1) * sin(-ph)
    return tracefun(node[2], x, y, env, depth + 1)

  elseif node[1] == 'negate' then
    local h,s,l,d = tracefun(node[2], x, y, env, depth + 1)
    d = -d
    return h,s,l,d

  elseif node[1] == 'mirror' then
    return tracefun(node[2], abs(x), y, env, depth + 1)

  elseif node[1] == 'mod' then
    local modX = node[3] or 1
    local modY = node[4] or 1
    x = ((x/2 + .5) % modX) * 2 - 1
    y = ((y/2 + .5) % modY) * 2 - 1
    --x = ((x + 1)/2 % 1) * abs(x)/x
    return tracefun(node[2], x, y, env, depth + 1)

  elseif node[1] == 'replicate' then
    local h,s,l,d
    local t = getTransform(node[3])
    for i = 1, node[2] do
      h,s,l,d = tracefun(node[4], x, y, env, depth + 1)
      if d > 0 then break end
      x,y = t:transformPoint(x, y)
    end
    return h,s,l,d

  elseif node[1] == 'smooth' then
    local h, s, l, a, b, e, d
    local r = node[2]
    h,s,l, a = tracefun(node[3], x, y, env, depth + 1)
    h,s,l, b = tracefun(node[4], x, y, env, depth + 1)
    if r > 0 then
      e = max(r - abs(a - b), 0)
      d = max(a, b) + e^2 * 0.25 / r
      return h, s, l, d
    else
      e = max(-r - abs(-a - b), 0)
      d = -max(-a, b) + e^2 * 0.25 / r
      return h, s, l, d
    end

  elseif node[1] == 'combine' then
    local h,s,l,d
    local minA = huge -- huGEE!
    for i=2, #node do
      branch = node[i]
      h,s,l,d = tracefun(branch, x, y, env, depth + 1)
      minA = min(minA, abs(d))
      if d > 0 then break end
    end
    d = minA * d / abs(d) -- minimal a, but with correct sign
    return h,s,l,d

  elseif node[1] == 'sum' then
    local h, s, l, d, sumD
    sumD = 0
    for i=2, #node do
      h,s,l,d = tracefun(node[i], x, y, env, depth + 1)
      sumD = sumD + d
    end
    d = sumD
    return h,s,l,d

  elseif node[1] == 'clip' then
    local h,s,l,d
    local minD = huge -- huge! o_O
    for i=2, #node do
      branch = node[i]
      h,s,l,d = tracefun(branch, x, y, env, depth + 1)
      minD = min(minD, d)
    end
    d = minD
    return h,s,l,d

  elseif node[1] == 'noise' then
    local h,s,l,d = tracefun(node[3], x, y, env, depth + 1)
    h = h + R(node[2][1], env, h) * (random() - .5)
    s = s + R(node[2][2], env, s) * (random() - .5)
    l = l + R(node[2][3], env, l) * (random() - .5)
    return h,s,l,d

  elseif node[1] == 'tint' then
    local h,s,l,d = tracefun(node[3], x, y, env, depth + 1)
    local intensity = R(node[2][4], env, 1)
    h = h * (1 - intensity) + R(node[2][1], env, h) * intensity
    s = s * (1 - intensity) + R(node[2][2], env, s) * intensity
    l = l * (1 - intensity) + R(node[2][3], env, l) * intensity
    if node.react then
      l = l + .2 * math.random() -- pixie dust
    end
    return h,s,l,d

  elseif node[1] == 'memo' then
    return memoLookup(node, R(node[2], env)/100, x, y, env, depth, tracefun)

  elseif node[1] == 'interact' then
    return tracefun(node[3], x, y, setmetatable(node[2], {__index=env}), depth + 1)

  else
    error('unrecognized type', node)
    return .9, 1, .5, 1 -- color errors with magenta color
  end
end

return module