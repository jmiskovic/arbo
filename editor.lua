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
    }, {__index=module})
  font = love.graphics.newFont('fonts/coolstory.ttf', height / 12)
  updateParents(scene, instance.parents)
  instance.columns[1] = newColumn(scene)
  return instance
end

function newColumn(tree)
  local instance = {selected = 1, tree = tree} -- setmetatable(, {})
  return instance
end

function updateParents(node, parents)
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
      updateParents(child, parents)
    end
  end
end

function drawLabel(node)
  love.graphics.print(node[1], 50, 50)
end

--module:drawTint({0, {0, .5, .5, .4}})
function module:drawTint(node)
  love.graphics.push()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', -1, -1, 2, 2)
    --love.graphics.setColor(1,1,1)
    --love.graphics.rectangle('fill', -1, -1, 1, 1)
    --love.graphics.rectangle('fill', 0, 0, 1, 1)
    love.graphics.setColor(lume.hsl(unpack(node[2])))
    love.graphics.rectangle('fill', -1, -1, 2, 2)
  love.graphics.pop()
end



function module:drawColumn(column)
  local rowHeight = font:getHeight()
  local s = ''
  love.graphics.translate(0, -column.selected * rowHeight)
  for i,item in ipairs(column.tree) do
    -- select color
    local fg



    if column == self.columns[math.floor(self.selected + .5)] then
      if i == math.floor(column.selected + .5) then
        fg = {lume.hsl(0.36, 0.38, 0.39)}
      else
        fg = {lume.hsl(0.42, 0.42, 0.25)}
      end
    else
      fg = {lume.hsl(0.51, 0.43, 0.17)}
    end
    local bg = {fg[1] * .6, fg[2] * .6, fg[3] * .6}

    if type(item) == 'table' then
      s = string.format('  %s', type(item[1]) == 'string' and item[1] or '')
      if type(item) == 'table' then
        love.graphics.push('all')
        love.graphics.scale(1, .5)
        love.graphics.setLineWidth(rowHeight / 10)
        love.graphics.translate(font:getWidth(' '), -rowHeight/2)
        local span = rowHeight / #item
        love.graphics.setColor(fg)
        for i=1,#item do
          love.graphics.line(0, span / 5, font:getWidth(' ')/2, (i - 1) * span)
        end
        love.graphics.pop()
      end
    elseif type(item) == 'number' then
      s = string.format('%+1.2f', item)
    else
      s = tostring(item)
    end
    love.graphics.setColor(bg)
    love.graphics.print(s, 0 + 2, -rowHeight / 2 + 2)
    love.graphics.print(s, 0 - 2, -rowHeight / 2 + 2)
    love.graphics.print(s, 0 + 2, -rowHeight / 2 - 2)
    love.graphics.print(s, 0 - 2, -rowHeight / 2 - 2)
    love.graphics.setColor(fg)
    love.graphics.print(s, 0, -rowHeight / 2)
    love.graphics.translate(0, rowHeight)
  end
end

function module:draw()
  local colWidth = self.width / 4
  local rowHeight = font:getHeight()
  love.graphics.push('all')
    --love.graphics.setColor(lume.hsl(0.91, 0.41, 0.51, 0.20))
    --love.graphics.rectangle('fill', self.width / 2 - colWidth * .2, self.height / 2 - rowHeight * .65, colWidth, rowHeight)
    --love.graphics.rectangle('fill', 0, self.height / 2 - rowHeight  * .65, self.width, rowHeight)
    love.graphics.setColor(lume.hsl(0.07, 0.64, 0.75, 1.00))
    love.graphics.setFont(font)
    love.graphics.translate(self.width / 2 -  (self.selected - 1) * colWidth, self.height / 2 + rowHeight)
    for k,column in ipairs(self.columns) do
      love.graphics.push()
      self:drawColumn(column)
      love.graphics.pop()
      love.graphics.translate(colWidth, 0)
    end
  love.graphics.pop()
  --love.graphics.print(string.format('self.selected=%2.1f #columns=%d', self.selected, #self.columns), 0,0)
end

function module:update(dt)
  local colWidth = self.width / 4
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
          self.columns[i+1].selected = 1
        end
        self.columns[i+1].tree = column.tree[rowSelected]
      end
    elseif type(column.tree[rowSelected]) == 'number' then
      if not self.columns[i+1] then
        self.columns[i+1] = newColumn({})
        self.columns[i+1].selected = 2
      end
      self.columns[i+1].tree = {'  +', column.tree[rowSelected], '  -'}
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
    if type(leftOfSelected.tree[row]) == 'number' then
      leftOfSelected.tree[row] = leftOfSelected.tree[row] + dt * (2 - colSelected.selected) / 50
    end
  end
end

function module:touchmoved(id, x, y, dx, dy, pressure)
  if math.abs(dx) > 30 or math.abs(dy) > 30 then return end
  self.selected = self.selected - dx / 350
  local colSelected = self.columns[math.floor(self.selected + .5)]
  if colSelected then
    colSelected.selected = colSelected.selected - dy / 100
  end
  --self.y = self.y + dy
end

return module