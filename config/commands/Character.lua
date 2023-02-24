local configuration = require("yalm.config.configuration")

local command = {}

command.help = function(global_settings, char_settings, type, args)
	Write.Help("\at[\ax\ay/yalm char help\ax\at]\ax")
	Write.Help("\axSubcommands Available:")
	Write.Help("\t  \ayhelp\ax -- Display this help output")
	Write.Help("\t  \ayset <setting> <value>\ax -- Updates setting to the given value")
	Write.Help("\axSettings Available:")
end

command.valid_subcommands = {
	["help"] = {
		func = command.help,
	},
	["set"] = {},
}

local function action(global_settings, char_settings, args)
	configuration.action(
		command.valid_subcommands,
		global_settings,
		char_settings,
		configuration.types.character.name,
		args
	)
end

return { action_func = action }
