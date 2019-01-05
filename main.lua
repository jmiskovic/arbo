require('nodes')
local lume = require('lume')
local persist = require('persist')
--local scene = {position, {0,0,0,1,1}, {edge, 0, 1}}
--local scene = require('bwm/bluecircle')
--local scene = require('scenes/edg32')
local scene = require('scenes/falls')

local savefile = 'scene.lua'

local TGF = require('TGF')

local sw, sh = love.graphics.getDimensions()
local screenRatio = sw / sh -- ranges from 1.7 to 2.1, typically 16/9 = 1.77
local renderer = require('renderer').new(sw, sh, 15)
local treeverse = require('treeverse').new(sw, sh, scene, renderer)
editor = require('editor').new(sw, sh, scene)

local datetime = os.date('*t')
local time = datetime.hour * 3600 + datetime.min * 60 + datetime.sec
local renderTime = .01

local pinchInitial = {}
local tInit = {} -- initial touch positions (stored when number of touches changes)

tickPeriod = .05
guiVisible = true

transform = love.math.newTransform()
-- transform matrix calculation caching per node
local nodeTransforms = {}
local nodeTicks = {}

function love.load()
  love.mouse.setVisible(false)
  --TGF.export(scene)
end

local function walkNodes(node, depth)
  if type(node) == 'table' then
    if node.tick then
      nodeTicks[node] = node.tick
    end
    if node[1] == 'position' then
      nodeTransforms[node] = transform:setTransformation(
          node[2][1],                 -- dx
          node[2][2],                 -- dy
         (node[2][3] or 0) * 2 * math.pi, -- rotation, have to convert 0..1 to 0..2pi
          node[2][4],                 -- sx
          node[2][5]                  -- sy
        ):inverse()
    end
    for i,child in ipairs(node) do
      if depth < 15 then
        walkNodes(child, depth + 1)
      end
    end
  end
end

function getTransform(node)
  if not nodeTransforms[node] then
    walkNodes(node, 1)
  end
  return nodeTransforms[node]
end

local function interact(node, x, y)
  if node[1] == 'interact' and node[4] then
    print('distance', math.sqrt(x^2 + y^2))
    if x^2 + y^2 < 1 then
      print(string.format('interacted r=%.2f, x=%.2f, y=%.2f', math.sqrt(x*x+y*y), x, y))
      if type(node[4]) == 'function' then
        print('function')
        return node[4](scene) or true
      elseif type(node[4]) == 'table' then
        print('table')
        local closeness = {} -- {case, closeness}
        for i, reaction in ipairs(node[4]) do
          closeness[reaction] = 0
          for key, condition in pairs(reaction.case) do
            closeness[reaction] = closeness[reaction] + (condition - (node[2][key] or 0))^2
            print(key, node[2][key], condition)
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
              node[2][instruction[2]] = instruction[3]
            end
          end
        end
      end
      return true
    else
      return false
    end
  elseif node[1] == 'edge' or
     node[1] == 'simplex' or
     node[1] == 'union' then
    return false
  elseif node[1] == 'position' then
    local t = getTransform(node)
    x,y = t:transformPoint(x, y)
    return interact(node[3], x, y)
  elseif node[1] == 'wrap' then
    local ph = -math.atan2(y, x)
    local r = (x^2 + y^2) - 1
    return interact(node[3], ph / math.pi, r^node[2])
  elseif node[1] == 'tint' then
    return interact(node[3], x, y)
  elseif node[1] == 'negate' then -- TODO: what to do here?
    return interact(node[2], x, y)
  elseif node[1] == 'combine' or node[1] == 'add' or node[1] == 'clip' then
    local i = false
    for i=2, #node do
      branch = node[i]
      local done = interact(branch, x, y)
      if done then break end
    end
    return i
  else
    return false
  end
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
      print(node[1][2])
    end
  end
end

function love.update(dt)
  time = time + dt
  --run ticks across all nodes
  if time % tickPeriod < dt then
    for node, tick in pairs(nodeTicks) do
      tick(node, time)
      --treeverse.renderer:resetStroke()
    end
  end
  treeverse:update(dt)
  editor:update(dt)
  walkNodes(scene, 1)
  if #love.touch.getTouches() == 0 then
    --love.timer.sleep(.02)
  end
  love.timer.sleep(.02)
  for i, touchId in ipairs(love.touch.getTouches()) do
    tInit[i] = {love.touch.getPosition(touchId)}
    tInit[i+1] = nil
  end
end

local frames = 1000

function love.draw()
  local white = {1, 1, 1}
  local rayCount = 0

  if true then
    love.graphics.setColor(1, 1, 1, 1)
    treeverse:draw()
  else
    rayCount = renderer:draw(scene, renderTime)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(renderer.canvas)
    if #love.touch.getTouches() == 1 then
      love.graphics.setColor(1, 1, 1)
      editor:draw()
      frames = .96 * frames + .04 * rayCount
      love.graphics.print(string.format('%.1fk | %d fps | %d stroke | %.1f opacity ', frames / renderTime / 1000, love.timer.getFPS(), treeverse.renderer.stroke, renderer.opacity))
    end
  end
  if guiVisible and not treeverse.waitingSelection then
    love.graphics.setColor(1, 1, 1, 1)
    editor:draw()
    treeverse:drawIcons()
  end
end

function love.keypressed(key)
  if key == 'escape' then
    guiVisible = not guiVisible
  elseif key == 'f1' then
    local node, parent = editor:getSelected()
  elseif key == 'f11' then
    love.window.setFullscreen(not love.window.getFullscreen())
  elseif key == 'f2' then
    persist.store(scene, savefile)
  elseif key == 'f5' then
    loaded = persist.load(savefile)
    print('loaded', loaded)
    if loaded then
      scene = loaded
    else
      scene = {position, {0,0,0,1}, {'edge'}}
    end
    editor = require('editor').new(sw, sh, scene)
    treeverse = require('treeverse').new(sw, sh, scene, renderer)
  end
end

function love.mousereleased(x, y, button, istouch, presses)
  -- transform:setTransformation(unpack(...)):inverse()
  local t = transform:setTransformation(sw/2, sh/2, 0, sh/2, -sh/2):inverse()
  x, y = t:transformPoint(x, y)
  interact(scene, x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
  if love.mouse.isDown(1) then
    editor:touchmoved(nil, x, y, dx, dy, 1)
    treeverse.touchmoved(nil, x, y, dx, dy, 1)
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  for i, touchId in ipairs(love.touch.getTouches()) do
    tInit[i] = {love.touch.getPosition(touchId)}
    tInit[i+1] = nil
  end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  dx, dy = dx / love.graphics.getDPIScale(), dy / love.graphics.getDPIScale()
  love.mouse.setPosition(x, y)
  treeverse.touchmoved(id, x, y, dx, dy, pressure)
  if #love.touch.getTouches() == 1 and guiVisible then
    editor:touchmoved(id, x, y, dx, dy, pressure)
    treeverse.touchmoved(id, x, y, dx, dy, pressure)
  elseif #love.touch.getTouches() == 2 and #tInit == 2 then
    local _, id1 = next(love.touch.getTouches(), nil)
    local _, id2 = next(love.touch.getTouches(), 1)
    local tCurr = {{love.touch.getPosition(id1)}, {love.touch.getPosition(id2)}}
    local dx = ((tCurr[1][1] + tCurr[2][1]) / 2 -
                (tInit[1][1] + tInit[2][1]) / 2) * .0003
    local dy = ((tCurr[1][2] + tCurr[2][2]) / 2 -
                (tInit[1][2] + tInit[2][2]) / 2) * -.0003
    local rot = -.03 * (
        math.atan2(tCurr[1][2] - tCurr[2][2], tCurr[1][1] - tCurr[2][1]) -
        math.atan2(tInit[1][2] - tInit[2][2], tInit[1][1] - tInit[2][1])
      )
    rot = math.abs(rot) > .01 and 0 or rot -- stupid fix for angle wrap around
    local scl = 1 + .0003 * (
      math.sqrt((tCurr[1][1] - tCurr[2][1])^2 + (tCurr[1][2] - tCurr[2][2])^2) -
      math.sqrt((tInit[1][1] - tInit[2][1])^2 + (tInit[1][2] - tInit[2][2])^2))
    editor:pinchmoved(dx, dy, rot, scl)
    treeverse.renderer:resetStroke()
  elseif #love.touch.getTouches() == 3 then
    treeverse.renderer.stroke = math.max(2, treeverse.renderer.stroke + 10 * dy / sh)
    treeverse.renderer.opacity = math.max(.1, treeverse.renderer.opacity + .5 * dx / sh)
  end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  if #love.touch.getTouches() == 0 then
    if guiVisible then
      treeverse:mousereleased(x, y, button, istouch, presses)
    else
      local t = transform:setTransformation(sw/2, sh/2, 0, sh/2, -sh/2):inverse()
      x, y = t:transformPoint(x, y)
      interact(scene, x, y)
    end
  end
end

