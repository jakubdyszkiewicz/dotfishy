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
	c = 'Messenger',
	v = 'Visual Studio Code',
	a = 'HipChat',
	s = 'Slack',
	e = 'Goland',
	r = 'ForkLift',
	d = 'iTerm',
	b = 'Bear',
	z = 'Spotify',
	t = 'Todoist',
  	x = 'Calendar'
}

for appKey, appName in pairs(appMaps) do
	hs.hotkey.bind(hyper, appKey, function()
		hs.application.launchOrFocus(appName)
	end)	
end

-- Grid
hs.grid.setMargins(hs.geometry.size(0,0))
hs.grid.setGrid('6x2')

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
function switchAudio(name)
	hs.alert('Switching to: ' .. name)
	device = hs.audiodevice.findDeviceByName(name)
	if device ~= nil then
		device:setDefaultOutputDevice()
	end
	hs.alert('Active: ' .. hs.audiodevice.current().name)
end

hs.hotkey.bind(hyper, '1', function()
	switchAudio('MacBook Pro Speakers')
	switchAudio('Built-in Output')
end)

hs.hotkey.bind(hyper, '2', function()
	hs.alert('WH-1000XM3')
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
	switchAudio('External Headphones')
end)

hs.hotkey.bind(hyper, '4', function()
	switchAudio('(8D)Logitech Adapter')
end)

hs.hotkey.bind(hyper, '5', function()
	switchAudio('Scarlett 2i2 USB')
end)

-- Spotify +/-
hs.hotkey.bind(hyper, '-', hs.spotify.volumeDown)
hs.hotkey.bind(hyper, '=', hs.spotify.volumeUp)

-- Clicking on notifications
hs.hotkey.bind(hyper, '0', function()
	done = hs.osascript.applescript([[
my closeNotif()
on closeNotif()
	
	tell application "System Events"
		tell process "NotificationCenter"
			set theWindows to every window
			set this_item to item 1 of theWindows
			try
				click button 1 of this_item
			on error
				my closeNotif()
			end try
		end tell
	end tell
	
end closeNotif
	]])
end)

hs.hotkey.bind(hyper, '9', function()
	done = hs.osascript.applescript([[
my closeNotif()
on closeNotif()
	
	tell application "System Events"
		tell process "NotificationCenter"
			set theWindows to every window
			set this_item to item 1 of theWindows
			try
				click button 2 of this_item
			on error
				my closeNotif()
			end try
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
local sonyBluetoothDeviceID = '38-18-4c-19-2b-db'

function disconnectBluetooth(deviceID)
  hs.alert('Disconnecting Sonys')
  cmd = "/usr/local/bin/blueutil --disconnect "..(deviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function connectBluetooth(deviceID)
  hs.alert('Connecting Sonys')
  cmd = "/usr/local/bin/blueutil --connect "..(deviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function caffeinateCallback(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidSleep) then
	  disconnectBluetooth(sonyBluetoothDeviceID)
    elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
	  connectBluetooth(sonyBluetoothDeviceID)
    end
end

hs.hotkey.bind(hyper, '6', function()
	connectBluetooth(sonyBluetoothDeviceID)
end)

hs.hotkey.bind(hyper, '7', function()
	disconnectBluetooth(sonyBluetoothDeviceID)
end)

hs.hotkey.bind(hyper, '8', function()
	disconnectBluetooth(sonyBluetoothDeviceID)
	hs.timer.usleep(1000)
	connectBluetooth(sonyBluetoothDeviceID)
end)

hs.timer.doEvery(10, function()
    if (hs.audiodevice.current().device:balance() ~= 0.5) then
        hs.audiodevice.current().device:setBalance(0.5)
    end
end)

caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()

--- DEBUG
function printTable(result)
	for i,v in ipairs(result) do print(i,v) end
end

local open = io.open
local notiFile = "/tmp/test"

--- Notification from file tracking
local fileWatcher = hs.pathwatcher.new(notiFile, function(_, eventType)
	content = read_file(notiFile)
	if content~=nil then
		hs.notify.show(content, "", "")
		os.remove(notiFile)
	end
end)
fileWatcher:start()

local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then
		io.close(f)
		return true
	else
		return false
	end
end
