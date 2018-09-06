local lume = require('lume')
local scene = require('scenes/clock')
local TGF = require('TGF')

local sw, sh = love.graphics.getDimensions()
local sr = sw / sh -- ranges from 1.7 to 2.1, typically 16/9 = 1.77
local renderer = require('renderer').new(sw, sh)

local time = 0
function love.update(dt)
  time = time + dt
  if scene.update then scene.update(scene, dt, time) end
end

function love.draw()
  local white = {1, 1, 1}
  renderer:draw(scene)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(renderer.canvas)
  love.graphics.setColor(0, 1, 0)
  love.graphics.print(love.timer.getFPS())
end

function love.load()
  --TGF.export(scene)
end

function interact(node, x, y)
  if node.is == 'lhp' or
     node.is == 'union' or
     node.is == 'intersect' then
    return false
  elseif node.is == 'linear' then
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    return interact(node[1], x, y)
  elseif node.is == 'wrap' then
    local r = (x^2 + y^2) - 1
    local a = -math.atan2(y, x) / math.pi
    return interact(node[1], a, r)
  elseif node.is == 'negate' or
         node.is == 'tint' then
    return interact(node[1], x, y)
  elseif node.is == 'join' then
    local i = false
    for _,branch in ipairs(node) do
      i = interact(branch, x, y)
      if i then break end
    end
    return i
  elseif node.is == 'interact' then
    print(string.format('interacted r=%.2f, x=%.2f, y=%.2f', math.sqrt(x*x+y*y), x, y))
    return false
  else
    return false
  end
end

function love.mousereleased(x, y, button, istouch, presses)
  -- transform:setTransformation(unpack(...)):inverse()
  local t = transform:setTransformation(sw/2, sh/2, 0, sh/2, -sh/2):inverse()
  x, y = t:transformPoint(x, y)
  interact(scene, x, y)
end

function error(msg, node)
  print(msg)
  if node then
    print('node is', node.is)
    --persist.print(node)
  end
end
