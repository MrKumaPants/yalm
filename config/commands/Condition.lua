local configuration = require("yalm.config.configuration")

local command = {}

command.valid_subcommands = {
	help = {},
	create = {},
	delete = {},
	edit = {},
	list = {},
	set = {},
}

local function action(global_settings, char_settings, args)
	configuration.action(
		command.valid_subcommands,
		global_settings,
		char_settings,
		configuration.types.condition.name,
		args
	)
end

return { action_func = action }
