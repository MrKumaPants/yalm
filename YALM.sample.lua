-- Persistent Data
local multiRefObjects = {} -- multiRefObjects
local obj1 = {
	["items"] = {},
	["settings"] = {
		["unmatched_item_rule"] = {
			["setting"] = "Keep",
		},
		["frequency"] = 250,
		["always_loot"] = true,
		["distribute_delay"] = "1s",
		["unmatched_item_delay"] = "10s",
		["dannet_delay"] = 250,
		["save_slots"] = 3,
	},
	["categories"] = {
		[1] = "Configuration",
		[2] = "Item",
	},
	["conditions"] = {
		["FoodDrink"] = {
			["category"] = "",
			["name"] = "FoodDrink",
		},
		["Tradeskill"] = {
			["category"] = "",
			["name"] = "Tradeskill",
		},
		["Money"] = {
			["category"] = "",
			["name"] = "Money",
		},
		["Temporary"] = {
			["category"] = "",
			["name"] = "Temporary",
		},
		["Quest"] = {
			["category"] = "",
			["name"] = "Quest",
		},
		["Augmentation"] = {
			["category"] = "",
			["name"] = "Augmentation",
		},
		["Scrolls"] = {
			["category"] = "",
			["name"] = "Scrolls",
		},
		["Defiant"] = {
			["category"] = "",
			["name"] = "Defiant",
		},
		["Collectible"] = {
			["category"] = "",
			["name"] = "Collectible",
		},
		["Poisons"] = {
			["category"] = "",
			["name"] = "Poisons",
		},
	},
	["preferences"] = {
		["Keep"] = {
			["name"] = "Keep",
		},
		["Destroy"] = {
			["name"] = "Destroy",
			["leave"] = true,
		},
		["Sell"] = {
			["name"] = "Sell",
		},
		["Buy"] = {
			["name"] = "Buy",
		},
		["Guild"] = {
			["name"] = "Guild",
		},
		["Ignore"] = {
			["name"] = "Ignore",
			["leave"] = true,
		},
	},
	["commands"] = {
		["Buy"] = {
			["name"] = "Buy",
			["trigger"] = "buy",
			["help"] = "Buys designated items from the targeted merchant",
			["category"] = "Item",
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
			["help"] = "Convert Lootly loot file to YALM",
			["category"] = "Item",
		},
		["Destroy"] = {
			["name"] = "Destroy",
			["trigger"] = "destroy",
			["help"] = "Destroy any designated items in your bags",
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
			["args"] = "<item> <preference> [global|character]",
			["name"] = "SetItem",
			["trigger"] = "setitem",
			["help"] = "Set loot preference for item on cursor or by name",
			["category"] = "Item",
		},
	},
	["rules"] = {
		["Rank 2 Spells"] = {
			["category"] = "",
			["load"] = {
				["always"] = false,
				["characters"] = "",
				["class"] = "",
				["zone"] = "",
			},
			["name"] = "Rank 2 Spells",
		},
		["Leveling"] = {
			["category"] = "",
			["load"] = {
				["always"] = false,
				["characters"] = "",
				["class"] = "",
				["zone"] = "",
			},
			["name"] = "Leveling",
		},
		["Reagents"] = {
			["category"] = "",
			["load"] = {
				["always"] = false,
				["characters"] = "",
				["class"] = "",
				["zone"] = "",
			},
			["name"] = "Reagents",
		},
		["Defiant"] = {
			["category"] = "",
			["load"] = {
				["always"] = false,
				["characters"] = "",
				["class"] = "",
				["zone"] = "",
			},
			["name"] = "Defiant",
		},
		["Default"] = {
			["category"] = "",
			["load"] = {
				["always"] = false,
				["characters"] = "",
				["class"] = "",
				["zone"] = "",
			},
			["name"] = "Default",
		},
	},
}
return obj1
