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
  t.window.fullscreen = false
  t.window.resizable = true
  t.window.vsync = false
  t.window.width, t.window.height = unpack(resolutions[3])
  love.filesystem.setIdentity('arbo')
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

