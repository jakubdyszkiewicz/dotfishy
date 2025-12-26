hyper = {'cmd', 'alt', 'ctrl', 'shift'}

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

function fullscreenAllWindows()
	for i, win in ipairs(hs.window:allWindows()) do
		hs.grid.set(win, '0,0 6x4')
	end
end

function hyperApps(appMaps)
    for appKey, appName in pairs(appMaps) do
        hs.hotkey.bind(hyper, appKey, function()
            hs.application.launchOrFocus(appName)
        end)
    end
end