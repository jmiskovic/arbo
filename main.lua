require('nodes')
local lume = require('lume')
local persist = require('persist')
local scene = require('scenes/flying')
local TGF = require('TGF')
local transpiler = require('transpiler')
transpiler.process(scene)

local sw, sh = love.graphics.getDimensions()
local sr = sw / sh -- ranges from 1.7 to 2.1, typically 16/9 = 1.77
local renderer = require('renderer').new(sw, sh)
local treeverse = require('treeverse')
local editor = require('editor').new(sw, sh, scene)
local cameraTransform = {0, 0, 0, 1}
local camera = {position, cameraTransform, scene}
transform = love.math.newTransform()
-- transform matrix calculation caching per node
local nodeTransforms = {}

local function updateTransforms(node)
  if debug.getinfo(16) then return end

  if type(node) == 'table' then
    if node[1] == 'position' then
      nodeTransforms[node] = transform:setTransformation(
          node[2][1],                 -- dx
          node[2][2],                 -- dy
          (node[2][3] or 0) * 2 * math.pi,   -- rotation, have to convert 0..1 to 0..2pi
          node[2][4],                 -- sx
          node[2][5]                  -- sy
        ):inverse()
    end
    for i,child in ipairs(node) do
      updateTransforms(child)
    end
  end
end

function getTransform(node)
  if not nodeTransforms[node] then
    updateTransforms(node)
  end
  return nodeTransforms[node]
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
        for i, instruction in ipairs(closest) do
          if instruction[1] == 'set' then
            node[instruction[2]] = instruction[3]
          end
        end
      end
    end
    return true
  elseif node[1] == 'edge' or
     node[1] == 'simplex' or
     node[1] == 'union' or
     node[1] == 'clip' then
    return false
  elseif node[1] == 'position' then
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    return interact(node[2], x, y) or interact(node[3], x, y)
  elseif node[1] == 'wrap' then
    local r = (x^2 + y^2) - 1
    local a = -math.atan2(y, x) / math.pi
    return interact(node[2], a, r)
  elseif node[1] == 'negate' or -- TODO: what to do here?
         node[1] == 'tint' then
    return interact(node[2], x, y)
  elseif node[1] == 'combine' then
    local i = false
    for i=2, #node do
      branch = node[i]
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
  --interact(camera, x, y)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  love.mousereleased(x, y, 1, true, 1)
end

function love.mousemoved(x, y, dx, dy, istouch)
  if love.mouse.isDown(1) then
    editor:touchmoved(nil, x, y, dx, dy, 1)
    treeverse.touchmoved(nil, x, y, dx, dy, 1)
  end
end

local touches = {}
function love.touchmoved(id, x, y, dx, dy, pressure)
  love.mouse.setPosition(x, y)
  if #love.touch.getTouches() == 1 then
    editor:touchmoved(id, x, y, dx, dy, pressure)
    treeverse.touchmoved(id, x, y, dx, dy, pressure)
  elseif #love.touch.getTouches() == 3 then
    renderer.stroke = math.max(5, renderer.stroke + 10 * dy / sh)
  end
  touches[id] = {x, y, dx, dy}
end

local errorPrinted = false
function error(msg, node)
  if errorPrinted then
    return
  end
  errorPrinted = true
  print(msg)
  if node then
    print('node is', node[1])
    if type(node[1]) == 'table' then
      for k,v in pairs(node[1]) do
        print(k, '=', v)
      end
      print(node[1][2][3])
    end
  end
end

local datetime = os.date('*t')
local time = datetime.hour * 3600 + datetime.min * 60 + datetime.sec

function love.update(dt)
  time = time + dt
  if scene.update then scene.update(scene, dt, time) end
  treeverse.update(dt)
  editor:update(dt)
  updateTransforms(camera)
  if #love.touch.getTouches() == 0 then
    love.timer.sleep(.02)
  end
  love.timer.sleep(.02)
end

local frames = 1000
function love.draw()
  local white = {1, 1, 1}
  local rayCount = 0
  rayCount = renderer:draw(scene, .02)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(renderer.canvas)
  if #love.touch.getTouches() == 1 then
    treeverse.draw()
    editor:draw()
    --love.graphics.setColor(1, 1, 1)
    --frames = .96 * frames + .04 * rayCount
    --love.graphics.print(string.format('%.1fk | %d fps | %d stroke', frames / 1000, love.timer.getFPS(), renderer.stroke))
  end
end

function love.load()
  love.mouse.setVisible(false)
  --TGF.export(scene)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'f11' then
    love.window.setFullscreen(not love.window.getFullscreen())
  elseif key == 'f2' then
    persist.store(scene, 'scene.lua')
  elseif key == 'f5' then
    loaded = persist.load('scene.lua')
    print('loaded', loaded)
    if loaded then
      scene = loaded
      editor = require('editor').new(sw, sh, scene)
      cameraTransform = {0, 0, 0, 1, 1}
      camera = {position, cameraTransform, scene}
    end
  end
end