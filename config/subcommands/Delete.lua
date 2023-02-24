---@type Mq
local mq = require("mq")

local configuration = require("yalm.config.configuration")

local utils = require("yalm.lib.utils")

local function action(type, global_settings, char_settings, args)
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

return { action_func = action }
