---@type Mq
local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local helpers = require("yalm.core.helpers")

local function get_buy_preference(item, global_settings, char_settings)
	if item.Name() then
		local member = mq.TLO.Me
		local can_loot, _, preference = evaluate.check_can_loot(
			member,
			item,
			global_settings,
			global_settings.settings.save_slots,
			global_settings.settings.dannet_delay,
			global_settings.settings.always_loot,
			global_settings.settings.unmatched_item_rule
		)

		if can_loot and preference then
			local loot_preference = global_settings.preferences[preference.setting]

			if loot_preference and loot_preference.name == "Buy" then
				return preference
			end
		end
	end

	return nil
end

local function buy_item(item, global_settings, char_settings)
	local preference = get_buy_preference(item, global_settings, char_settings)

	if preference then
		local buy_count, count = 0, 0

		repeat
			local item_count = mq.TLO.FindItemCount(item.ID())() or 0
			local bank_count = mq.TLO.FindItemBankCount(item.ID())() or 0
			count = item_count + bank_count

			buy_count = 0

			if preference.quantity and count < preference.quantity then
				buy_count = preference.quantity - count
				if buy_count > item.StackSize() then
					buy_count = item.StackSize()
				end
			end

			if buy_count > 0 then
				mq.TLO.Merchant.SelectItem(item.Name())
				mq.delay(250)

				if mq.TLO.Merchant.SelectedItem.BuyPrice() <= mq.TLO.Me.Cash() then
					Write.Info("Buying \ao%s\ax of \a-t%s\ax", buy_count, item.Name())
					mq.TLO.Merchant.Buy(buy_count)
					mq.delay(250)
				else
					Write.Info("You cannot afford to buy any more \a-t%s\ax", item.Name())
					buy_count = 0
				end
			end
		until buy_count == 0
	end
end

local function action(global_settings, char_settings, args)
	if helpers.ready_merchant_window(true) then
		Write.Info("Buying items...")

		local item_count = mq.TLO.Merchant.Items()

		while item_count == 0 do
			mq.delay(250)
			item_count = mq.TLO.Merchant.Items()
		end

		for i = 1, item_count do
			local item = mq.TLO.Merchant.Item(i)
			buy_item(item, global_settings, char_settings)
		end

		Write.Info("Finished buying")
		mq.cmd("/cleanup")
	end
end

return { action_func = action }
