local configuration = require("yalm.config.configuration")

local loader = require("yalm.core.loader")

local function action(type, subcommands, global_settings, char_settings, args)
	local loader_type = configuration.types[type].loader_type

	Write.Info("\axList of existing \at%s\ax:", loader_type)

	if loader_type == loader.types.categories then
		for _, value in ipairs(global_settings[loader_type]) do
			Write.Info("\ax\t  %s", value)
		end
	else
		for _, value in pairs(global_settings[loader_type]) do
			if value.name then
				Write.Info("\ax\t  %s", value.name)
			else
				Write.Info("\ax\t  %s", value)
			end
		end
	end
end

return { action_func = action }
