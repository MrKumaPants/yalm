---@type Mq
local mq = require("mq")

local evaluate = require("yalm.classes.evaluate")
local helpers = require("yalm.classes.helpers")

local function can_sell_item(item, loot, char_settings, global_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(item, loot, char_settings, global_settings.unmatched_item_rule)

		if preference then
			local loot_preference = loot.loot_preferences[preference.setting]
			if loot_preference and loot_preference.name == "Sell" and item.Value() > 0 then
				if not evaluate.is_item_in_saved_slot(item, char_settings) then
					return true
				end
			end
		end
	end

	return false
end

local function sell_item(item, loot, char_settings, global_settings)
	local can_sell = can_sell_item(item, loot, char_settings, global_settings)

	if can_sell then
		local stack = item.Stack()

		if item.ItemSlot2() ~= nil then
			mq.cmdf("/shift /itemnotify in pack%s %s leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
		else
			mq.cmdf("/shift /itemnotify %s leftmouseup", item.ItemSlot())
		end

		mq.delay(500)

		-- sell item if the selected item in the merchant window matches
		if mq.TLO.Merchant.SelectedItem.ID() == item.ID() then
			if mq.TLO.Merchant.SelectedItem.Value() * (1 / mq.TLO.Merchant.Markup()) > 0 then
				Write.Info("Selling \a-t%s\ax", item.Name())
				mq.TLO.Merchant.Sell(stack)
				mq.delay(1000)
			end
		else
			Write.Warn(
				"Selected item doesn't match. Expected: \a-t%s\ax; Actual: \ar%s\ax",
				item.Name(),
				mq.TLO.Merchant.SelectedItem.ID()
			)
			mq.delay(1000)
		end
	end
end

local function action(loot, char_settings, global_settings, args)
	Write.Info("Selling items...")

	if helpers.ready_merchant_window(true) then
		for i = 23, 32 do
			local inventory_item = mq.TLO.Me.Inventory(i)

			if inventory_item.Name() then
				if inventory_item.Container() > 0 then
					if inventory_item.Items() > 0 then
						for j = 1, inventory_item.Container() do
							local item = mq.TLO.Me.Inventory(i).Item(j)
							sell_item(item, loot, char_settings, global_settings)
						end
					end
				else
					sell_item(inventory_item, loot, char_settings, global_settings)
				end
			end
		end
	end

	Write.Info("Finished selling")
	mq.cmd("/cleanup")
end

return { action_func = action }
