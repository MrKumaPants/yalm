local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local loader = require("yalm.core.loader")

local utils = require("yalm.lib.utils")

local function edit_config(type, global_settings, char_settings, args)
	local filename = nil

	local name = args[3]

	if type == configuration.types.character.name then
		filename = settings.get_char_settings_filename(name)
	else
		filename = settings.get_global_settings_filename()
	end

	if not utils.file_exists(filename) then
		Write.Error("No file exists for \at%s\ax", type)
		return
	end

	os.execute(('start "" "%s"'):format(filename))
end

local function edit_types(type, global_settings, char_settings, args)
	if not args[3] then
		Write.Error("No name specified")
		return
	end

	local name = args[3]
	local settings_key = configuration.types[type].settings_key

	if not global_settings[settings_key][name] then
		Write.Error("\at%s\ax is not a valid \at%s\ax", name, configuration.types[type].name)
		return
	end

	local filename = loader.filename(name, settings_key)

	if not utils.file_exists(filename) then
		Write.Error("No file exists for \at%s\ax", name)
		return
	end

	os.execute(('start "" "%s"'):format(filename))
end

local function action(type, subcommands, global_settings, char_settings, args)
	if type == configuration.types.character.name or type == configuration.types.setting.name then
		edit_config(type, global_settings, char_settings, args)
	else
		edit_types(type, global_settings, char_settings, args)
	end
end

return { action_func = action }
