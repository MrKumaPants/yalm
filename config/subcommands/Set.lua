local configuration = require("yalm.config.configuration")

local function action(type, subcommands, global_settings, char_settings, args)
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

return { action_func = action }
