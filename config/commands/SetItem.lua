local mq = require("mq")

local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local evaluate = require("yalm.core.evaluate")

local utils = require("yalm.lib.utils")

local function action(global_settings, char_settings, args)
	local item_name, global_or_character, preference, scope = nil, "all", nil, nil

	if mq.TLO.Cursor.ID() then
		item_name = mq.TLO.Cursor.Name()
		preference = args[2]
		scope = args[3]
	end

	if not item_name then
		if not args[2] then
			Write.Error("No item specified")
			return
		end

		item_name = args[2]
		if item_name:sub(1, 1) == '"' and item_name:sub(item_name:len()) == '"' then
			item_name = item_name:sub(2, item_name:len() - 1)
		end

		preference = args[3]
		scope = args[4]
	end

	if not preference then
		Write.Error("No preference specified")
		return
	end

	preference = evaluate.parse_preference_string(preference)

	if not evaluate.is_valid_preference(global_settings.preferences, preference) then
		Write.Error("Invalid loot preference for \a-t%s\ax", item_name)
		return
	end

	if item_name and preference then
		if scope then
			global_or_character = scope
		end
		if global_or_character ~= "all" and global_or_character ~= "me" then
			Write.Error("Invalid scope for \a-t%s\ax", global_or_character)
			return
		end
	end

	Write.Info("Setting \a-t%s\ax preference to %s", item_name, utils.get_item_preference_string(preference))

	if mq.TLO.Cursor.ID() then
		Write.Info("Putting \a-t%s\ax into inventory", item_name)
		mq.cmd("/autoinventory")
	end

	if global_or_character == "me" then
		Write.Info("Saving character settings...")
		char_settings[configuration.types.item.settings_key][item_name] = preference
		settings.save_char_settings(char_settings)
	elseif global_or_character == "all" then
		Write.Info("Saving global settings...")
		settings.update_and_save_global_settings(global_settings, configuration.types.item.settings_key, {
			[item_name] = preference,
		})
	end
end

return { action_func = action }
