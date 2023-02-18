local configuration = require("yalm.config.configuration")

local command = {}

command.help = function(global_settings, char_settings, type, args)
	Write.Help("\at[\ax\ay/yalm condition help\ax\at]\ax")
	Write.Help("\axSubcommands Available:")
	Write.Help("\t  \ayhelp\ax -- Display this help output")
	Write.Help("\t  \aycreate <name>\ax -- Creates a new condition with the given name")
	Write.Help("\t  \aydelete <name>\ax -- Deletes a condition with the given name")
	Write.Help("\t  \ayset <setting> <value>\ax -- Updates setting to the given value")
	Write.Help("\axSettings Available:")
end

command.valid_subcommands = {
	["help"] = {
		func = command.help,
	},
	["create"] = {},
	["delete"] = {},
	["list"] = {},
	["set"] = {},
}

local function action(global_settings, char_settings, args)
	configuration.action(command, global_settings, char_settings, configuration.types.condition.name, args)
end

return { action_func = action }
