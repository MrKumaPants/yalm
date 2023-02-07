---@type Mq
local mq = require("mq")

local loader = require("yalm.classes.loader")

local persistence = require("yalm.lib.persistence")
local utils = require("yalm.lib.utils")

-- default application settings
local default_settings = {
	["categories"] = {},
	["commands"] = {
		["Buy"] = {
			["name"] = "Buy",
			["trigger"] = "buy",
			["help"] = "Buys designated items from the targeted merchant",
		},
		["Check"] = {
			["name"] = "Check",
			["trigger"] = "check",
			["help"] = "Print loot preference for all items in inventory",
		},
		["Convert"] = {
			["name"] = "Convert",
			["trigger"] = "convert",
			["help"] = "Convert Lootly loot file to YALM",
		},
		["Destroy"] = {
			["name"] = "Destroy",
			["trigger"] = "destroy",
			["help"] = "Destroy any designated items in your bags",
		},
		["Guild"] = {
			["name"] = "Guild",
			["trigger"] = "guild",
			["help"] = "Deposits designated items into the guild bank",
		},
		["Sell"] = {
			["name"] = "Sell",
			["trigger"] = "sell",
			["help"] = "Sells designated items to the targeted merchant",
		},
		["SetItem"] = {
			["name"] = "SetItem",
			["trigger"] = "setitem",
			["help"] = "Set loot preference for item on cursor or by name",
		},
	},
	["conditions"] = {},
	["items"] = {},
	["settings"] = {
		["always_loot"] = true,
		["distribute_delay"] = "1s",
		["frequency"] = 250,
		["save_slots"] = 3,
		["unmatched_item_delay"] = "10s",
		["dannet_delay"] = 150,
		["unmatched_item_rule"] = {
			["setting"] = "Keep",
		},
	},
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
	},
	["sets"] = {},
}

local settings = {}

settings.init_char_settings = function()
	local char_settings

	local filename = ("%s/YALM/yalm-%s-%s.lua"):format(
		mq.configDir,
		mq.TLO.EverQuest.Server(),
		mq.TLO.Me.CleanName():lower()
	)
	if not utils.FileExists(filename) then
		char_settings = {
			items = {},
			settings = {},
			sets = {},
		}
		settings.save_character_settings(char_settings)
	else
		local module, error = loadfile(filename)()
		char_settings = module
	end

	return char_settings
end

settings.init_global_settings = function()
	local global_settings

	local filename = ("%s/YALM.lua"):format(mq.configDir)

	if not utils.FileExists(filename) then
		global_settings = default_settings
		settings.save_global_settings(default_settings)
	else
		local module, error = loadfile(filename)()
		global_settings = module
	end

	local default_copy = utils.ShallowCopy(default_settings)
	global_settings = utils.Merge(default_copy, global_settings)

	return global_settings
end

settings.init_settings = function()
	assert(utils.MakeDir(mq.configDir, "YALM"))

	local global_settings = settings.init_global_settings()
	local char_settings = settings.init_char_settings()

	if char_settings.settings then
		utils.Merge(global_settings.settings, char_settings.settings)
	end

	return global_settings, char_settings
end

settings.save_global_settings = function(settings)
	persistence.store(("%s/YALM.lua"):format(mq.configDir), settings)
end

settings.save_character_settings = function(char_settings)
	persistence.store(
		("%s/YALM/yalm-%s-%s.lua"):format(mq.configDir, mq.TLO.EverQuest.Server(), mq.TLO.Me.CleanName():lower()),
		char_settings
	)
end

settings.set_global_settings = function(type, tables)
	if not loader.types[type] then
		Write.Error("%s is not a valid global key", type)
		return
	end

	local global_settings = settings.init_global_settings()
	utils.Merge(global_settings[type], tables)

	settings.save_global_settings(global_settings)
end

settings.update_and_save_global_settings = function(global_settings, type, tables)
	if not loader.types[type] then
		Write.Error("%s is not a valid global key", type)
		return
	end

	utils.Merge(global_settings[type], tables)
	settings.set_global_setting(type, tables)
end

return settings
