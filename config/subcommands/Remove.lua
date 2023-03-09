local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local utils = require("yalm.lib.utils")

local function remove_array(global_settings, settings_key, name)
	local index = utils.find(global_settings[settings_key], name)

	if not index then
		Write.Error("\at%s does not exist", name)
		return
	end

	Write.Info("Removing \at%s\ax from %s", name, settings_key)

	settings.remove_and_save_global_settings(global_settings, settings_key, index)
end

local function remove_table(global_settings, settings_key, name)
	if not global_settings[settings_key][name] then
		Write.Error("\at%s does not exist", name)
		return
	end

	Write.Info("Removing \at%s\ax from %s", name, settings_key)

	settings.remove_and_save_global_settings(global_settings, settings_key, name)
end

local function action(type, subcommands, global_settings, char_settings, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]

	local settings_key = configuration.types[type].settings_key

	if settings_key == configuration.types.category.settings_key then
		remove_array(global_settings, settings_key, name)
	else
		remove_table(global_settings, settings_key, name)
	end
end

return { action_func = action }
