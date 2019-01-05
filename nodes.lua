-- {edge, level, steepness}
edge      = 'edge'
-- {simplex, level, steepness}
simplex   = 'simplex'
-- {position, {dx, dy, rot, sx, sy, ox, oy, kx, ky}, arbo}
position  = 'position'
-- {wrap, arbo}
wrap      = 'wrap'
-- {unwrap, yexp, arbo}
unwrap      = 'unwrap'
-- {negate, arbo}
negate    = 'negate'
-- {clip, arbo1, arbo2, ...}
clip = 'clip'
-- {combine, arbo1, arbo2, ...}
combine   = 'combine'
-- {sum, arbo1, arbo2, ...}
sum       = 'sum'
-- {smooth, softness, shape1, shape2}
smooth    = 'smooth'
-- {tint, {hue, saturation, lightness}, arbo}
tint      = 'tint'
-- {noise, {hue, saturation, lightness}, arbo}
noise     = 'noise'
-- {memo, arbo}
memo      = 'memo'
-- {set, table_index, new_value}
set       = 'set'
-- {interact, localState, arbo}
interact  = 'interact'