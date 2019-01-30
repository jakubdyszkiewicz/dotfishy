local log = hs.logger.new('mymodule','debug')

-- Settings
hs.window.animationDuration = 0.00

-- Keys
hyper = {'cmd', 'alt', 'ctrl', 'shift'}

-- Helper
function bindToHyper(keyFun)
	for key, fun in pairs(keyFun) do
		hs.hotkey.bind(hyper, key, function()
			fun()
		end)
	end
end

-- Application mappings
appMaps = {
	f = 'Google Chrome',
	c = 'Caprine',
	v = 'Visual Studio Code',
	a = 'HipChat',
	s = 'Slack',
	e = 'IntelliJ IDEA',
	r = 'ForkLift',
	d = 'iTerm',
	x = 'Bear',
  	z = 'Spotify'
}

for appKey, appName in pairs(appMaps) do
	hs.hotkey.bind(hyper, appKey, function()
		hs.application.launchOrFocus(appName)
	end)	
end

-- Hints
hs.hints.hintChars = {'A', 'S', 'D', 'J', 'K', 'L', 'Q', 'W', 'E', 'U', 'I', 'O'}
hs.grid.HINTS = {
	{ "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10" },
	{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "Q", "W", "E", "U", "I", "O", "U", "I", "O", "P" },
	{ "A", "S", "D", "J", "K", "L", "J", "K", "L", ";" },
	{ "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/" }
}
hs.hints.showTitleThresh = 0

hs.hotkey.bind(hyper, 'y', function()
	hs.hints.windowHints()
end)

-- Grid
hs.grid.setMargins(hs.geometry.size(0,0))
hs.grid.setGrid'6x2'

hs.hotkey.bind(hyper,'g',function()
	hs.grid.show()
end)

hs.hotkey.bind(hyper, 'b', function()
	hs.grid.snap(hs.window.focusedWindow())
end)

-- Tabs

hs.hotkey.bind(hyper, 'w', function()
	hs.eventtap.keyStroke({"cmd", "shift"}, "]")
end)

-- buggy, solve it!
-- hs.hotkey.bind(hyper, 'q', function()
-- 	hs.eventtap.keyStroke({"cmd", "shift"}, "]")
-- end)

-- Resize
hs.hotkey.bind(hyper, 'p', function() hs.grid.set(hs.window.focusedWindow(), '0,0, 4x2') end)
hs.hotkey.bind(hyper, '[', function() hs.grid.set(hs.window.focusedWindow(), '4,0, 2x1') end)
hs.hotkey.bind(hyper, ']', function() hs.grid.set(hs.window.focusedWindow(), '4,2, 2x1') end)
hs.hotkey.bind(hyper, ';', function() hs.grid.set(hs.window.focusedWindow(), '0,0 3x2') end)
hs.hotkey.bind(hyper, "'", function() hs.grid.set(hs.window.focusedWindow(), '3,0 3x2') end)
hs.hotkey.bind(hyper, "\\", hs.grid.maximizeWindow)

-- Move
hs.hotkey.bind(hyper, 'tab', function()
	local win = hs.window.focusedWindow()
	local nextScreen = win:screen():next()
	win:moveToScreen(nextScreen)
end)

-- Flow
hs.hotkey.bind(hyper, 'return', function()
	if hs.screen.mainScreen():name() == "Color LCD" then
		adjustWindowsOfApp('iTerm2', '0,0 6x2')
		adjustWindowsOfApp('Spotify', '0,0 6x2')
		adjustWindowsOfApp('Google Chrome', '0,0 6x2')
		adjustWindowsOfApp('Code', '0,0 6x2')
		adjustWindowsOfApp('IntelliJ IDEA', '0,0 6x2')
		adjustWindowsOfApp('Android Studio', '0,0 6x2')
		adjustWindowsOfApp('Caprine', '4,1 2x1')
		adjustWindowsOfApp('Slack', '3,1 3x1')
		adjustWindowsOfApp('HipChat', '3,1 3x1')
		adjustWindowsOfApp('Activity Monitor', '4,0 2x1')
	else
		adjustWindowsOfApp('iTerm2', '0,0 4x2')
		adjustWindowsOfApp('Spotify', '0,0 4x2')
		adjustWindowsOfApp('Google Chrome', '0,0 4x2')
		adjustWindowsOfApp('Code', '0,0 4x2')
		adjustWindowsOfApp('IntelliJ IDEA', '0,0 4x2')
		adjustWindowsOfApp('Android Studio', '0,0 4x2')
		adjustWindowsOfApp('Caprine', '4,1 2x1')
		adjustWindowsOfApp('Slack', '4,1 2x1')
		adjustWindowsOfApp('HipChat', '4,1 2x1')
		adjustWindowsOfApp('Activity Monitor', '4,0 2x1')
	end
end)

function adjustWindowsOfApp(appName, gridSettings)
	local app = hs.application.get(appName)
	local wins
	if app then
		wins = app:allWindows()
	end
	if wins then
		for i, win in ipairs(wins) do
			hs.grid.set(win, gridSettings)
		end
	end
end

function macbookScreen()
	return hs.screen.find('Color LCD')
end

function dell27()
	return hs.screen.find('DELL U2715H')
end

-- Mouse
function scrollUp()
	hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
	hs.eventtap.scrollWheel({0, 40}, {}, 'pixel')
end
hs.hotkey.bind(hyper, 'i', scrollUp, nil, scrollUp)

function scrollDown()
	hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
	hs.eventtap.scrollWheel({0, -40}, {}, 'pixel')
end
hs.hotkey.bind(hyper, 'u', scrollDown, nil, scrollDown)

-- Reload config
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()