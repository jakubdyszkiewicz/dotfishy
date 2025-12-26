local base = dofile(hs.configdir .. "/base.lua")

-- Empty hyper keys: W, Q (buggy), space, numbers, FX

-- Application mappings
appMaps = {
	f = 'Google Chrome',
	c = 'ChatGPT',
	m = 'Messenger',
	v = 'Visual Studio Code',
	a = 'Discord',
	s = 'Slack',
	e = 'Goland',
	r = 'ForkLift',
	d = 'iTerm',
	b = 'Bear',
	z = 'Spotify',
	t = 'Things3',
  	x = 'Calendar'
}

hyperApps(appMaps)

hs.hotkey.bind(hyper, 'return', function()
	if hs.screen.mainScreen():name() == "Built-in Retina Display" then
		fullscreenAllWindows()
	else -- 4K 32" screen
		-- Left half
		adjustWindowsOfApp('Google Chrome', '0,0 3x2')
		adjustWindowsOfApp('Code', '0,0 3x2')
		adjustWindowsOfApp('GoLand', '0,0 3x2')

		-- Upper corner
		adjustWindowsOfApp('Spotify', '3,0 3x1')
		adjustWindowsOfApp('Bear', '3,0 3x1')
		adjustWindowsOfApp('Things', '3,0 3x1')
		adjustWindowsOfApp('Calendar', '3,0 3x1')
		
		-- Down corner
		adjustWindowsOfApp('Messenger', '3,2 3x1')
		adjustWindowsOfApp('Slack', '3,2 3x1')
		adjustWindowsOfApp('Discord', '3,2 3x1')
		adjustWindowsOfApp('iTerm2', '3,2 3x1')
	end
end)