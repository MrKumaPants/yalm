local configuration = require("yalm.config.configuration")

local command = {}

command.help = function(global_settings, char_settings, args)
	Write.Help("\at[\ax\ay/yalm condition help\ax\at]\ax")
	Write.Help("\axSubcommands Available:")
	Write.Help("\t  \ayhelp\ax -- Display this help output")
	Write.Help("\t  \aycreate <name>\ax -- Creates a new condition with the given name")
	Write.Help("\t  \aydelete <name>\ax -- Deletes a condition with the given name")
	Write.Help("\t  \ayset <setting> <value>\ax -- Updates setting to the given value")
	Write.Help("\axSettings Available:")
end

command.create = function(global_settings, char_settings, args)
	configuration.create(global_settings, configuration.types.condition.name, args)
end

command.delete = function(global_settings, char_settings, args)
	configuration.delete(global_settings, configuration.types.condition.name, args)
end

command.set = function(global_settings, char_settings, args)
	return
end

command.valid_subcommands = {
	["help"] = {
		func = command.help,
	},
	["create"] = {
		func = command.create,
	},
	["delete"] = {
		func = command.delete,
	},
	["set"] = {
		func = command.set,
	},
}

local function action(global_settings, char_settings, args)
	configuration.action(global_settings, char_settings, args, command)
end

return { action_func = action }
