local lume = require('lume')
local scene = require('scene')
local TGF = require('TGF')

local sw, sh = love.graphics.getDimensions()
local sr = sw / sh -- ranges from 1.7 to 2.1, typically 16/9 = 1.77

local transform = love.math.newTransform()
local S = function(...) return transform:setTransformation(unpack(...)):inverse() end

local canvas = love.graphics.newCanvas()

local time = 0
function love.update(dt)
	time = time + dt
	if scene.update then scene.update(scene, dt, time) end
end

function love.draw()
	local white = {1, 1, 1}
	local t = love.timer.getTime()
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
		love.graphics.circle('fill', x, y, math.random() * 5 / sh)
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
    showError('node has no type?!', node)
    return {1, 1, 1, 0}
  elseif node.is == 'lhp' then
  	ray[4] = 0.5 - y
    return ray
  elseif node.is == 'transform' then
    if not node[1] then showError('transform has no subtree', node) end
    if node[2] and node[2].is == 'linear' then
      local t = S(node[2])
      x,y = t:transformPoint(x, y)
    end
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
  else
    showError('unrecognized type', node)
    return {1, 1, 1, 0}
  end
end

function showError(msg, node)
  print(msg)
  if node then
    --persist.print(node)
  end
end
