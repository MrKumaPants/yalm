---@type Mq
local mq = require("mq")

local helpers = {}

helpers.is_valid_container = function(item)
	return item.Container() and item.Items() and item.Items() > 0
end

helpers.nav_to_target = function()
	mq.cmd("/nav target distance=18")
	while mq.TLO.Navigation.Active() or mq.TLO.Navigation.Paused() do
		mq.delay("1s")
	end
end

local function open_and_check_merchant_window()
	mq.TLO.Merchant.OpenWindow()

	local delay = 0
	while not mq.TLO.Merchant.Open() and delay < 1000 do
		mq.delay(250)
		delay = delay + 250
	end

	if not mq.TLO.Merchant.Open() then
		return false
	end

	return true
end

helpers.ready_merchant_window = function(travel)
	local npc_class = "Merchant"

	-- open the merchant
	if not mq.TLO.Merchant.Open() then
		-- check if we were able to open merchant window
		open_and_check_merchant_window()

		if mq.TLO.Target.ID() > 0 then
			-- only use real merchants
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

			if not open_and_check_merchant_window() then
				Write.Warn("Error opening \ao%s\ax window", npc_class:lower())
				return false
			end
		end
	end

	return true
end

return helpers
