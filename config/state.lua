local version = "0.9.2"

local state = {
	terminate = false,
	command_running = nil,
	ui = {
		main = {
			title = ("Yet Another Loot Manager (v%s)###yalm"):format(version),
			open_ui = true,
			draw_ui = true,
		},
	},
	version = version,
}

return state
