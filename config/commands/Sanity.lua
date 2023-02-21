---@type Mq
local mq = require("mq")

local looting = require("yalm.core.looting")

local function action(global_settings, char_settings, args)
	Write.Info("am_i_master_looter: %s", looting.am_i_master_looter())
	Write.Info("my name: %s master name: %s", mq.TLO.Me.Name(), mq.TLO.Group.MasterLooter.Name())
	Write.Info("can_i_loot: %s", looting.can_i_loot("SCount"))
	Write.Info("is_solo_looter: %s", looting.is_solo_looter())
	Write.Info("item: %s", mq.TLO.AdvLoot["SList"](1))
end

return { action_func = action }
