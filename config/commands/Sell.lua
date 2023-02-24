---@type Mq
local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local helpers = require("yalm.core.helpers")

local function can_sell_item(item, global_settings, char_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(
			item,
			global_settings,
			char_settings,
			global_settings.settings.unmatched_item_rule
		)

		if preference then
			local loot_preference = global_settings.preferences[preference.setting]

			if loot_preference and loot_preference.name == "Sell" then
				if not evaluate.is_item_in_saved_slot(item, char_settings) and item.Value() > 0 then
					return true
				end
			end
		end
	end

	return false
end

local function sell_item(item, global_settings, char_settings)
	local can_sell = can_sell_item(item, global_settings, char_settings)

	if can_sell then
		local stack = item.Stack()

		if item.ItemSlot2() ~= nil then
			mq.cmdf("/shift /itemnotify in pack%s %s leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
		else
			mq.cmdf("/shift /itemnotify %s leftmouseup", item.ItemSlot())
		end

		helpers.not_delay_and_wait(function()
			return mq.TLO.Merchant.SelectedItem.ID() == item.ID()
		end, 250)

		-- sell item if the selected item in the merchant window matches
		if mq.TLO.Merchant.SelectedItem.ID() == item.ID() then
			if not mq.TLO.Window("MerchantWnd/MW_SelectedPriceLabel").Text():find("^0c") then
				Write.Info("Selling \a-t%s\ax", item.Name())
				mq.TLO.Merchant.Sell(stack)

				helpers.delay_and_wait(function()
					return mq.TLO.Merchant.SelectedItem.ID() == item.ID()
				end, 250)
			end
		else
			Write.Warn(
				"Selected item doesn't match. Expected: \a-t%s\ax; Actual: \ar%s\ax",
				item.Name(),
				mq.TLO.Merchant.SelectedItem.Name()
			)
		end
	end
end

local function action(global_settings, char_settings, args)
	if helpers.ready_merchant_window(true) then
		Write.Info("Selling items...")

		helpers.call_func_on_inventory(sell_item, global_settings, char_settings)

		Write.Info("Finished selling")
		mq.cmd("/cleanup")
	end
end

return { action_func = action }
