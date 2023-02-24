---@type Mq
local mq = require("mq")

local configuration = require("yalm.config.configuration")

local loader = require("yalm.core.loader")

local utils = require("yalm.lib.utils")

local function action(type, global_settings, char_settings, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]

	local loader_type = configuration.types[type].loader_type

	local template_path = ("%s/yalm/templates/%s.lua"):format(mq.luaDir, loader_type)

	if not utils.file_exists(template_path) then
		Write.Error("No template file exists for \at%s\ax", template_path)
	end

	local destination_path = ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, loader_type, name)

	if utils.file_exists(destination_path) then
		Write.Warn("\ao%s\ax already exists", name)
		return
	end

	Write.Info("Creating \ao%s.lua\ax", name)
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

return { action_func = action }
