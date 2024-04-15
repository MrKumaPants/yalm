local utils = require("yalm.lib.utils")

local configuration = {
	types = {
		category = {
			name = "category",
			settings_key = "categories",
		},
		character = {
			name = "character",
			settings = {
				always_loot = "boolean",
				distribute_delay = "time",
				frequency = "time",
				log_level = "string",
				save_slots = "number",
				unmatched_item_delay = "time",
				dannet_delay = "time",
				unmatched_item_rule = "string",
			},
		},
		command = {
			name = "command",
			settings_key = "commands",
			settings = {
				args = "string",
				category = "string",
				help = "string",
				trigger = "string",
			},
			should_load = true,
		},
		condition = {
			name = "condition",
			settings_key = "conditions",
			settings = {
				category = "string",
			},
			should_load = true,
		},
		helper = {
			name = "helper",
			settings_key = "helpers",
			settings = {
				category = "string",
			},
			should_load = true,
		},
		item = {
			name = "item",
			settings_key = "items",
			settings = {
				category = "string",
				list = "string",
				quantity = "number|string",
				setting = "string",
			},
		},
		preference = {
			name = "preference",
			settings_key = "preferences",
			settings = {
				leave = "boolean",
			},
		},
		rule = {
			name = "rule",
			settings_key = "rules",
			settings = {
				category = "string",
			},
		},
		setting = {
			name = "settings",
			settings = {
				always_loot = "boolean",
				dannet_delay = "time",
				distribute_delay = "time",
				do_raid_loot = "boolean",
				frequency = "time",
				log_level = "string",
				save_slots = "number",
				unmatched_item_delay = "time",
				unmatched_item_rule = "string",
			},
			settings_key = "settings",
		},
		subcommand = {
			name = "subcommand",
			settings_key = "subcommands",
			settings = {
				args = "string",
				category = "string",
				help = "string",
				trigger = "string",
			},
			should_load = true,
		},
	},
}

configuration.print_type_help = function(global_settings, settings_key, type)
	local category_map = {}

	if not global_settings[settings_key] then
		return
	end

	for _, command in pairs(global_settings[settings_key]) do
		local category = command.category or "Uncategorized"
		if not category_map[category] then
			category_map[category] = {}
		end
		table.insert(category_map[category], command)
	end

	for category, entry in pairs(category_map) do
		Write.Help("\ax%s Commands Available:", category)
		table.sort(entry, function(left, right)
			return left.name < right.name
		end)
		for i in ipairs(entry) do
			local command = entry[i]
			if command.loaded then
				local message = "\t  \ay/yalm"

				if type then
					message = ("%s %s"):format(message, type)
				end

				message = ("%s %s"):format(message, command.trigger)

				if command.args then
					message = ("%s %s\ax"):format(message, command.args)
				else
					message = ("%s\ax"):format(message)
				end

				if command.help then
					message = ("%s -- %s"):format(message, command.help)
				end

				if type then
					Write.Help(message, type)
				else
					Write.Help(message)
				end
			end
		end
	end
end

configuration.action = function(subcommands, global_settings, char_settings, type, args)
	local subcommand

	if not args[2] then
		subcommand = "help"
	else
		subcommand = args[2]
	end

	if not subcommands[subcommand] then
		Write.Error("\at%s\ax is not a valid subcommand", subcommand)
		return
	end

	if subcommands[subcommand].func then
		subcommands[subcommand].func.action_func(global_settings, char_settings, type, args)
		return
	end

	local loot_subcommand = utils.find_by_key(global_settings.subcommands, "trigger", subcommand)

	if loot_subcommand then
		local success, result =
			pcall(loot_subcommand.func.action_func, type, subcommands, global_settings, char_settings, args)
		if not success then
			Write.Warn("Running subcommand failed: %s - %s", loot_subcommand.name, result)
		end
		return
	end

	Write.Error("\at%s\ax is not a valid subcommand", subcommand)
end

return configuration
