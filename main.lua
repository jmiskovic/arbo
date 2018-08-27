local lume = require('lume')
local scene = require('scene')
local TGF = require('TGF')

local sw, sh = love.graphics.getDimensions()
local sr = sw / sh -- ranges from 1.7 to 2.1, typically 16/9 = 1.77

local transform = love.math.newTransform()

local nodeTransforms = {}
local function getTransform(node)
    if not nodeTransforms[node] then
      nodeTransforms[node] = transform:setTransformation(node[2], node[3], node[4], node[5], node[6]):inverse()
    end
    return nodeTransforms[node]
end

local canvas = love.graphics.newCanvas()

local time = 0
function love.update(dt)
	time = time + dt
	if scene.update then scene.update(scene, dt, time) end
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

function love.draw()
	local white = {1, 1, 1}
	local t = love.timer.getTime()
  updateTransforms(scene)
  love.graphics.setCanvas(canvas)
  --love.graphics.clear()
  love.graphics.translate(sw/2, sh/2)
  love.graphics.scale(sh/2, -sh/2)

	local i = 0

	while love.timer.getTime() - t < .1 do
		local x = -sr + 2 * sr * math.random()
		local y = -1 + 2 * math.random()

		local ray = trace(scene, white, x, y)
		if ray[4] < 0.01 then ray = {0, 0, 0, 1} end --TODO: this hack makes it possible to not clear the canvas
		love.graphics.setColor(unpack(ray))
		love.graphics.circle('fill', x, y, math.random() * 10 / sh)
		i = i + 1
	end
	-- draw result of tracing
	love.graphics.setCanvas()
	love.graphics.origin()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(canvas, 0, 0)
	love.graphics.setColor(0, 1, 0)
	love.graphics.print(love.timer.getFPS() .. ', ' .. i)
end

function love.load()
	TGF.export(scene)
end

function trace(node, ray, x, y) -- returns ray color
  if not node.is then
    error('node has no type?!', node)
    return {1, 1, 1, 0}
  elseif node.is == 'lhp' then
  	ray[4] = 0.5 - y
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
    return trace(node[1], {node[2], node[3], node[4], node[5]}, x, y)
  else
    error('unrecognized type ' .. node.is, node)
    return {1, 1, 1, 0}
  end
end

function interact(node, x, y)
	if node.is == 'lhp' or
	   node.is == 'union' or
	   node.is == 'intersect' then
		return false
	elseif node.is == 'transform' then
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
		print('here', x, y)
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
    --persist.print(node)
  end
end
