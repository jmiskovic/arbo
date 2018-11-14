function love.conf(t)
  local resolutions = {
    [0] = {640, 360},
    [1] = {854, 480},
    [2] = {1024, 576},
    [3] = {1280, 720},  -- most common Android resolution
    [4] = {1280, 768},  -- Nexus4
    [5] = {1600, 900},
    [6] = {1920, 1080}, -- most common desktop full screen
    [7] = {2960, 1440}, -- Samsung Galaxy S8
    [8] = {720, 1280},  -- most common Android resolution in portrait
  }
  t.window.title = "arbo"
  t.window.fullscreen = not false
  t.window.resizable = true
  t.window.vsync = false
  t.window.width, t.window.height = unpack(resolutions[0])
  t.window.x = 0
  love.filesystem.setIdentity('arbo')
end
