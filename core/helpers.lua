---@type Mq
local mq = require("mq")

local helpers = {}

helpers.delay_and_wait = function(func, delay)
	mq.delay(1000)

	while func() do
		mq.delay(250)
	end

	mq.delay(delay)
end

helpers.not_delay_and_wait = function(func, delay)
	mq.delay(1000)

	while not func() do
		mq.delay(250)
	end

	mq.delay(delay)
end

helpers.is_valid_container = function(item)
	return item.Container() and item.Items() and item.Items() > 0
end

helpers.nav_to_target = function()
	mq.cmd("/nav target distance=18 los=off")
	while mq.TLO.Navigation.Active() or mq.TLO.Navigation.Paused() do
		mq.delay("1s")
	end
end

helpers.is_window_open = function(handle)
	return mq.TLO.Window(handle).Open()
end

helpers.open_npc_window = function(npc_class)
	local npc = mq.TLO.NearestSpawn(('class "%s"'):format(npc_class))

	if npc_class == "Merchant" and npc.CleanName() == "Parcel Delivery Liaison" then
		npc = mq.TLO.NearestSpawn(2, ('class "%s"'):format(npc_class))
	end

	if npc.Class() == npc_class then
		npc.DoTarget()
		npc.RightClick()
		return true
	end

	return false
end

helpers.open_and_check_npc_window = function(handle, npc_class, wait_time)
	helpers.open_npc_window(npc_class)

	local delay = 0
	while not helpers.is_window_open(handle) and delay < wait_time do
		mq.delay(250)
		delay = delay + 250
	end

	if not helpers.is_window_open(handle) then
		return false
	end

	return true
end

helpers.ready_npc_window = function(handle, npc_class, travel)
	if not helpers.is_window_open(handle) then
		helpers.open_and_check_npc_window(handle, npc_class, 1000)

		if mq.TLO.Target.ID() > 0 then
			-- only use real bankers
			if mq.TLO.Target.Class() ~= npc_class then
				Write.Warn("Target is not a real \ao%s\ax", npc_class:lower())
				return false
			end
			-- distance
			if mq.TLO.Target.Distance3D() > 18 then
				Write.Warn("\ao%s\ax is too far away", npc_class)
				if travel then
					Write.Info("Navigating to \ao%s\ax", mq.TLO.Target.Name())
					helpers.nav_to_target()
				else
					return false
				end
			end

			if not helpers.open_and_check_npc_window(handle, npc_class, 10000) then
				Write.Warn("Error opening \ao%s\ax window", npc_class:lower())
				return false
			end
		end
	end

	return true
end

helpers.ready_bank_window = function(travel)
	return helpers.ready_npc_window("BigBankWnd", "Banker", travel)
end

helpers.ready_guild_bank_window = function(travel)
	return helpers.ready_npc_window("GuildBankWnd", "Guild Banker", travel)
end

helpers.ready_merchant_window = function(travel)
	return helpers.ready_npc_window("MerchantWnd", "Merchant", travel)
end

helpers.ready_tribute_window = function(travel, tribute_master)
	if
			tribute_master == "me"
			or (tribute_master == nil and mq.TLO.Target.Class() ~= "Guild Tribute Master" and mq.TLO.NearestSpawn('class "Tribute Master"').Class() == "Tribute Master")
			or (tribute_master == nil and mq.TLO.Target.Class() == "Tribute Master")
	then
			return helpers.ready_npc_window("TributeMasterWnd", "Tribute Master", travel)
	elseif
			tribute_master == "guild"
			or (tribute_master == nil and mq.TLO.Target.Class() ~= "Tribute Master" and mq.TLO.NearestSpawn('class "Guild Tribute Master"').Class() == "Guild Tribute Master")
			or (tribute_master == nil and mq.TLO.Target.Class() == "Guild Tribute Master")
	then
			return helpers.ready_npc_window("TributeMasterWnd", "Guild Tribute Master", travel)
	end

	return false
end

helpers.call_func_on_inventory = function(func, global_settings, char_settings)
	for i = 23, 32 do
		local inventory_item = mq.TLO.Me.Inventory(i)

		if inventory_item.Name() then
			if inventory_item.Container() > 0 then
				if inventory_item.Items() > 0 then
					for j = 1, inventory_item.Container() do
						local item = mq.TLO.Me.Inventory(i).Item(j)
						func(item, global_settings, char_settings)
					end
				end
			else
				func(inventory_item, global_settings, char_settings)
			end
		end
	end
end

return helpers
