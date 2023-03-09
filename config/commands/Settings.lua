local configuration = require("yalm.config.configuration")

local valid_subcommands = {
	edit = {
		args = "",
		help = "Opens the global settings file in your preferred editor",
	},
	help = {},
	set = {},
}

local function action(global_settings, char_settings, args)
	configuration.action(valid_subcommands, global_settings, char_settings, configuration.types.setting.name, args)
end

return { action_func = action }
