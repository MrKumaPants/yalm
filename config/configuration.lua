---@type Mq
local mq = require("mq")

local loader = require("yalm.classes.loader")

local settings = require("yalm.config.settings")

local utils = require("yalm.lib.utils")

local configuration = {
	types = {
		condition = {
			name = "condition",
			loader_type = loader.types.commands,
			settings = {
				category = "string",
			},
		},
		command = {
			name = "command",
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
			loader_type = loader.types.rules,
			settings = {
				category = "string",
			},
		},
	},
}

configuration.set = function(loot, type, args)
	return
end

configuration.create = function(loot, type, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]

	local template_name = "Condition.lua"
	local template_path = ("%s/yalm/templates/%s"):format(mq.luaDir, template_name)

	if not utils.FileExists(template_path) then
		Write.Error("No template file exists for \at%s\ax", template_path)
	end

	local loader_type = configuration.types[type].loader_type
	local destination_path = ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, loader_type, name)

	if utils.FileExists(destination_path) then
		Write.Warn("\ao%s\ax already exists", name)
		return
	end

	Write.Info("Creating \ao%s.lua\ax based off \ao%s\ax", name, template_name)
	utils.CopyFile(template_path, destination_path)

	local config = {
		[name] = {
			["name"] = name,
		},
	}

	if loader_type == loader.types.commands then
		config[name]["trigger"] = name:lower()
	end

	Write.Info("Adding \ao%s\ax to \ao%s\ax in settings", name, loader_type)
	settings.update_and_save_global_settings(loot, loader_type, config)
end

configuration.delete = function(loot, type, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]
	local loader_type = configuration.types[type].loader_type
	local destination_path = ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, loader_type, name)

	if not loot[loader_type][name] then
		Write.Error("\at%s\ax is not a valid %s name", name, type)
		return
	end

	Write.Info("Deleting \ao%s.lua\ax from \ao%s\ax", name, loader_type)
	utils.DeleteFile(destination_path)

	Write.Info("Deleting \ao%s\ax from \ao%s\ax in settings", name, loader_type)
	settings.remove_and_save_global_settings(loot, loader_type, name)
end

configuration.action = function(loot, char_settings, global_settings, args, command)
	if not args[2] then
		command.help.func(loot, char_settings, global_settings, args)
		return
	end

	local subcommand = args[2]

	if not command.valid_subcommands[subcommand] then
		Write.Error("\at%s\ax is not a valid subcommand", subcommand)
		return
	end

	command.valid_subcommands[subcommand].func(loot, char_settings, global_settings, args)
end

return configuration
