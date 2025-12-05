log = hs.logger.new('mymodule','debug')
-- example: log:i("test")

-- Settings
hs.window.animationDuration = 0.00

-- Keys
hyper = {'cmd', 'alt', 'ctrl', 'shift'}

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

-- Resize
hs.hotkey.bind(hyper, 'p', function() hs.grid.set(hs.window.focusedWindow(), '0,0, 3x1') end)
hs.hotkey.bind(hyper, 'o', function() hs.grid.set(hs.window.focusedWindow(), '0,2, 3x1') end)
hs.hotkey.bind(hyper, '[', function() hs.grid.set(hs.window.focusedWindow(), '3,0, 3x1') end)
hs.hotkey.bind(hyper, ']', function() hs.grid.set(hs.window.focusedWindow(), '3,2, 3x1') end)
hs.hotkey.bind(hyper, ';', function() hs.grid.set(hs.window.focusedWindow(), '0,0 3x2') end)
hs.hotkey.bind(hyper, "'", function() hs.grid.set(hs.window.focusedWindow(), '3,0 3x2') end)
hs.hotkey.bind(hyper, "\\", hs.grid.maximizeWindow)

-- Move
hs.hotkey.bind(hyper, 'tab', function()
	local win = hs.window.focusedWindow()
	local nextScreen = win:screen():next()
	win:moveToScreen(nextScreen)
end)

-- Flow (general)
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

-- Flow (dev)
hs.hotkey.bind(hyper, '0', function()
	adjustWindowsOfApp('Code', '0,0 3x2')
	adjustWindowsOfApp('GoLand', '0,0 3x2')
	adjustWindowsOfApp('iTerm2', '3,0 3x2')
	adjustWindowsOfApp('Google Chrome', '3,0 3x2')

	focusIfLaunched('iTerm2')
	focusIfLaunched('GoLand')
end)

function fullscreenAllWindows()
	for i, win in ipairs(hs.window:allWindows()) do
		hs.grid.set(win, '0,0 6x4')
	end
end

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

function focusIfLaunched(appName)
	local app = hs.application.get(appName)
	if app then
		app:activate()
	end
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

-- Audio
function switchAudio(name)
	local task = hs.task.new(
    "/opt/homebrew/bin/SwitchAudioSource",
    function(exitCode, stdOut, stdErr)
      if exitCode == 0 then
        hs.alert("Switched audio to "..name)
      else
        hs.alert("Failed to switch audio to "..name)
      end
    end,
    {"-s", name}
  )

  task:start()
end

function connectBluetooth(deviceID, deviceName, successCallback)
	local task = hs.task.new(
    "/opt/homebrew/bin/blueutil",
    function(exitCode, stdOut, stdErr)
      if exitCode == 0 then
        hs.alert("Connected Bluetooth device: "..deviceName)
		successCallback()
      else
        hs.alert("Failed to connect Bluetooth device: "..deviceName)
		hs.printf("blueutil error: %s", stdErr)
      end
    end,
    {"--connect", deviceID}
  )

  task:start()
end

function disconnectBluetooth(deviceID)
	local task = hs.task.new(
    "/opt/homebrew/bin/blueutil",
    function(exitCode, stdOut, stdErr)
      if exitCode ~= 0 then
		hs.printf("blueutil error: %s", stdErr)
      end
    end,
    {"--disconnect", deviceID}
  )

  task:start()
end

local sonyBluetoothDeviceID = '38-18-4c-19-2b-db'
local airPodsBluetoothDeviceID = '18-3f-70-52-5a-09'

hs.hotkey.bind(hyper, '1', function()
	switchAudio('MacBook Pro Speakers')
	disconnectBluetooth(airPodsBluetoothDeviceID)
	disconnectBluetooth(sonyBluetoothDeviceID)
end)

hs.hotkey.bind(hyper, '2', function()
	connectBluetooth(airPodsBluetoothDeviceID, 'AirPods', function() switchAudio('Jacob’s AirPods Pro') end)
	disconnectBluetooth(sonyBluetoothDeviceID)
end)

hs.hotkey.bind(hyper, '3', function()
	connectBluetooth(sonyBluetoothDeviceID, 'WH-1000XM3', function() switchAudio('WH-1000XM3') end)
	disconnectBluetooth(airPodsBluetoothDeviceID)
end)


-- Spotify +/-
hs.hotkey.bind(hyper, '-', hs.spotify.volumeDown)
hs.hotkey.bind(hyper, '=', hs.spotify.volumeUp)

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

local audioBeforeSleep = ''
function caffeinateCallback(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidSleep) then
	    audioBeforeSleep = hs.audiodevice.current().name
	    disconnectBluetooth(sonyBluetoothDeviceID)
    elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
		if audioBeforeSleep == 'WH-1000XM3' then
	    	connectBluetooth(sonyBluetoothDeviceID, 'WH-1000XM3', function() switchAudio('WH-1000XM3') end)
		end
    end
end

-- Fix for MacOS behavior of messing up balance of bluetooth headphones
hs.timer.doEvery(60, function()
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

--- Notification from file tracking
local fileWatcher = hs.pathwatcher.new(notiFile, function(_, eventType)
	content = read_file(notiFile)
	if content~=nil then
		hs.notify.show(content, "", "")
		os.remove(notiFile)
	end
end)
fileWatcher:start()