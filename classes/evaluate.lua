local Item = require("yalm.classes.item")
local inventory = require("yalm.classes.inventory")
local loader = require("yalm.classes.loader")

local database = require("yalm.lib.database")
local utils = require("yalm.lib.utils")

database.database = assert(database.OpenDatabase())

local evaluate = {}

evaluate.check_can_loot = function(member, item, preference, settings)
	local can_loot = inventory.check_group_member(member, preference.list, settings.dannet_delay, settings.always_loot)

	if can_loot then
		can_loot = inventory.check_inventory(member, item, settings.save_slots, settings.dannet_delay)
	end

	if can_loot then
		can_loot =
			inventory.check_quantity(member, item, preference.quantity, settings.dannet_delay, settings.always_loot)
	end

	if can_loot then
		can_loot = inventory.check_lore(member, item, settings.dannet_delay)
	end

	return can_loot
end

evaluate.check_loot_conditions = function(item, loot_conditions, set_conditions)
	local preference = nil

	for i in ipairs(set_conditions) do
		local condition = set_conditions[i]
		if loot_conditions[condition.name] and loot_conditions[condition.name].loaded then
			local condition_item = item
			-- this is an advlootitem
			if condition_item.Index then
				condition_item = Item:new(nil, database.QueryDatabaseForItem(item.ID()))
			end
			local success, result = pcall(loot_conditions[condition.name].func.condition_func, condition_item)
			if success and result then
				preference = evaluate.convert_rule_preference(condition_item, condition)
				break
			end
		end
	end

	return preference
end

evaluate.check_loot_items = function(item, loot_items)
	local preference = nil

	if loot_items[item.Name()] then
		preference = evaluate.convert_rule_preference(item, loot_items[item.Name()])
	end

	return preference
end

evaluate.check_loot_sets = function(item, loot_conditions, loot_sets, char_sets)
	local preference = nil

	for i in ipairs(char_sets) do
		local set = char_sets[i]
		if set.enabled and loot_sets[set.name].loaded then
			if loot_sets[set.name][loader.types.items] then
				preference = evaluate.check_loot_items(item, loot_sets[set.name][loader.types.items])
			end
			if preference == nil and loot_sets[set.name][loader.types.conditions] then
				preference =
					evaluate.check_loot_conditions(item, loot_conditions, loot_sets[set.name][loader.types.conditions])
			end
			if preference then
				break
			end
		end
	end

	return preference
end

evaluate.parse_preference_string = function(preference)
	local parts = utils.Split(preference, "|")

	local setting = parts[1]
	local quantity = tonumber(parts[2])
	local list = parts[3]

	return {
		["setting"] = setting,
		["quantity"] = quantity,
		["list"] = list,
	}
end

evaluate.convert_rule_preference = function(item, preference)
	local converted = utils.ShallowCopy(preference)

	if type(converted) == "string" then
		return evaluate.parse_preference_string(preference)
	end

	if type(converted["setting"]) == "function" then
		converted["setting"] = converted["setting"](item)
	end

	if type(converted["quantity"]) == "function" then
		converted["quantity"] = converted["quantity"](item)
	end

	if type(converted["list"]) == "function" then
		converted["list"] = converted["list"](item)
	end

	return converted
end

evaluate.get_loot_preference = function(item, loot, char_settings, unmatched_item_rule)
	local preference = nil

	if loot.loot_items then
		preference = evaluate.check_loot_items(item, loot.loot_items)
	end

	if preference == nil and char_settings[loader.types.items] then
		preference = evaluate.check_loot_items(item, char_settings[loader.types.items])
	end

	if preference == nil and char_settings[loader.types.sets] then
		preference =
			evaluate.check_loot_sets(item, loot.loot_conditions, loot.loot_sets, char_settings[loader.types.sets])
	end

	if preference == nil and unmatched_item_rule then
		preference = unmatched_item_rule
	end

	return preference
end

evaluate.is_item_in_saved_slot = function(item, char_settings)
	if item.Name() then
		local saved = char_settings.saved

		if saved then
			for i in ipairs(saved) do
				local slots = saved[i]
				local slots_match = false

				if slots.itemslot then
					if slots.itemslot == item.ItemSlot() then
						slots_match = true
					end

					if slots.itemslot2 then
						if slots.itemslot2 ~= item.ItemSlot2() then
							slots_match = false
						end
					end
				end

				if slots_match then
					return true
				end
			end
		end
	end

	return false
end

evaluate.is_valid_preference = function(loot_preferences, preference)
	for name in pairs(loot_preferences) do
		if name == preference.setting then
			return true
		end
	end

	return false
end

return evaluate
