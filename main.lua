local lume = require('lume')
local scene = require('scenes/clock')
local TGF = require('TGF')

local sw, sh = love.graphics.getDimensions()
local sr = sw / sh -- ranges from 1.7 to 2.1, typically 16/9 = 1.77
local renderer = require('renderer').new(sw, sh)

transform = love.math.newTransform()
-- transform matrix calculation caching per node
nodeTransforms = {}
function getTransform(node)
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

function interact(node, x, y)
  if node.react then
    if x^2 + y^2 < 1 then
      print(string.format('interacted r=%.2f, x=%.2f, y=%.2f', math.sqrt(x*x+y*y), x, y))
      local closeness = {} -- {case, closeness}
      for i, reaction in ipairs(node.react) do
        closeness[reaction] = 0
        for key, condition in pairs(reaction.case) do
          closeness[reaction] = closeness[reaction] + (condition - (node[key] or 0))^2
          print(key, node[key])
        end
        print('distance from action', reaction.name, closeness[reaction])
      end
      local closest = nil
      for case, distance2 in pairs(closeness) do
        closest = closest or case
        if distance2 < closeness[closest] then
          closest = case
        end
      end
      if closest then
        print('executing', closest.name)
        for i, instruction in ipairs(closest) do
          if instruction.is == 'set' then
            node[instruction[1]] = instruction[2]
          end
        end
      end
    end
    return true
  elseif node.is == 'lhp' or
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

function love.touchreleased(id, x, y, dx, dy, pressure)
  love.mousereleased(x, y, 1, true, 1)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  love.mouse.setPosition(x, y)
end


function error(msg, node)
  print(msg)
  if node then
    print('node is', node.is)
  end
end

local time = 0
function love.update(dt)
  time = time + dt
  if scene.update then scene.update(scene, dt, time) end
  updateTransforms(scene)
end

function love.draw()
  local white = {1, 1, 1}
  local rayCount = 0
  rayCount = renderer:draw(scene)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(renderer.canvas)
  love.graphics.setColor(0, 1, 1)
  love.graphics.print(rayCount / 1000)
end

function love.load()
  --TGF.export(scene)
end
