---@type Mq
local mq = require("mq")

local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local utils = require("yalm.lib.utils")

local function action(type, subcommands, global_settings, char_settings, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]

	local template_path = ("%s/yalm/templates/%s.lua"):format(mq.luaDir, utils.title_case(type))

	if not utils.file_exists(template_path) then
		Write.Error("No template file exists for \at%s\ax", template_path)
	end

	local settings_key = configuration.types[type].settings_key
	local destination_path = ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, settings_key, name)

	if utils.file_exists(destination_path) then
		Write.Warn("\ao%s\ax already exists", name)
		return
	end

	Write.Info("Creating \ao%s.lua\ax", name)
	utils.copy_file(template_path, destination_path)

	local config = {
		[name] = {
			name = name,
		},
	}

	if
		settings_key == configuration.types.command.settings_key
		or settings_key == configuration.types.subcommand.settings_key
	then
		config[name].trigger = name:lower()
	end

	Write.Info("Adding \ao%s\ax to \ao%s\ax in settings", name, settings_key)
	settings.update_and_save_global_settings(global_settings, settings_key, config)
end

return { action_func = action }
