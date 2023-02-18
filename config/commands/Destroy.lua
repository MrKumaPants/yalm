---@type Mq
local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local helpers = require("yalm.core.helpers")

local function can_destroy_item(item, global_settings, char_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(
			item,
			global_settings,
			char_settings,
			global_settings.settings.unmatched_item_rule
		)

		if preference then
			local loot_preference = global_settings.preferences[preference.setting]
			if loot_preference and loot_preference.name == "Destroy" then
				if not evaluate.is_item_in_saved_slot(item, char_settings) then
					return true
				end
			end
		end
	end

	return false
end

local function destroy_item(item, global_settings, char_settings)
	local can_destroy = can_destroy_item(item, global_settings, char_settings)

	if can_destroy then
		-- pick up the item
		if item.ItemSlot2() ~= nil then
			mq.cmdf("/shift /itemnotify in pack%s %s leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
		else
			mq.cmdf("/shift /itemnotify %s leftmouseup", item.ItemSlot())
		end
		mq.delay(250)

		-- destroy item if the cursor matches what we expect
		if mq.TLO.Cursor.ID() == item.ID() then
			Write.Info("Destroying \a-t%s\ax", item.Name())
			mq.cmd("/destroy")
		else
			Write.Warn("Cursor doesn't match. Expected: \a-t%s\ax; Actual: \ar%s\ax", item.Name(), mq.TLO.Cursor.Name())
			-- if cursor doesn't match what we expect, put it back
			if mq.TLO.Cursor.ID() ~= nil then
				mq.cmd("/autoinventory")
			end
		end

		mq.delay(250)
	end
end

local function action(global_settings, char_settings, args)
	Write.Info("Destroying items...")

	helpers.call_func_on_inventory(destroy_item, global_settings, char_settings)

	Write.Info("Finished cleanup")
	mq.cmd("/cleanup")
end

return { action_func = action }
