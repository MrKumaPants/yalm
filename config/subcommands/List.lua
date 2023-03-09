local configuration = require("yalm.config.configuration")

local function action(type, subcommands, global_settings, char_settings, args)
	local settings_key = configuration.types[type].settings_key

	Write.Info("\axList of existing \at%s\ax:", settings_key)

	if settings_key == configuration.types.category.settings_key then
		for _, value in ipairs(global_settings[settings_key]) do
			Write.Info("\ax\t  %s", value)
		end
	else
		for _, value in pairs(global_settings[settings_key]) do
			if value.name then
				Write.Info("\ax\t  %s", value.name)
			else
				Write.Info("\ax\t  %s", value)
			end
		end
	end
end

return { action_func = action }
