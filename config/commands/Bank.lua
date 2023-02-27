local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local helpers = require("yalm.core.helpers")

local function get_free_bank_count()
	local count = 0

	for i = 2000, 2023 do
		local inventory_item = mq.TLO.Me.Inventory(i)

		if inventory_item.Name() then
			if inventory_item.Container() > 0 and inventory_item.Items() > 0 then
				count = count + inventory_item.Container() - inventory_item.Items()
			end
		else
			count = count + 1
		end
	end

	return count
end

local function is_valid_deposit(item)
	if get_free_bank_count() == 0 then
		return false
	end

	if item.NoTrade() or item.NoRent() then
		return false
	end

	return true
end

local function can_deposit_item(item, global_settings, char_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(
			item,
			global_settings,
			char_settings,
			global_settings.settings.unmatched_item_rule
		)

		if preference then
			local loot_preference = global_settings.preferences[preference.setting]
			if loot_preference and loot_preference.name == "Bank" and is_valid_deposit(item) then
				if not evaluate.is_item_in_saved_slot(item, char_settings) then
					return true
				end
			end
		end
	end

	return false
end

local function deposit_item(item, global_settings, char_settings)
	local can_deposit = can_deposit_item(item, global_settings, char_settings)
	if can_deposit then
		-- pick up the item
		if item.ItemSlot2() ~= nil then
			mq.cmdf("/shift /itemnotify in pack%s %s leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
		else
			mq.cmdf("/shift /itemnotify %s leftmouseup", item.ItemSlot())
		end

		-- deposit item if the cursor matches what we expect
		if mq.TLO.Cursor.ID() == item.ID() then
			Write.Info("Depositing \a-t%s\ax", item.Name())

			if get_free_bank_count() > 0 then
				mq.cmdf("/nomodkey /notify BigBankWnd BIGB_AutoButton leftmouseup")
			end
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
	if helpers.ready_bank_window(true) then
		Write.Info("Depositing items...")

		helpers.call_func_on_inventory(deposit_item, global_settings, char_settings)

		Write.Info("Finished depositing")
		mq.cmd("/cleanup")
	end
end

return { action_func = action }
