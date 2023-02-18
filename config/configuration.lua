---@type Mq
local mq = require("mq")

local settings = require("yalm.config.settings")

local loader = require("yalm.core.loader")

local utils = require("yalm.lib.utils")

local configuration = {
	types = {
		global = {
			name = "global",
			settings = {
				always_loot = "boolean",
				distribute_delay = "time",
				frequency = "time",
				save_slots = "number",
				unmatched_item_delay = "time",
				dannet_delay = "time",
				unmatched_item_rule = "string",
			},
		},
		category = {
			name = "category",
			loader_type = loader.types.categories,
		},
		character = {
			name = "character",
			settings = {
				always_loot = "boolean",
				distribute_delay = "time",
				frequency = "time",
				save_slots = "number",
				unmatched_item_delay = "time",
				dannet_delay = "time",
				unmatched_item_rule = "string",
			},
		},
		condition = {
			name = "condition",
			template = "Condition.lua",
			loader_type = loader.types.conditions,
			settings = {
				category = "string",
			},
		},
		command = {
			name = "command",
			template = "Command.lua",
			loader_type = loader.types.commands,
			settings = {
				args = "string",
				category = "string",
				help = "string",
				trigger = "string",
			},
		},
		rule = {
			name = "rule",
			template = "Rule.lua",
			loader_type = loader.types.rules,
			settings = {
				category = "string",
			},
		},
	},
}

configuration.action = function(command, global_settings, char_settings, type, args)
	if not args[2] then
		command.valid_subcommands.help.func(global_settings, char_settings, type, args)
		return
	end

	local subcommand = args[2]

	if not command.valid_subcommands[subcommand] then
		Write.Error("\at%s\ax is not a valid subcommand", subcommand)
		return
	end

	if command.valid_subcommands[subcommand].func then
		command.valid_subcommands[subcommand].func(global_settings, char_settings, type, args)
	elseif configuration[subcommand] then
		configuration[subcommand](global_settings, char_settings, type, args)
	else
		Write.Error("No function exists for \at%s\ax", subcommand)
	end
end

configuration.create = function(global_settings, char_settings, type, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]

	local template_name = configuration.types[type].template
	local template_path = ("%s/yalm/templates/%s"):format(mq.luaDir, template_name)

	if not utils.file_exists(template_path) then
		Write.Error("No template file exists for \at%s\ax", template_path)
	end

	local loader_type = configuration.types[type].loader_type
	local destination_path = ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, loader_type, name)

	if utils.file_exists(destination_path) then
		Write.Warn("\ao%s\ax already exists", name)
		return
	end

	Write.Info("Creating \ao%s.lua\ax based off \ao%s\ax", name, template_name)
	utils.copy_file(template_path, destination_path)

	local config = {
		[name] = {
			["name"] = name,
		},
	}

	if loader_type == loader.types.commands then
		config[name]["trigger"] = name:lower()
	end

	Write.Info("Adding \ao%s\ax to \ao%s\ax in settings", name, loader_type)
	settings.update_and_save_global_settings(global_settings, loader_type, config)
end

configuration.delete = function(global_settings, char_settings, type, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]
	local loader_type = configuration.types[type].loader_type
	local destination_path = ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, loader_type, name)

	if not global_settings[loader_type][name] then
		Write.Error("\at%s\ax is not a valid %s name", name, type)
		return
	end

	Write.Info("Deleting \ao%s.lua\ax from \ao%s\ax", name, loader_type)
	utils.delete_file(destination_path)

	Write.Info("Deleting \ao%s\ax from \ao%s\ax in settings", name, loader_type)
	settings.remove_and_save_global_settings(global_settings, loader_type, name)
end

configuration.edit = function(global_settings, char_settings, type, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]
	local loader_type = configuration.types[type].loader_type

	if not global_settings[loader_type][name] then
		Write.Error("\at%s\ax is not a valid \at%s\ax", name, configuration.types[type].name)
		return
	end

	local filename = loader.filename(name, loader_type)

	if not utils.file_exists(filename) then
		Write.Error("No file exists for \at%s\ax", name)
		return
	end

	os.execute(('start "" "%s"'):format(filename))
end

configuration.list = function(global_settings, char_settings, type, args)
	local loader_type = configuration.types[type].loader_type

	Write.Info("\axList of existing \at%s\ax:", loader_type)
	for _, value in pairs(global_settings[loader_type]) do
		if value.name then
			Write.Info("\t  %s", value.name)
		else
			Write.Info("\t  %s", value)
		end
	end
end

configuration.set = function(global_settings, char_settings, type, args)
	local type_settings = configuration.types[type].settings

	if not args[3] then
		Write.Error("No setting specified")
		return
	end

	local setting = args[3]

	if not type_settings[setting] then
		Write.Error("\ao%s\ax is not a valid setting for \ao%s\ax", setting, type)
		return
	end

	if not args[4] then
		Write.Error("No value specified")
		return
	end

	local value = args[4]

	if type(value) ~= type_settings[setting] then
		Write.Error("\ao%s\ax value must be a \ao%s\ax type", setting, type_settings[setting])
	end
end

return configuration
