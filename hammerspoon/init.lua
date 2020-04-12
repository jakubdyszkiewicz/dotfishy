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
	e = 'Goland',
	r = 'ForkLift',
	d = 'iTerm',
	x = 'Bear',
	z = 'Spotify',
	t = 'Todoist',
  	b = 'Calendar'
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

-- hs.hotkey.bind(hyper, 'b', function()
	-- hs.grid.snap(hs.window.focusedWindow())
-- end)

-- Tabs

hs.hotkey.bind(hyper, 'w', function()
	hs.eventtap.keyStroke({"cmd", "shift"}, "]")
end)

-- buggy, solve it!
hs.hotkey.bind(hyper, 'q', function()
	hs.eventtap.keyStroke({"cmd", "shift"}, "]")
end)

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
		adjustWindowsOfApp('GoLand', '0,0 6x2')
		adjustWindowsOfApp('Bear', '0,0 6x2')
		adjustWindowsOfApp('Android Studio', '0,0 6x2')
		adjustWindowsOfApp('Caprine', '4,1 2x1')
		adjustWindowsOfApp('Slack', '3,1 3x1')
		adjustWindowsOfApp('HipChat', '3,1 3x1')
		adjustWindowsOfApp('Activity Monitor', '4,0 2x1')
		adjustWindowsOfApp('Todoist', '4,0 2x1')
	else
		adjustWindowsOfApp('iTerm2', '0,0 4x2')
		adjustWindowsOfApp('Spotify', '0,0 4x2')
		adjustWindowsOfApp('Google Chrome', '0,0 4x2')
		adjustWindowsOfApp('Code', '0,0 4x2')
		adjustWindowsOfApp('GoLand', '0,0 4x2')
		adjustWindowsOfApp('Bear', '0,0 4x2')
		adjustWindowsOfApp('Android Studio', '0,0 4x2')
		adjustWindowsOfApp('Caprine', '4,1 2x1')
		adjustWindowsOfApp('Slack', '4,1 2x1')
		adjustWindowsOfApp('HipChat', '4,1 2x1')
		adjustWindowsOfApp('Activity Monitor', '4,0 2x1')
		adjustWindowsOfApp('Todoist', '4,0 2x1')
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

hs.hotkey.bind(hyper, 'y', function()
	hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
end)

hs.hotkey.bind(hyper, 'o', function()
	hs.eventtap.rightClick(hs.mouse.getAbsolutePosition())
end)


-- Audio
hs.hotkey.bind(hyper, '1', function()
	hs.audiodevice.findDeviceByName('MacBook Pro Speakers'):setDefaultOutputDevice()
end)

hs.hotkey.bind(hyper, '2', function()
	-- hs.audiodevice.findDeviceByName('WH-1000XM3'):setDefaultOutputDevice()
	-- there is some bug with Sonys to be selected. Fallback to applescript
	done = hs.osascript.applescript([[
tell application "System Events" to tell process "SystemUIServer"
	tell menu bar item 7 of menu bar 1
		click
		click menu item "WH-1000XM3" of menu 1
	end tell
end tell
	]])
end)

hs.hotkey.bind(hyper, '3', function()
	hs.audiodevice.findDeviceByName('External Headphones'):setDefaultOutputDevice()
end)

hs.hotkey.bind(hyper, '4', function()
	hs.audiodevice.findDeviceByName('(8D)Logitech Adapter'):setDefaultOutputDevice()
end)

hs.hotkey.bind(hyper, '5', function()
	hs.audiodevice.findDeviceByName('Scarlett 2i2 USB'):setDefaultOutputDevice()
end)

hs.hotkey.bind(hyper, '0', function()
	done = hs.osascript.applescript([[
my closeNotif()
on closeNotif()
	
	tell application "System Events"
		tell process "NotificationCenter"
			set theWindows to every window
			repeat with i from 1 to number of items in theWindows
				set this_item to item i of theWindows
				try
					click button 1 of this_item
				on error
					
					my closeNotif()
				end try
			end repeat
		end tell
	end tell
	
end closeNotif
	]])
end)

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




-- https://github.com/wangshub/hammerspoon-config/blob/master/headphone/headphone.lua
-- SONY MDR-1000X
local bleDeviceID = '38-18-4c-19-2b-db'


function bluetoothSwitch(state)
  -- state: 0(off), 1(on)
  cmd = "/usr/local/bin/blueutil --power "..(state)
  print(cmd)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function disconnectBluetooth()
  cmd = "/usr/local/bin/blueutil --disconnect "..(bleDeviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function connectBluetooth()
  cmd = "/usr/local/bin/blueutil --connect "..(bleDeviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function caffeinateCallback(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidSleep) then
      print("screensDidSleep")
	  disconnectBluetooth()
    elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
      print("screensDidWake")
	  connectBluetooth()
    elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
      print("screensDidLock")
    elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
      print("screensDidUnlock")
    end
end

hs.hotkey.bind(hyper, '9', function()
	disconnectBluetooth()
	hs.timer.usleep(1000)
	connectBluetooth()
end)

caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()
