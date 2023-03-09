local configuration = require("yalm.config.configuration")

local valid_subcommands = {
	help = {},
	add = {},
	remove = {},
	list = {},
	set = {},
}

local function action(global_settings, char_settings, args)
	configuration.action(valid_subcommands, global_settings, char_settings, configuration.types.rule.name, args)
end

return { action_func = action }
