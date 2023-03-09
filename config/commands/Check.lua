local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local helpers = require("yalm.core.helpers")

local Item = require("yalm.definitions.Item")

local database = require("yalm.lib.database")
local utils = require("yalm.lib.utils")

local function get_item_preference(item, global_settings, char_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(
			item,
			global_settings,
			char_settings,
			global_settings.settings.unmatched_item_rule
		)

		if preference then
			local loot_preference = global_settings.preferences[preference.setting]
			if loot_preference then
				if not evaluate.is_item_in_saved_slot(item, char_settings) then
					return preference
				end
			end
		end
	end

	return nil
end

local function check_item(item, global_settings, char_settings)
	if item.Name() then
		local preference = get_item_preference(item, global_settings, char_settings)

		if preference then
			Write.Info("\a-t%s\ax passes with %s", item.Name(), utils.get_item_preference_string(preference))
		else
			Write.Info("\a-t%s\ax does not match any rules", item.Name())
		end
	end
end

local function action(global_settings, char_settings, args)
	local item, item_name = nil, nil

	if mq.TLO.Cursor.ID() then
		item_name = mq.TLO.Cursor.Name()
		item = mq.TLO.Cursor
	elseif args[2] then
		item_name = args[2]

		if not item_name then
			Write.Error("No item specified")
			return
		end

		item = Item:new(nil, database.QueryDatabaseForItemName(item_name))

		if not item.item_db then
			Write.Error("Item \at%s\ax does not exist", item_name)
			return
		end
	end

	if item and item_name then
		Write.Info("Checking preference for \a-t%s\ax...", item_name)
		check_item(item, global_settings, char_settings)

		if mq.TLO.Cursor.ID() then
			Write.Info("Putting \a-t%s\ax into inventory", item_name)
			mq.cmd("/autoinventory")
		end
	else
		Write.Info("Checking preference for items in inventory...")

		helpers.call_func_on_inventory(check_item, global_settings, char_settings)
	end

	Write.Info("Finished checking")
	mq.cmd("/cleanup")
end

return { action_func = action }
