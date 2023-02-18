local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local helpers = require("yalm.core.helpers")

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
	local preference = get_item_preference(item, global_settings, char_settings)

	if not item.Name() then
		return
	end

	if preference then
		Write.Info("\a-t%s\ax passes with %s", item.Name(), utils.get_item_preference_string(preference))
	else
		Write.Info("\a-t%s\ax does not match any rules", item.Name())
	end
end

local function action(global_settings, char_settings, args)
	if mq.TLO.Cursor.ID() then
		local item = mq.TLO.Cursor

		Write.Info("Checking preference for item on cursor...")
		check_item(item, global_settings, char_settings)

		Write.Info("Putting \a-t%s\ax into inventory", item.Name())
		mq.cmd("/autoinventory")
	else
		Write.Info("Checking preference for items in inventory...")

		helpers.call_func_on_inventory(check_item, global_settings, char_settings)
	end

	Write.Info("Finished checking")
	mq.cmd("/cleanup")
end

return { action_func = action }
