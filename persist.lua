local persist = {}

local serpent = require('serpent')

function persist.print(data)
  print(serpent.dump(data, {
    comment= false,
    indent = '  ',
  }))
end

function persist.store(data, filename)
  local content = serpent.dump(data, {
      comment= false,
      numformat= '%.2f',
      indent = '  ',
    })
  success, message = love.filesystem.write(filename, content)
  if not success then
    print(message)
  else
    print('saved to', filename)
  end
end

function persist.load(filename)
  local content, errormsg = love.filesystem.read(filename)
  if not content then
    print(errormsg)
    return content
  end
  local ok, data = serpent.load(content, {safe=false})
  print('loaded from', filename)
  return data
end

function persist.list()
  print(love.filesystem.getAppdataDirectory()..love.filesystem.getIdentity())
  local files = love.filesystem.getDirectoryItems('.')
  --[[
  --]]
  print(#files)
  for k, v in pairs(files) do
    print(k,v)
  end
end

return persist