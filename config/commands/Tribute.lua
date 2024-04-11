---@type Mq
local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local helpers = require("yalm.core.helpers")

local function is_donate_button_enabled()
	local handle = "TributeMasterWnd/TMW_DonateButton"
	return mq.TLO.Window(handle).Enabled()
end

local function can_donate_item(item, global_settings, char_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(
			item,
			global_settings,
			char_settings,
			global_settings.settings.unmatched_item_rule
		)

		if preference then
			local loot_preference = global_settings.preferences[preference.setting]

			if loot_preference and loot_preference.name == "Tribute" then
				if not evaluate.is_item_in_saved_slot(item, char_settings) then
					return true
				end
			end
		end
	end

	return false
end

local function donate_item(item, global_settings, char_settings)
	local can_sell = can_donate_item(item, global_settings, char_settings)

	if can_sell then
		if item.ItemSlot2() ~= nil then
			mq.cmdf("/shift /itemnotify in pack%s %s leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
		else
			mq.cmdf("/shift /itemnotify %s leftmouseup", item.ItemSlot())
		end
		mq.delay(250)

		-- wait for the donate button
		while not is_donate_button_enabled() do
			mq.delay(250)
		end

		-- donate item
		mq.cmdf("/shift /notify TributeMasterWnd TMW_DonateButton leftmouseup")
		mq.delay(1000)

		while is_donate_button_enabled() do
			mq.delay(250)
		end
	end
end

local function action(global_settings, char_settings, args)
	if args[2] then
		if not (args[2] == "guild" or args[2] == "me") then
				Write.Error("That is not a valid option")
		end
	end

	if helpers.ready_tribute_window(true, args[2]) then
		Write.Info("Donating items...")
		mq.cmd("/keypress OPEN_INV_BAGS")

		helpers.call_func_on_inventory(donate_item, global_settings, char_settings)

		Write.Info("Finished donating")
		mq.cmd("/cleanup")
	end
end

return { action_func = action }
