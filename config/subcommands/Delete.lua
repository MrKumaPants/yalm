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

	local settings_key = configuration.types[type].settings_key

	local destination_path = ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, settings_key, name)

	if not global_settings[settings_key][name] then
		Write.Error("\at%s\ax is not a valid %s name", name, type)
		return
	end

	Write.Info("Deleting \ao%s.lua\ax from \ao%s\ax", name, settings_key)
	utils.delete_file(destination_path)

	Write.Info("Deleting \ao%s\ax from \ao%s\ax in settings", name, settings_key)
	settings.remove_and_save_global_settings(global_settings, settings_key, name)
end

return { action_func = action }
