local module = {}

local icon = require('icon')

function replaceContent(table, newContent)
  local prevLength = #table
  -- parent[1], parent[2], parent[3] =
  --   'combine',
  --   {unpack(parent)},
  --   nil
  for k, v in pairs(newContent) do
    table[k] = v
  end
  for i = #newContent + 1, prevLength do
    table[i] = nil
  end
end

function module.new(width, height, root)
  local instance = setmetatable(
    {
      width = width,
      height = height,
      focus = {3, 3}, -- array of tree indices needed to reach focused node from root node
      columns = {},
      parents = {},
      root = root,
    }, {__index=module})
  instance.renderer = require('renderer').new(width, height, 20, .6)
  instance.icons = {}
  instance.icons.exit =  icon.new('exit',   -1, -1, function() love.event.quit() end)
  instance.icons.load =  icon.new('load',   -1, -3, function() love.keypressed('f5') end)
  instance.icons.store = icon.new('store',  -1, -2, function() love.keypressed('f2') end)

  instance.icons.swap = icon.new('swap'    , 1, 0,
    function(self, selected, parent)
      if parent[1] == 'simplex' then
        parent[1] = 'edge'
      elseif parent[1] == 'edge' then
        parent[1] = 'simplex'
      end
    end,
    function (self, selected, parent)
      return parent and (parent[1] == 'simplex' or parent[1] == 'edge')
    end)

  instance.icons.wrap = icon.new('wrap'    , 2, 0,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'wrap',
          {unpack(parent)},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)

  instance.icons.position = icon.new('position', 3, 0,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'position',
          {0,0,0,1,1},
          {unpack(parent)},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)

  instance.icons.tint = icon.new('tint'    , 4, 0,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'tint',
          {math.random(), .5, .5},
          {unpack(parent)},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)


  instance.icons.negate = icon.new('negate' , 5, 0,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'negate',
          {unpack(parent)},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)

  instance.icons.mirror = icon.new('mirror' , 6, 0,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'mirror',
          {unpack(parent)},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)

  instance.icons.combine = icon.new('combine' , 2, -1,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'combine',
          {unpack(parent)},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)

  instance.icons.clip = icon.new('clip' , 3, -1,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'clip',
          {unpack(parent)},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)

  instance.icons.smooth = icon.new('smooth' , 4, -1,
    function(self, selected, parent)
      replaceContent(parent,
        {
          'smooth',
          .5,
          {unpack(parent)},
          {'edge'},
        })
    end,
    function (self, selected, parent)
      return parent and type(parent[1]) == 'string'
    end)

  instance.icons.add = icon.new('add' , 0, -1,
    function(self, selected, parent)
      if type(parent) == 'table' and
          (parent[1] == 'clip' or parent[1] == 'combine') then
        for i,v in ipairs(parent) do
          if v == selected then
            table.insert(parent, i + 1, {'edge'})
            break
          end
        end
        --parent[#parent + 1] =
      end
    end,
    function (self, selected, parent)
      return parent and
        (parent[1] == 'combine' or parent[1] == 'clip') and
        selected
    end)

  instance.icons.del = icon.new('del' , 0, -2,
    function(self, selected, parent)
      if type(parent) == 'table' and #parent > 2 and
          (parent[1] == 'clip' or parent[1] == 'combine') then
        local startMove = false
        for i,v in ipairs(parent) do
          if v == selected and type(selected) == 'table' then
            startMove = true
          end
          if startMove then
            parent[i] = parent[i + 1]
          end
        end
      end
    end,
    function (self, selected, parent)
      return parent and
        (parent[1] == 'combine' or parent[1] == 'clip') and
        selected and type(selected) == 'table'
    end)

  instance.icons.snip = icon.new('snip'    , 0, -3,
    function(self, selected, parent)
      print('snip', type(selected), type(parent))
      if type(selected) == 'table' then
        local prevLength = #parent
        for k,v in pairs(selected) do
          parent[k] = v
          print(k,v)
        end
        for i = #selected + 1, prevLength do
          parent[i] = nil
        end
      end
    end,
    function (self, selected, parent)
      return parent and selected and
        type(selected) == 'table' and type(selected[1]) == 'string'
    end)

  return instance
end

function fetch(root, indices)
  local selection = root
  for level, index in ipairs(indices) do
    selection = selection[index]
  end
  return selection
end

function module:fetch(indices)
  return fetch(self.root, indices)
end

function module:draw()
  rayCount = self.renderer:draw(self.root, .01)
  love.graphics.setColor(1, 1, 1)
  --love.graphics.setClip)
  love.graphics.draw(self.renderer.canvas)
  --love.graphics.translate(200, 200)
end

function module:drawIcons()
  local selected, parent = editor:getSelected()
  for _,icon in pairs(self.icons) do
    -- TODO: really redundant to preform icon:check() on each frame
    -- should do it on selection change
    if not icon.check or icon:check(selected, parent) then
      icon:draw()
    end
  end
  love.graphics.reset()
end

function module:update(dt)
  --local selected, parent = editor:getSelected()
end

function module:mousereleased(x, y, button, istouch, presses)
  local selected, parent = editor:getSelected()
  for name,icon in pairs(self.icons) do
    if icon:contains(x,y) and icon.tapped then
      if not icon.check or icon:check(selected, parent) then
        icon:tapped(selected, parent)
        self.renderer:resetStroke()
      end
      --icon.holdoff = icon.tapped
      --icon.tapped = nil
      --love.timer.sleep(.2)
      break
    end
  end
end

function module.touchmoved(id, x, y, dx, dy, pressure)
end

return module