---@type Mq
local mq = require("mq")

local evaluate = require("yalm.classes.evaluate")
local helpers = require("yalm.classes.helpers")

local function get_buy_preference(item, loot, char_settings, global_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(item, loot, char_settings, global_settings.unmatched_item_rule)

		if preference then
			local loot_preference = loot.preferences[preference.setting]

			if loot_preference and loot_preference.name == "Buy" then
				local member = mq.TLO.Me
				if evaluate.check_can_loot(member, item, preference, global_settings) then
					return preference
				end
			end
		end
	end

	return nil
end

local function buy_item(item, loot, char_settings, global_settings)
	local preference = get_buy_preference(item, loot, char_settings, global_settings)

	if preference then
		local item_count = mq.TLO.FindItemCount(item.ID())() or 0
		local bank_count = mq.TLO.FindItemCount(item.ID())() or 0
		local count = item_count + bank_count

		local buy_count = 1

		if preference.quantity and count < preference.quantity then
			buy_count = preference.quantity - count
		end

		mq.TLO.Merchant.SelectItem(item.Name())
		mq.delay(250)

		Write.Info("Buying \ao%s\ax of \a-t%s\a-x", buy_count, item.Name())
		mq.TLO.Merchant.Buy(buy_count)
		mq.delay(250)
	end
end

local function action(loot, char_settings, global_settings, args)
	Write.Info("Buying items...")

	if helpers.ready_merchant_window(true) then
		mq.delay(500)
		local item_count = mq.TLO.Merchant.Items()

		while item_count == 0 do
			mq.delay(250)
			item_count = mq.TLO.Merchant.Items()
		end

		for i = 1, item_count do
			local item = mq.TLO.Merchant.Item(i)
			buy_item(item, loot, char_settings, global_settings)
		end
	end

	Write.Info("Finished buying")
	mq.cmd("/cleanup")
end

return { action_func = action }
