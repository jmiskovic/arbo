local module = {}

local lume = require('lume')

local font = nil

local sw, sh = love.graphics.getDimensions()
local screenRatio = sw / sh -- ranges from 1.7 to 2.1, typically 16/9 = 1.77

local previewScene =
{
  position,
  {0,0,0,.7},
  node
}

function module.new(width, height, scene)
  local instance = setmetatable(
    {
      width = width,
      height = height,
      selected = 1,
      columns = {},
      parents = {},
      scene = scene,
      canvases = {},
    }, {__index=module})
  font = love.graphics.newFont('fonts/coolstory.ttf', width / 20)
  instance.colWidth = width / 5
  instance.rowHeight = font:getHeight() * 2
  updateParents(scene, instance.parents, 1)
  instance.columns[1] = newColumn(scene)
  instance.renderer = require('renderer').new(instance.colWidth, instance.colWidth, 5, 1)
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

function module:getSelected()
  local column = self.columns[math.floor(self.selected + .5)]
  local parent = column and column.tree or nil
  local selected = parent and column.tree[math.floor(column.selected + .5)]
  return selected, parent
end

function module:preview(node, index)
  self.canvases[index] = self.canvases[index]
    or love.graphics.newCanvas(self.rowHeight * screenRatio, self.rowHeight)
  canvas = self.canvases[index]
  previewScene[3] = node
  self.renderer:draw(
    previewScene,
    .001,
    canvas)
  return canvas
end

function module:drawColumn(column, isSelected)
  local s = ''
  love.graphics.translate(0, -column.selected * self.rowHeight)

  for i,item in ipairs(column.tree) do
    -- select color
    local fg

    if isSelected then
      if i == math.floor(column.selected + .5) then
        fg = {lume.hsl(0.02, 0.32, 0.82, 1.00)}
      else
        fg = {lume.hsl(0.02, 0.34, 0.34, 1.00)}
      end
    else
      fg = {lume.hsl(0.93, 0.22, 0.20, 1.00)}
    end
    local bg = {fg[1] * .3, fg[2] * .3, fg[3] * .3}

    if isSelected and type(item) == 'table' and type(item[1]) == 'string' then
      s = ''
      love.graphics.push('all')
      love.graphics.setLineWidth(self.rowHeight / 10)
      love.graphics.translate(0, 1.5 * self.rowHeight)
      local canvas = self:preview(item, i) -- here's the renderer
      love.graphics.translate(0, -2 * self.rowHeight)
      love.graphics.setColor(1,1,1)
      love.graphics.draw(canvas)
      if i == math.floor(column.selected + .5) then
        love.graphics.setColor(lume.hsl(0.02, 0.32, 0.82))
        love.graphics.rectangle('fill', 0, 0, self.rowHeight/5, self.rowHeight)
      end
      love.graphics.pop()
    elseif type(item) == 'table' then
      s = string.format('%d{', #item)
    elseif type(item) == 'number' then
      s = string.format('%+1.4f', item)
    elseif type(item) == nil then
      s = string.format('nil')
    else
      s = tostring(item)
    end
    love.graphics.push()
    love.graphics.setColor(bg)
    love.graphics.print(s, 0 + self.rowHeight / 50, -self.rowHeight / 2 + self.rowHeight / 50)
    love.graphics.print(s, 0 - self.rowHeight / 50, -self.rowHeight / 2 + self.rowHeight / 50)
    love.graphics.print(s, 0 + self.rowHeight / 50, -self.rowHeight / 2 - self.rowHeight / 50)
    love.graphics.print(s, 0 - self.rowHeight / 50, -self.rowHeight / 2 - self.rowHeight / 50)
    love.graphics.setColor(fg)
    love.graphics.print(s, 0, -self.rowHeight / 2)
    love.graphics.pop()
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
  if not love.mouse.isDown(1) and #love.touch.getTouches() == 0 then
    cursor = self.selected
    target = math.floor(cursor + .5)
    self.selected = cursor + (target - cursor) * 5 * dt
    local colSelected = self.columns[math.floor(self.selected + .5)]
    if colSelected then
      cursor = colSelected.selected
      target = math.floor(cursor + .5)
      target = math.min(#colSelected.tree, math.max(1, target))
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
      self.columns[i+1].tree = {}
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
end

function module:touchmoved(id, x, y, dx, dy, pressure)
  if #love.touch.getTouches() == 1 then
    if math.abs(dx) > 30 or math.abs(dy) > 30 then return end
    self.selected = self.selected - 10 * dx / self.width
    local colSelected = self.columns[math.floor(self.selected + .5)]
    if colSelected then
      colSelected.selected = colSelected.selected - 8 * dy / self.height
    else -- undo change
      self.selected = self.selected + 15 * dx / self.width
    end
  end
end

function module:pinchmoved(dx, dy, drot, dscl)
  local colSelected = self.columns[math.floor(self.selected + .5)]
  local rowSelected = colSelected and colSelected.tree[math.floor(colSelected.selected + .5)]
  if colSelected then
    if colSelected.tree[1] == 'position' then
      colSelected.tree[2][1] = (colSelected.tree[2][1] or 0) + dx
      colSelected.tree[2][2] = (colSelected.tree[2][2] or 0) + dy
      colSelected.tree[2][3] = (colSelected.tree[2][3] or 0) + drot
      colSelected.tree[2][4] = (colSelected.tree[2][4] or 1) * dscl
      if colSelected.tree[2][5] then
        colSelected.tree[2][5] = colSelected.tree[2][5] * dscl
      end
    elseif colSelected.tree[1] == 'tint' then
      local maxScalarProjection, maxI = 0, 1
      local axes = {
                     {   1, 0},              -- hue
                     {-1/2, math.sqrt(3)/2}, -- saturation
                     { 1/2, math.sqrt(3)/2}, -- lightness
                   }
      for i,axis in ipairs(axes) do
        local sp = lume.scalarProj(dx, dy, unpack(axis))
        if math.abs(sp) > math.abs(maxScalarProjection) then
          maxScalarProjection, maxI = sp, i
        end
      end
      local color = colSelected.tree[2]
      color[maxI] = (color[maxI] or 1) + maxScalarProjection / 2
      color[1] = color[1] % 1
      color[2] = math.min(1, math.max(color[2]))
      color[3] = math.min(1, math.max(color[3]))
    elseif type(rowSelected) == 'number' then
      colSelected.tree[math.floor(colSelected.selected + .5)] = rowSelected + 2 * drot
    elseif self.scene[1] == 'position' then
      self.scene[2][1] = (self.scene[2][1] or 0) + dx
      self.scene[2][2] = (self.scene[2][2] or 0) + dy
      self.scene[2][3] = (self.scene[2][3] or 0) + drot
      self.scene[2][4] = (self.scene[2][4] or 1) * dscl
      if self.scene[2][5] then
        self.scene[2][5] = self.scene[2][5] * dscl
      end
    end
  end
end

return module