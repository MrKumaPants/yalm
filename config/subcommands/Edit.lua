local configuration = require("yalm.config.configuration")

local loader = require("yalm.core.loader")

local utils = require("yalm.lib.utils")

local function action(type, subcommands, global_settings, char_settings, args)
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

return { action_func = action }
