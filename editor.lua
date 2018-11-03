local module = {}

local lume = require('lume')

local font = nil

function module.new(width, height, scene)
  local instance = setmetatable(
    {
      width = width,
      height = height,
      selected = 1,
      columns = {},
      parents = {},
      scene = scene,
    }, {__index=module})
  font = love.graphics.newFont('fonts/coolstory.ttf', width / 20)
  instance.colWidth = width / 5
  instance.rowHeight = font:getHeight()
  updateParents(scene, instance.parents, 1)
  instance.columns[1] = newColumn(scene)
  instance.renderer = require('renderer').new(instance.colWidth, instance.colWidth)
  instance.renderer.stroke = 10 --instance.colWidth / 50
  return instance
end

function newColumn(tree)
  local instance = {selected = 1, tree = tree} -- setmetatable(, {})
  return instance
end

function updateParents(node, parents, depth)
  for k,child in ipairs(node) do
    if type(child) == 'table' then
      -- append parent to table if it's not in there already
      if not parents[child] then
        parents[child] = {node}
      else
        local found = false
        for i,v in ipairs(parents[child]) do
          if v == node then
            found = true
          end
        end
        if found == false then
          table.insert(parents[child], node)
        end
      end
      if depth < 15 then
        updateParents(child, parents, depth + 1)
      end
    end
  end
end

function drawLabel(node)
  love.graphics.print(node[1], 50, 50)
end

function module:drawColumn(column, isSelected)
  local s = ''
  love.graphics.translate(0, -column.selected * self.rowHeight)
  if isSelected and type(column.tree[1]) == 'string' then
    love.graphics.push()
    love.graphics.translate(0, -self.colWidth -self.rowHeight)
    self.renderer:draw(column.tree, .02)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.renderer.canvas)
    love.graphics.pop()
  end

  for i,item in ipairs(column.tree) do
    -- select color
    local fg

    if isSelected then
      if i == math.floor(column.selected + .5) then
        fg = {lume.hsl(0.05, 0.42, 0.52, 1.00)}
      else
        fg = {lume.hsl(0.02, 0.34, 0.34, 1.00)}
      end
    else
      fg = {lume.hsl(0.93, 0.22, 0.20, 1.00)}
    end
    local bg = {fg[1] * .3, fg[2] * .3, fg[3] * .3}

    if type(item) == 'table' then
      s = string.format('  %s', type(item[1]) == 'string' and item[1] or '')
      if type(item) == 'table' then
        love.graphics.push('all')
        if item[1] == 'tint' then
          local color = {item[2][1] or 0, item[2][2] or 0, item[2][3] or 0, item[2][4] or 1}
          love.graphics.setColor(lume.hsl(unpack(color)))
          love.graphics.rectangle('fill', 0, -self.rowHeight / 4, self.rowHeight / 2, self.rowHeight / 2)
        else
          love.graphics.scale(1, .5)
          love.graphics.setLineWidth(self.rowHeight / 10)
          love.graphics.translate(font:getWidth(' '), -self.rowHeight/2)
          local span = self.rowHeight / #item
          love.graphics.setColor(fg)
          for i=1,#item do
            love.graphics.line(0, span / 5, font:getWidth(' ')/2, (i - 1) * span)
          end
        end
        love.graphics.pop()
      end
    elseif type(item) == 'number' then
      s = string.format('%+1.4f', item)
    elseif type(item) == nil then
      s = string.format('nil')
    else
      s = tostring(item)
    end
    love.graphics.setColor(bg)
    love.graphics.print(s, 0 + self.rowHeight / 50, -self.rowHeight / 2 + self.rowHeight / 50)
    love.graphics.print(s, 0 - self.rowHeight / 50, -self.rowHeight / 2 + self.rowHeight / 50)
    love.graphics.print(s, 0 + self.rowHeight / 50, -self.rowHeight / 2 - self.rowHeight / 50)
    love.graphics.print(s, 0 - self.rowHeight / 50, -self.rowHeight / 2 - self.rowHeight / 50)
    love.graphics.setColor(fg)
    love.graphics.print(s, 0, -self.rowHeight / 2)
    love.graphics.translate(0, self.rowHeight)
  end
end

function module:draw()
  love.graphics.push('all')
    love.graphics.setColor(lume.hsl(0.07, 0.64, 0.75, 1.00))
    love.graphics.setFont(font)
    love.graphics.translate(self.width / 2 -  (self.selected - 1) * self.colWidth, self.height / 2 + self.rowHeight)
    for k,column in ipairs(self.columns) do
      love.graphics.push()

      self:drawColumn(column, column == self.columns[math.floor(self.selected + .5)])
      love.graphics.pop()
      love.graphics.translate(self.colWidth, 0)
    end
  love.graphics.pop()
  --love.graphics.print(string.format('self.selected=%2.1f #columns=%d', self.selected, #self.columns), 0,0)
end

function module:update(dt)
  local cursor, target
  -- align columns and rows to grid
  local colSelected = self.columns[math.floor(self.selected + .5)]
  if not love.mouse.isDown(1) and #love.touch.getTouches() == 0 then
    cursor = self.selected
    target = math.floor(cursor + .5)
    self.selected = cursor + (target - cursor) * 5 * dt
    if colSelected then
      cursor = colSelected.selected
      target = math.floor(cursor + .5)
      colSelected.selected = cursor + (target - cursor) * 2 * dt
    end
  end
  -- recalculate column contents
  for i, column in ipairs(self.columns) do
    local rowSelected = math.floor(column.selected + .5)
    if type(column.tree[rowSelected]) == 'table' then
      if not self.columns[i+1] then
        self.columns[i+1] = newColumn(column.tree[rowSelected])
      else
        if self.columns[i+1].tree ~= column.tree[rowSelected] then
          self.columns[i+1].selected = 2
        end
        self.columns[i+1].tree = column.tree[rowSelected]
      end
    elseif type(column.tree[rowSelected]) == 'number' then
      if not self.columns[i+1] then
        self.columns[i+1] = newColumn({})
        self.columns[i+1].selected = 2
      end
      self.columns[i+1].tree = {' +', '', ' -'}
      self.columns[i+2] = nil
      break -- no more columns after this one
    else
      self.columns[i+1] = nil
      break
    end
    if i ~= math.floor(self.selected + .5) then
      column.selected = rowSelected
    end
  end
  -- propagate set value to column on the left
  local colSelected = self.columns[math.floor(self.selected + .5)]
  local leftOfSelected = self.columns[math.floor(self.selected - .5)]
  if leftOfSelected and leftOfSelected.tree then
    local row = math.floor(leftOfSelected.selected + .5)
    if type(leftOfSelected.tree[row]) == 'number' and math.abs(2 - colSelected.selected) > .05 then
      local delta = dt * 2^(math.abs(2 - colSelected.selected)) / 500 * (2 - colSelected.selected) / math.abs(2 - colSelected.selected)
      leftOfSelected.tree[row] = leftOfSelected.tree[row] + delta
      --print(delta, leftOfSelected.tree[row])
    end
  end
end

function module:touchmoved(id, x, y, dx, dy, pressure)
  if math.abs(dx) > 30 or math.abs(dy) > 30 then return end
  self.selected = self.selected - 5 * dx / self.width
  local colSelected = self.columns[math.floor(self.selected + .5)]
  if colSelected then
    colSelected.selected = colSelected.selected - 8 * dy / self.height
    if math.floor(self.selected + 5 * dx / self.width + .5) ~= math.floor(self.selected + .5) then
      love.graphics.setBlendMode('replace')
      love.graphics.setCanvas(self.renderer.canvas)
      love.graphics.setColor(0,0,0,0)
      love.graphics.rectangle('fill', 0, 0, self.renderer.width, self.renderer.height)
      --self.renderer.stroke = self.renderer.stroke * 100
      --self.renderer:draw({'tint', {0, 0, 0, 0}, {'position', {0, 100}, {'edge'}}}, .01)
      --self.renderer.stroke = self.renderer.stroke / 100
      love.graphics.setCanvas()
      love.graphics.setBlendMode('alpha')
    end
  end
end

return module