local module = {}

function module.new(width, height, scene)
  local instance = setmetatable(
    {
      width = width,
      height = height,
      selected = nil,
      columns = {},
      parents = {},
      scene = scene,
    }, {__index=module})
  font = love.graphics.newFont('fonts/coolstory.ttf', width / 20)
  instance.colWidth = width / 5
  instance.rowHeight = font:getHeight()
  updateParents(scene, instance.parents)
  instance.columns[1] = newColumn(scene)
  instance.renderer = require('renderer').new(instance.colWidth, instance.colWidth)
  instance.renderer.stroke = 10 --instance.colWidth / 50
  return instance
end

function module.draw()
end

function module.update(dt)
end

function module.touchmoved(id, x, y, dx, dy, pressure)
end

return module