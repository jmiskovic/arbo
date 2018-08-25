local scene = require('scene')

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
	local t = love.timer.getTime()

	love.graphics.setCanvas(canvas)
	love.graphics.translate(sw/2, sh/2)
	love.graphics.scale(sh/2)
	local i = 0
	while love.timer.getTime() - t < .1 do
		local x = -sr + 2 * sr * math.random()
		local y = -1 + 2 * math.random()

		local d = traceDensity(scene, x, y)
		love.graphics.setColor(d, d, d)
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

local lastIndex = 0
function dumpTGF(node)
	local index = lastIndex + 1
	lastIndex = index
	local conns = {}
	local label = node.is
	for i, child in ipairs(node) do
		if type(child) == 'table' then
			childIndex, childConns = dumpTGF(child)
			for i,v in ipairs(childConns) do
				table.insert(conns, {v[1], v[2]})
			end
			table.insert(conns, {index, childIndex})
		else
			label = label .. ', ' .. child
		end
	end
	print(index, label)
	return index, conns
end

function love.load()
	childIndex, childConns = dumpTGF(scene, 0)
	print('#')
	for i, conn in ipairs(childConns) do
		print(conn[1], conn[2])
	end
end

function traceDensity(node, x, y)
	if not node.is then
		showError('node has no type?!', node)
		return 0
	elseif node.is == 'lhp' then
		return -y
  elseif node.is == 'transform' then
    if not node[1] then showError('transform has no subtree', node) end
    if node[2] and node[2].is == 'linear' then
      local t = S(node[2])
      x,y = t:transformPoint(x, y)
    end
    return traceDensity(node[1], x, y)
  elseif node.is == 'negate' then
    return -traceDensity(node[1], x, y)
  elseif node.is == 'union' then
    local max = -math.huge
    for i,branch in ipairs(node) do
      max = math.max(max, traceDensity(branch, x, y))
    end
    return max
  elseif node.is == 'intersect' then
    local min = math.huge
    for i,branch in ipairs(node) do
      min = math.min(min, traceDensity(branch, x, y))
    end
    return min
  elseif node.is == 'wrap' then
    local r = (x^2 + y^2) - 1
    local a = -math.atan2(y, x) / math.pi
    return traceDensity(node[1], a, r)
  elseif node.is == 'combine' or node.is == 'render' then
    return -1
  else
    showError('unrecognized type', node)
    return -1
  end
end

function showError(msg, node)
  print(msg)
  if node then
    --persist.print(node)
  end
end
