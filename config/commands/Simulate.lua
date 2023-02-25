---@type Mq
local mq = require("mq")

local evaluate = require("yalm.core.evaluate")
local looting = require("yalm.core.looting")

local Item = require("yalm.definitions.Item")

local database = require("yalm.lib.database")
local utils = require("yalm.lib.utils")

local function action(global_settings, char_settings, args)
	local item, item_name = nil, nil

	if mq.TLO.Cursor.ID() then
		item_name = mq.TLO.Cursor.Name()
		item = mq.TLO.Cursor
	else
		item_name = args[2]

		if not item_name then
			Write.Error("No item specified")
			return
		end

		item = Item:new(nil, database.QueryDatabaseForItemName(item_name))

		if not item.item_db then
			Write.Error("Item \at%s\ax does not exist", item_name)
			return
		end
	end

	Write.Info("Simulating looting for \a-t%s\ax", item_name)

	local can_loot, check_rematch, member, preference = looting.get_member_can_loot(
		item,
		global_settings,
		global_settings.settings.save_slots,
		global_settings.settings.dannet_delay,
		false,
		global_settings.settings.unmatched_item_rule
	)

	if not can_loot and check_rematch and global_settings.settings.always_loot and preference then
		Write.Warn("No one matched \a-t%s\ax loot preference", item_name)
		Write.Warn("Trying again ignoring quantity and list")

		can_loot, check_rematch, member, preference = looting.get_member_can_loot(
			item,
			global_settings,
			global_settings.settings.save_slots,
			global_settings.settings.dannet_delay,
			global_settings.settings.always_loot,
			global_settings.settings.unmatched_item_rule
		)
	end

	if not can_loot or not preference then
		Write.Warn("No loot preference found for \a-t%s\ax", item_name)
		return
	end

	if not evaluate.is_valid_preference(global_settings.preferences, preference) then
		Write.Warn("Invalid loot preference for \a-t%s\ax", item_name)
		return
	end

	if global_settings.preferences[preference.setting].leave then
		Write.Info("Loot preference set to \aoleave\ax for \a-t%s\ax", item_name)
		return
	end

	Write.Info("\a-t%s\ax passes with %s", item_name, utils.get_item_preference_string(preference))

	if not can_loot then
		Write.Warn("No one is able to loot \a-t%s\ax", item_name)
		return
	end

	Write.Info("Giving \a-t%s\ax to \ao%s\ax", item_name, member)

	Write.Info("End simulating", item_name)
end

return { action_func = action }
