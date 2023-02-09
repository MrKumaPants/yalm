local configuration = require("yalm.config.configuration")

local command = {}

command.Help = function(loot, char_settings, global_settings, args)
	Write.Help("\at[\ax\ay/yalm condition help\ax\at]\ax")
	Write.Help("\axSubcommands Available:")
	Write.Help("\t  \ayhelp\ax -- Display this help output")
	Write.Help("\t  \aycreate <name>\ax -- Creates a new condition with the given name")
	Write.Help("\t  \aydelete <name>\ax -- Deletes a condition with the given name")
	Write.Help("\t  \ayset <setting> <value>\ax -- Updates setting to the given value")
	Write.Help("\axSettings Available:")
end

command.Create = function(loot, char_settings, global_settings, args)
	configuration.create(loot, configuration.types.condition.name, args)
end

command.Delete = function(loot, char_settings, global_settings, args)
	configuration.delete(loot, configuration.types.condition.name, args)
end

command.Set = function(loot, char_settings, global_settings, args)
	return
end

command.valid_subcommands = {
	["help"] = {
		func = command.Help,
	},
	["create"] = {
		func = command.Create,
	},
	["delete"] = {
		func = command.Delete,
	},
	["set"] = {
		func = command.Set,
	},
}

local function action(loot, char_settings, global_settings, args)
	configuration.action(loot, char_settings, global_settings, args, command)
end

return { action_func = action }
