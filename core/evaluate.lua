local settings = require("yalm.config.settings")

local inventory = require("yalm.core.inventory")
local loader = require("yalm.core.loader")

local Item = require("yalm.definitions.Item")

local database = require("yalm.lib.database")
local utils = require("yalm.lib.utils")

local inspect = require("yalm.lib.inspect")

local evaluate = {}

evaluate.check_can_loot = function(member, item, loot, save_slots, dannet_delay, always_loot, unmatched_item_rule)
	local preference = evaluate.get_loot_preference_for_member(member, item, loot, unmatched_item_rule)

	local can_loot = evaluate.check_loot_preference(preference, loot)

	if can_loot then
		can_loot = inventory.check_group_member(member, preference.list, dannet_delay, always_loot)
	end

	if can_loot then
		can_loot = inventory.check_inventory(member, item, save_slots, dannet_delay)
	end

	if can_loot then
		can_loot = inventory.check_quantity(member, item, preference.quantity, dannet_delay, always_loot)
	end

	if can_loot then
		can_loot = inventory.check_lore(member, item, dannet_delay)
	end

	return can_loot, preference
end

evaluate.check_loot_conditions = function(item, loot_conditions, set_conditions)
	local preference = nil

	for i in ipairs(set_conditions) do
		local condition = set_conditions[i]
		if loot_conditions[condition.name] and loot_conditions[condition.name].loaded then
			local condition_item = item
			-- this is an advlootitem
			if condition_item.Index and item.ID() then
				condition_item = Item:new(nil, database.QueryDatabaseForItemId(item.ID()))
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

evaluate.check_loot_preference = function(preference, loot)
	if not preference then
		return false
	end

	if not evaluate.is_valid_preference(loot.preferences, preference) then
		return false
	end

	if loot.preferences[preference.setting].leave then
		return false
	end

	return true
end

evaluate.check_loot_rules = function(item, loot_conditions, loot_rules, char_rules)
	local preference = nil

	for i in ipairs(char_rules) do
		local rule = char_rules[i]
		if rule.enabled and loot_rules[rule.name].loaded then
			if loot_rules[rule.name][loader.types.items] then
				preference = evaluate.check_loot_items(item, loot_rules[rule.name][loader.types.items])
			end
			if preference == nil and loot_rules[rule.name][loader.types.conditions] then
				preference = evaluate.check_loot_conditions(
					item,
					loot_conditions,
					loot_rules[rule.name][loader.types.conditions]
				)
			end
			if preference then
				break
			end
		end
	end

	return preference
end

evaluate.parse_preference_string = function(preference)
	local parts = utils.split(preference, "|")

	local setting = parts[1]
	local quantity = tonumber(parts[2])
	local list = parts[3] and utils.split(parts[3], ",") or nil

	return {
		["setting"] = setting,
		["quantity"] = quantity,
		["list"] = list,
	}
end

evaluate.convert_rule_preference = function(item, preference)
	local converted = utils.shallow_copy(preference)

	if type(preference) == "string" then
		return evaluate.parse_preference_string(preference)
	end

	if type(preference["setting"]) == "function" then
		converted["setting"] = preference["setting"](item)
	end

	if type(preference["quantity"]) == "function" then
		converted["quantity"] = preference["quantity"](item)
	end

	if type(preference["list"]) == "function" then
		converted["list"] = preference["list"](item)
	end

	return converted
end

evaluate.get_loot_preference_for_member = function(member, item, loot, unmatched_item_rule)
	local merged_unmatched_item_rule = nil

	local char_name = member.CleanName():lower()

	local char_settings = settings.init_char_settings(char_name)

	if unmatched_item_rule then
		merged_unmatched_item_rule = char_settings.unmatched_item_rule or unmatched_item_rule
	end

	local preference = evaluate.get_loot_preference(item, loot, char_settings, merged_unmatched_item_rule)

	return preference
end

evaluate.get_loot_preference = function(item, loot, char_settings, unmatched_item_rule)
	local preference = nil

	if loot.items then
		preference = evaluate.check_loot_items(item, loot.items)
	end

	if preference == nil and char_settings[loader.types.items] then
		preference = evaluate.check_loot_items(item, char_settings[loader.types.items])
	end

	if preference == nil and char_settings[loader.types.rules] then
		preference = evaluate.check_loot_rules(item, loot.conditions, loot.rules, char_settings[loader.types.rules])
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
