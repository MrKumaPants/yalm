local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local inventory = require("yalm.core.inventory")

local Item = require("yalm.definitions.Item")

local database = require("yalm.lib.database")
local utils = require("yalm.lib.utils")

local evaluate = {}

evaluate.check_can_loot = function(member, item, loot, save_slots, dannet_delay, always_loot, unmatched_item_rule)
	local char_settings =
		evaluate.get_member_char_settings(member, save_slots, dannet_delay, always_loot, unmatched_item_rule)

	local char_save_slots = char_settings.settings.save_slots
	local char_dannet_delay = char_settings.settings.dannet_delay
	local char_always_loot = char_settings.settings.always_loot
	local char_unmatched_item_rule = char_settings.settings.unmatched_item_rule

	local preference = evaluate.get_loot_preference(item, loot, char_settings, char_unmatched_item_rule)

	local can_loot = evaluate.check_loot_preference(preference, loot)

	if can_loot then
		can_loot = inventory.check_group_member(member, preference.list, char_dannet_delay, char_always_loot)
	end

	local check_rematch = true

	if can_loot then
		can_loot = inventory.check_lore(member, item, char_dannet_delay)
		check_rematch = can_loot
	end

	if can_loot then
		local total_save_slots =
			inventory.check_total_save_slots(member, char_settings, char_save_slots, char_dannet_delay)
		can_loot = inventory.check_inventory(member, item, total_save_slots, char_dannet_delay)
		check_rematch = can_loot
	end

	if can_loot then
		can_loot = inventory.check_quantity(member, item, preference.quantity, char_dannet_delay, char_always_loot)
	end

	return can_loot, check_rematch, preference
end

evaluate.check_loot_conditions = function(item, loot_helpers, loot_conditions, set_conditions)
	local preference

	for i in ipairs(set_conditions) do
		local func, condition = nil, set_conditions[i]
		if loot_conditions[condition.name] and loot_conditions[condition.name].loaded then
			func = loot_conditions[condition.name].func.condition_func
		elseif loot_helpers[condition.name] and loot_helpers[condition.name].loaded then
			func = loot_helpers[condition.name].func.helper_func
		end

		if func then
			local success, result = pcall(func, item)
			if success and result then
				preference = evaluate.convert_rule_preference(item, loot_helpers, condition)
				break
			elseif not success and result then
				Write.Error(result)
			end
		end
	end

	return preference
end

evaluate.check_loot_items = function(item, loot_helpers, loot_items)
	local preference

	if loot_items[item.Name()] then
		preference = evaluate.convert_rule_preference(item, loot_helpers, loot_items[item.Name()])
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

evaluate.check_loot_rules = function(item, loot_helpers, loot_conditions, loot_rules, char_rules)
	local preference

	for i in ipairs(char_rules) do
		local rule = char_rules[i]
		if loot_rules[rule.name] and rule.enabled then
			if loot_rules[rule.name][configuration.types.item.settings_key] then
				preference = evaluate.check_loot_items(
					item,
					loot_helpers,
					loot_rules[rule.name][configuration.types.item.settings_key]
				)
			end
			if preference == nil and loot_rules[rule.name][configuration.types.condition.settings_key] then
				preference = evaluate.check_loot_conditions(
					item,
					loot_helpers,
					loot_conditions,
					loot_rules[rule.name][configuration.types.condition.settings_key]
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

	local setting = utils.title_case(tostring(parts[1]))
	local quantity = tonumber(parts[2])
	local list = parts[3] and utils.split(parts[3], ",") or nil

	return {
		["setting"] = setting,
		["quantity"] = quantity,
		["list"] = list,
	}
end

evaluate.convert_rule_preference = function(item, helpers, preference)
	local converted = utils.shallow_copy(preference)

	if type(preference) == "string" then
		return evaluate.parse_preference_string(preference)
	end

	local setting_function = helpers[preference["setting"]]
	if setting_function and setting_function.loaded then
		converted["setting"] = setting_function.func.helper_func(item)
	end

	local quantity_function = helpers[preference["quantity"]]
	if quantity_function and quantity_function.loaded then
		converted["quantity"] = quantity_function.func.helper_func(item)
	end

	local list_function = helpers[preference["list"]]
	if list_function and list_function.loaded then
		converted["list"] = list_function.func.helper_func(item)
	end

	return converted
end

evaluate.get_member_char_settings = function(member, save_slots, dannet_delay, always_loot, unmatched_item_rule)
	local char_name = member.CleanName():lower()

	local char_settings = settings.init_char_settings(char_name)

	if char_settings.settings.save_slots == nil then
		char_settings.settings.save_slots = save_slots
	end

	if char_settings.settings.dannet_delay == nil then
		char_settings.settings.dannet_delay = dannet_delay
	end

	if char_settings.settings.always_loot == nil then
		char_settings.settings.always_loot = always_loot
	end

	if char_settings.settings.unmatched_item_rule == nil then
		char_settings.settings.unmatched_item_rule = unmatched_item_rule
	end

	return char_settings
end

evaluate.get_loot_item = function(item)
	local loot_item = item

	-- this is an advlootitem
	if item.Index and item.ID() then
		loot_item = Item:new(nil, database.QueryDatabaseForItemId(item.ID()))

		if not loot_item.item_db then
			Write.Error("Item id \at%s\ax does not exist", item.ID())
			loot_item = Item:new(nil, database.QueryDatabaseForItemName(item.Name()))
		end

		if not loot_item.item_db then
			Write.Error("Item \at%s\ax does not exist", item.Name())
			loot_item = nil
		end
	end

	return loot_item
end

evaluate.get_loot_preference = function(item, loot, char_settings, unmatched_item_rule)
	local preference

	local loot_item = evaluate.get_loot_item(item)

	if loot_item ~= nil then
		if char_settings[configuration.types.item.settings_key] then
			preference = evaluate.check_loot_items(loot_item, loot.helpers, char_settings[configuration.types.item.settings_key])
		end

		if preference == nil and loot.items then
			preference = evaluate.check_loot_items(loot_item, loot.helpers, loot.items)
		end

		if preference == nil and char_settings[configuration.types.rule.settings_key] then
			preference = evaluate.check_loot_rules(
				loot_item,
				loot.helpers,
				loot.conditions,
				loot.rules,
				char_settings[configuration.types.rule.settings_key]
			)
		end
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
