local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local loader = require("yalm.core.loader")
local settings = require("yalm.config.settings")

local LIP = require("yalm.lib.LIP")
local utils = require("yalm.lib.utils")

local function action(global_settings, char_settings, args)
	local lootly_file = ("%s/Lootly_Loot.ini"):format(mq.configDir)

	if not utils.file_exists(lootly_file) then
		Write.Error("Lootly loot file does not exist")
		return
	end

	Write.Info("Converting Lootly file...")

	local inifile = LIP.load(lootly_file)

	local items = {}

	for _, section in pairs(inifile) do
		for item_name, preference in pairs(section) do
			local converted_preference = evaluate.parse_preference_string(preference)
			Write.Info(
				"Found item \a-t%s\ax with %s",
				item_name,
				utils.get_item_preference_string(converted_preference)
			)
			items[item_name] = converted_preference
		end
	end

	settings.update_and_save_global_settings(global_settings, loader.types.items, items)

	Write.Info("Finished converting")
end

return { action_func = action }
