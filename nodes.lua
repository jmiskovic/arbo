-- {edge, level, steepness}
edge      = 'edge'
-- {simplex, level, steepness}
simplex   = 'simplex'
-- {position, {dx, dy, rot, sx, sy, ox, oy, kx, ky}, arbo}
position  = 'position'
-- {camera, {dx, dy, rot, sx, sy, ox, oy, kx, ky}, arbo}
camera  = 'camera'
-- {wrap, arbo}
wrap      = 'wrap'
-- {unwrap, arbo}
unwrap      = 'unwrap'
-- {negate, arbo}
negate    = 'negate'
-- {clip, arbo1, arbo2, ...}
clip = 'clip'
-- {combine, arbo1, arbo2, ...}
combine      = 'combine'
-- {sum, arbo1, arbo2, ...}
sum       = 'sum'
-- {tint, {hue, saturation, lightness}, arbo}
tint      = 'tint'
-- {memo, arbo}
memo      = 'memo'
-- {set, table_index, new_value}
set       = 'set'
-- {interact, localState, arbo}
interact  = 'interact'