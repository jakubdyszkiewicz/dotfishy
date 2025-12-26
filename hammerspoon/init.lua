log = hs.logger.new('mymodule','debug')
-- example: log:i("test")

-- Settings
hs.window.animationDuration = 0.00

-- Keys
hyper = {'cmd', 'alt', 'ctrl', 'shift'}

local function readProfile()
    local path = os.getenv("HOME") .. "/.dotfishy/profile"
    local f = io.open(path, "r")
    if not f then return nil end
    local value = f:read("*l")
    f:close()
    return value
end

local profile = readProfile()

if profile == "work" then
	dofile(hs.configdir .. "/work.lua")
end
if profile == "priv" then
	dofile(hs.configdir .. "/priv.lua")
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