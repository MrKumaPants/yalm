local mq = require("mq")

local evaluate = require("yalm.classes.evaluate")
local helpers = require("yalm.classes.helpers")

local utils = require("yalm.lib.utils")

local function get_item_preference(item, loot, char_settings, global_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(item, loot, char_settings, global_settings.unmatched_item_rule)

		if preference then
			local loot_preference = loot.loot_preferences[preference.setting]
			if loot_preference then
				if not evaluate.is_item_in_saved_slot(item, char_settings) then
					return preference
				end
			end
		end
	end

	return nil
end

local function check_item(item, loot, char_settings, global_settings)
	local preference = get_item_preference(item, loot, char_settings, global_settings)

	if not item.Name() then
		return
	end

	if preference then
		Write.Info("\a-t%s\ax passes with %s", item.Name(), utils.GetItemPreferenceString(preference))
	else
		Write.Info("\a-t%s\ax does not match any rules", item.Name())
	end
end

local function action(loot, char_settings, global_settings, args)
	if mq.TLO.Cursor.ID() then
		local item = mq.TLO.Cursor
		Write.Info("Checking preference for item on cursor...")
		check_item(item, loot, char_settings, global_settings)
		Write.Info("Putting \a-t%s\ax into inventory", item.Name())
		mq.cmd("/autoinventory")
	else
		Write.Info("Checking preference for items in inventory...")
		for i = 23, 32 do
			local inventory_item = mq.TLO.Me.Inventory(i)

			if inventory_item.Name() then
				if helpers.is_valid_container(inventory_item) then
					for j = 1, inventory_item.Container() do
						local item = mq.TLO.Me.Inventory(i).Item(j)
						check_item(item, loot, char_settings, global_settings)
					end
				else
					check_item(inventory_item, loot, char_settings, global_settings)
				end
			end
		end
	end

	Write.Info("Finished checking")
	mq.cmd("/cleanup")
end

return { action_func = action }
