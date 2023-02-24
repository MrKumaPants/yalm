local configuration = require("yalm.config.configuration")

local function action(type, global_settings, char_settings, args)
	local loader_type = configuration.types[type].loader_type

	Write.Info("\axList of existing \at%s\ax:", loader_type)
	for _, value in pairs(global_settings[loader_type]) do
		if value.name then
			Write.Info("\t  %s", value.name)
		else
			Write.Info("\t  %s", value)
		end
	end
end

return { action_func = action }
