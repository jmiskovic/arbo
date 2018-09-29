local lastIndex = 0

local function exportWalk(node)
  local index = lastIndex + 1
  lastIndex = index
  local conns = {}
  local label = node[1]
  for i, child in ipairs(node) do
    if i ~= 1 then
      if type(child) == 'table' then
        childIndex, childConns = exportWalk(child)
        for i,v in ipairs(childConns) do
          table.insert(conns, {v[1], v[2]})
        end
        table.insert(conns, {index, childIndex})
      else
        label = label .. ', ' .. child
      end
    end
  end
  print(index, label)
  return index, conns
end

local function export(scene)
  local childIndex, childConns = exportWalk(scene, 0)
  print('#')
  for i, conn in ipairs(childConns) do
    print(conn[1], conn[2])
  end
end

return {
  export= export,
}