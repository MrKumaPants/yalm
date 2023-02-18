local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local loader = require("yalm.core.loader")

local utils = require("yalm.lib.utils")
local inspect = require("yalm.lib.inspect")

local command = {}

command.help = function(global_settings, char_settings, type, args)
	Write.Help("\at[\ax\ay/yalm rule help\ax\at]\ax")
	Write.Help("\axSubcommands Available:")
	Write.Help("\t  \ayhelp\ax -- Display this help output")
	Write.Help("\t  \ayadd <name>\ax -- Creates a new rule with the given name")
	Write.Help("\t  \ayremove <name>\ax -- Deletes a rule with the given name")
	Write.Help("\t  \ayset <setting> <value>\ax -- Updates setting to the given value")
	Write.Help("\axSettings Available:")
end

command.add = function(global_settings, char_settings, type, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]
	local loader_type = loader.types.categories

	if utils.find(global_settings[loader_type], name) then
		Write.Error("\at%s already exists", name)
	end

	Write.Info("Adding \at%s\ax to %s", name, loader_type)

	table.insert(global_settings[loader_type], name)
	settings.update_and_save_global_settings(global_settings, loader_type, global_settings[loader_type])
end

command.remove = function(global_settings, char_settings, type, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]
	local loader_type = loader.types.categories
	local index = utils.find(global_settings[loader_type], name)

	if index < 0 then
		Write.Error("\at%s does not exist", name)
	end

	Write.Info("Removing \at%s\ax from %s", name, loader_type)

	settings.remove_and_save_global_settings(global_settings, loader_type, index)
end

command.valid_subcommands = {
	["help"] = {
		func = command.help,
	},
	["add"] = {
		func = command.add,
	},
	["remove"] = {
		func = command.remove,
	},
	["list"] = {},
}

local function action(global_settings, char_settings, args)
	configuration.action(command, global_settings, char_settings, configuration.types.category.name, args)
end

return { action_func = action }
