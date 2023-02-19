---@type Mq
local mq = require("mq")

local loader = require("yalm.core.loader")

local serpent = require("yalm.lib.serpent")
local utils = require("yalm.lib.utils")

-- default application settings
local default_global_settings = {
	["categories"] = {
		[1] = "Configuration",
		[2] = "Item",
	},
	["commands"] = {
		["Buy"] = {
			["name"] = "Buy",
			["trigger"] = "buy",
			["help"] = "Buys designated items from the targeted merchant",
			["category"] = "Item",
		},
		["Character"] = {
			["name"] = "Character",
			["trigger"] = "char",
			["help"] = "Manage character. Type \ay/yalm char help\ax for more information.",
			["category"] = "Configuration",
		},
		["Check"] = {
			["name"] = "Check",
			["trigger"] = "check",
			["help"] = "Print loot preference for all items in inventory or item on cursor",
			["category"] = "Item",
		},
		["Command"] = {
			["name"] = "Command",
			["trigger"] = "command",
			["help"] = "Manage commands. Type \ay/yalm command help\ax for more information.",
			["category"] = "Configuration",
		},
		["Condition"] = {
			["name"] = "Condition",
			["trigger"] = "condition",
			["help"] = "Manage conditions. Type \ay/yalm condition help\ax for more information.",
			["category"] = "Configuration",
		},
		["Convert"] = {
			["name"] = "Convert",
			["trigger"] = "convert",
			["help"] = "Converts other loot systems to YALM. Type \ay/yalm convert help\ax for more information",
			["category"] = "Item",
		},
		["Destroy"] = {
			["name"] = "Destroy",
			["trigger"] = "destroy",
			["help"] = "Destroy any designated items in your bags",
			["category"] = "Item",
		},
		["Donate"] = {
			["args"] = "[guild|me]",
			["name"] = "Donate",
			["trigger"] = "donate",
			["help"] = "Donates designated items",
			["category"] = "Item",
		},
		["Guild"] = {
			["name"] = "Guild",
			["trigger"] = "guild",
			["help"] = "Deposits designated items into the guild bank",
			["category"] = "Item",
		},
		["Rule"] = {
			["name"] = "Rule",
			["trigger"] = "rule",
			["help"] = "Manage rules. Type \ay/yalm rule help\ax for more information.",
			["category"] = "Configuration",
		},
		["Sell"] = {
			["name"] = "Sell",
			["trigger"] = "sell",
			["help"] = "Sells designated items to the targeted merchant",
			["category"] = "Item",
		},
		["SetItem"] = {
			["args"] = "<item> <preference> (all|me)",
			["name"] = "SetItem",
			["trigger"] = "setitem",
			["help"] = "Set loot preference for item on cursor or by name",
			["category"] = "Item",
		},
		["Simulate"] = {
			["name"] = "Simulate",
			["trigger"] = "simulate",
			["help"] = "Simulate looting item on cursor or by name",
			["category"] = "Item",
		},
	},
	["conditions"] = {},
	["items"] = {},
	["preferences"] = {
		["Buy"] = {
			["name"] = "Buy",
		},
		["Destroy"] = {
			["name"] = "Destroy",
			["leave"] = true,
		},
		["Guild"] = {
			["name"] = "Guild",
		},
		["Ignore"] = {
			["name"] = "Ignore",
			["leave"] = true,
		},
		["Keep"] = {
			["name"] = "Keep",
		},
		["Sell"] = {
			["name"] = "Sell",
		},
		["Tribute"] = {
			["name"] = "Tribute",
		},
	},
	["rules"] = {},
	["settings"] = {
		["always_loot"] = true,
		["distribute_delay"] = "1s",
		["frequency"] = 250,
		["save_slots"] = 3,
		["unmatched_item_delay"] = "10s",
		["dannet_delay"] = 250,
		["unmatched_item_rule"] = {
			["setting"] = "Keep",
		},
	},
}

-- default yalm configuration settings
local default_yalm_settings = {
	["categories"] = {},
	["commands"] = {},
	["conditions"] = {},
	["items"] = {},
	["preferences"] = {},
	["rules"] = {},
	["settings"] = {
		["always_loot"] = true,
		["save_slots"] = 3,
		["unmatched_item_rule"] = {
			["setting"] = "Keep",
		},
	},
}

-- default char settings
local default_char_settings = {
	["items"] = {},
	["settings"] = {},
	["save"] = {},
	["rules"] = {},
}

local settings = {}

settings.init_char_settings = function(character)
	local char_settings = settings.load_char_settings(character)
	local default_copy = utils.deep_copy(default_char_settings)
	char_settings = utils.merge(default_copy, char_settings)

	return char_settings
end

settings.load_char_settings = function(character)
	local char_settings

	local filename = ("%s/YALM/yalm-%s-%s.lua"):format(
		mq.configDir,
		mq.TLO.EverQuest.Server(),
		character or mq.TLO.Me.CleanName():lower()
	)
	if not utils.file_exists(filename) then
		char_settings = default_char_settings
		settings.save_char_settings(char_settings)
	else
		local module, error = loadfile(filename)()
		char_settings = module
	end

	return char_settings
end

settings.init_global_settings = function()
	local global_settings = settings.load_global_settings()

	local default_copy = utils.deep_copy(default_global_settings)
	global_settings["categories"] = utils.table_concat(default_copy["categories"], global_settings["categories"])
	global_settings["commands"] = utils.merge(global_settings["commands"], default_copy["commands"])
	global_settings["settings"] = utils.merge(global_settings["settings"], default_copy["settings"])
	global_settings["preferences"] = utils.merge(global_settings["preferences"], default_copy["preferences"])

	return global_settings
end

settings.load_global_settings = function()
	local global_settings

	local filename = ("%s/YALM.lua"):format(mq.configDir)

	if not utils.file_exists(filename) then
		global_settings = default_yalm_settings
		settings.save_global_settings(default_yalm_settings)
	else
		local module, error = loadfile(filename)()
		global_settings = module
	end

	return global_settings
end

settings.init_settings = function(character)
	assert(utils.make_dir(mq.configDir, "YALM"))

	local global_settings = settings.init_global_settings()
	local char_settings = settings.init_char_settings(character)

	if char_settings.settings then
		utils.merge(global_settings.settings, char_settings.settings)
	end

	return global_settings, char_settings
end

settings.save_global_settings = function(global_settings)
	local content = serpent.dump(global_settings, { compact = false, indent = "   ", sortkeys = true, sparse = true })
	utils.write_file(("%s/YALM.lua"):format(mq.configDir), content)
end

settings.save_char_settings = function(char_settings)
	local content = serpent.dump(char_settings, { compact = false, indent = "   ", sortkeys = true, sparse = true })
	utils.write_file(
		("%s/YALM/yalm-%s-%s.lua"):format(mq.configDir, mq.TLO.EverQuest.Server(), mq.TLO.Me.CleanName():lower()),
		content
	)
end

settings.remove_global_settings = function(loader_type, key)
	if not loader.types[loader_type] then
		Write.Error("%s is not a valid global key", loader_type)
		return
	end

	local global_settings = settings.load_global_settings()

	if type(key) == "number" then
		table.remove(global_settings[loader_type], key)
	else
		global_settings[loader_type][key] = nil
	end

	settings.save_global_settings(global_settings)
end

settings.set_global_settings = function(loader_type, tables)
	if not loader.types[loader_type] then
		Write.Error("%s is not a valid global key", loader_type)
		return
	end

	local global_settings = settings.load_global_settings()
	utils.merge(global_settings[loader_type], tables)

	settings.save_global_settings(global_settings)
end

settings.remove_and_save_global_settings = function(global_settings, loader_type, key)
	if not loader.types[loader_type] then
		Write.Error("%s is not a valid global key", loader_type)
		return
	end

	if type(key) == "number" then
		table.remove(global_settings[loader_type], key)
	else
		global_settings[loader_type][key] = nil
	end

	settings.remove_global_settings(loader_type, key)
end

settings.update_and_save_global_settings = function(global_settings, loader_type, tables)
	if not loader.types[loader_type] then
		Write.Error("%s is not a valid global key", loader_type)
		return
	end

	utils.merge(global_settings[loader_type], tables)
	settings.set_global_settings(loader_type, tables)
end

return settings
