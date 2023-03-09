local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local utils = require("yalm.lib.utils")

local function add_category(global_settings, settings_key, name)
	if utils.find(global_settings[settings_key], name) then
		Write.Error("\at%s already exists", name)
		return
	end

	Write.Info("Adding \at%s\ax to %s", name, settings_key)

	table.insert(global_settings[settings_key], name)
	settings.update_and_save_global_settings(global_settings, settings_key, { name })
end

local function add_preference(global_settings, settings_key, name)
	if utils.find(global_settings[settings_key], name) then
		Write.Error("\at%s already exists", name)
		return
	end

	Write.Info("Adding \at%s\ax to %s", name, settings_key)

	local rule = {
		[name] = {
			name = name,
			leave = false,
		},
	}

	settings.update_and_save_global_settings(global_settings, settings_key, rule)
end

local function add_rule(global_settings, settings_key, name)
	if utils.find(global_settings[settings_key], name) then
		Write.Error("\at%s already exists", name)
		return
	end

	Write.Info("Adding \at%s\ax to %s", name, settings_key)

	local rule = {
		[name] = {
			category = "",
			name = name,
			conditions = {},
			items = {},
		},
	}

	settings.update_and_save_global_settings(global_settings, settings_key, rule)
end

local function action(type, subcommands, global_settings, char_settings, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]

	local settings_key = configuration.types[type].settings_key

	if settings_key == configuration.types.category.settings_key then
		add_category(global_settings, settings_key, name)
	elseif settings_key == configuration.types.preference.settings_key then
		add_preference(global_settings, settings_key, name)
	elseif settings_key == configuration.types.rule.settings_key then
		add_rule(global_settings, settings_key, name)
	end
end

return { action_func = action }
