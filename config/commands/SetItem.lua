local mq = require("mq")

local evaluate = require("yalm.classes.evaluate")
local loader = require("yalm.classes.loader")
local settings = require("yalm.config.settings")

local inspect = require("yalm.lib.inspect")

local function action(loot, char_settings, global_settings, args)
	local item_name, global_or_character = nil, "character"

	if not args[2] then
		Write.Error("No preference specified")
		return
	end

	if mq.TLO.Cursor.ID() then
		item_name = mq.TLO.Cursor.Name()
	end

	if not item_name then
		if not args[3] then
			Write.Error("No item specified")
			return
		end

		item_name = args[3]
		if item_name:sub(1, 1) == '"' and item_name:sub(item_name:len()) == '"' then
			item_name = item_name:sub(2, item_name:len() - 1)
		end
	end

	if item_name then
		global_or_character = args[#args]
		if global_or_character ~= "global" or global_or_character ~= "character" then
			Write.Error("Invalid scope for \a-t%s\ax", global_or_character)
			return
		end
	end

	local preference = evaluate.parse_preference_string(args[2])

	if not evaluate.is_valid_preference(loot.loot_preferences, preference) then
		Write.Error("Invalid loot preference for \a-t%s\ax", item_name)
		return
	end

	if mq.TLO.Cursor.ID() then
		Write.Info("Putting \a-t%s\ax into inventory", item_name)
		mq.cmd("/autoinventory")
	end

	if global_or_character == "character" then
		Write.Info("Saving character settings")
		char_settings[loader.types.items][item_name] = preference
		settings.save_character_settings(char_settings)
	elseif global_or_character == "global" then
		Write.Info("Saving global settings")
		settings.update_and_save_global_settings(global_settings, loader.types.items, {
			[item_name] = preference,
		})
	end
end

return { action_func = action }
