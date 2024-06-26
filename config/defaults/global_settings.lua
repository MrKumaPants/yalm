return {
	["categories"] = {
		[1] = "Class",
		[2] = "Configuration",
		[3] = "Helper",
		[4] = "Item",
		[5] = "NPC",
	},
	["character"] = {},
	["commands"] = {
		["Bank"] = {
			["name"] = "Bank",
			["trigger"] = "bank",
			["help"] = "Deposits designated items into the personal bank",
			["category"] = "NPC",
		},
		["Buy"] = {
			["name"] = "Buy",
			["trigger"] = "buy",
			["help"] = "Buys designated items from the targeted merchant",
			["category"] = "NPC",
		},
		["Category"] = {
			["name"] = "Category",
			["trigger"] = "category",
			["help"] = "Manage categories. Type \ay/yalm category help\ax for more information.",
			["category"] = "Configuration",
		},
		["Character"] = {
			["name"] = "Character",
			["trigger"] = "character",
			["help"] = "Manage character. Type \ay/yalm character help\ax for more information.",
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
			["category"] = "Configuration",
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
			["category"] = "NPC",
		},
		["Helper"] = {
			["name"] = "Helper",
			["trigger"] = "helper",
			["help"] = "Manage helpers. Type \ay/yalm helper help\ax for more information.",
			["category"] = "Configuration",
		},
		["Preference"] = {
			["name"] = "Preference",
			["trigger"] = "preference",
			["help"] = "Manage preferences. Type \ay/yalm preference help\ax for more information.",
			["category"] = "Configuration",
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
			["category"] = "NPC",
		},
		["SetItem"] = {
			["args"] = "<item> <preference> (all|me)",
			["name"] = "SetItem",
			["trigger"] = "setitem",
			["help"] = "Set loot preference for item on cursor or by name",
			["category"] = "Item",
		},
		["Settings"] = {
			["name"] = "Settings",
			["trigger"] = "setting",
			["help"] = "Manage settings. Type \ay/yalm settings help\ax for more information.",
			["category"] = "Configuration",
		},
		["Simulate"] = {
			["name"] = "Simulate",
			["trigger"] = "simulate",
			["help"] = "Simulate looting item on cursor or by name",
			["category"] = "Item",
		},
		["Subcommand"] = {
			["name"] = "Subcommand",
			["trigger"] = "subcommand",
			["help"] = "Manage subcommands. Type \ay/yalm subcommand help\ax for more information.",
			["category"] = "Configuration",
		},
		["Tribute"] = {
			["args"] = "[guild|me]",
			["name"] = "Tribute",
			["trigger"] = "tribute",
			["help"] = "Donates designated items",
			["category"] = "NPC",
		},
	},
	["conditions"] = {
		["Augmentation"] = {
			["category"] = "",
			["name"] = "Augmentation",
		},
		["Collectible"] = {
			["category"] = "",
			["name"] = "Collectible",
		},
		["Defiant"] = {
			["category"] = "",
			["name"] = "Defiant",
		},
		["FoodDrink"] = {
			["category"] = "",
			["name"] = "FoodDrink",
		},
		["Money"] = {
			["category"] = "",
			["name"] = "Money",
		},
		["NoValue"] = {
			["category"] = "",
			["name"] = "NoValue",
		},
		["Ornament"] = {
			["category"] = "",
			["name"] = "Ornament",
		},
		["Poisons"] = {
			["category"] = "",
			["name"] = "Poisons",
		},
		["Quest"] = {
			["category"] = "",
			["name"] = "Quest",
		},
		["Scrolls"] = {
			["category"] = "",
			["name"] = "Scrolls",
		},
		["Temporary"] = {
			["category"] = "",
			["name"] = "Temporary",
		},
		["Tradeskill"] = {
			["category"] = "",
			["name"] = "Tradeskill",
		},
	},
	["helpers"] = {
		["GetClassList"] = {
			["name"] = "GetClassList",
		},
		["GetEquipmentQuantity"] = {
			["name"] = "GetEquipmentQuantity",
		},
	},
	["items"] = {},
	["preferences"] = {
		["Bank"] = {
			["name"] = "Bank",
		},
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
	["rules"] = {
		["BER"] = {
			["category"] = "Class",
			["name"] = "BER",
			["conditions"] = {},
			["items"] = {
				["Axe Components"] = {
					["quantity"] = 100,
					["setting"] = "Buy",
				},
				["Axe of the Annihilator"] = {
					["setting"] = "Keep",
				},
				["Balanced Axe Components"] = {
					["quantity"] = 100,
					["setting"] = "Buy",
				},
				["Basic Axe Components"] = {
					["quantity"] = 100,
					["setting"] = "Buy",
				},
				["Crafted Axe Components"] = {
					["quantity"] = 100,
					["setting"] = "Buy",
				},
				["Fine Axe Components"] = {
					["quantity"] = 100,
					["setting"] = "Buy",
				},
				["Honed Axe Components"] = {
					["quantity"] = 100,
					["setting"] = "Buy",
				},
				["Rage Axe"] = {
					["setting"] = "Keep",
				},
			},
		},
		["BRD"] = {
			["category"] = "Class",
			["name"] = "BRD",
			["conditions"] = {},
			["items"] = {},
		},
		["BST"] = {
			["category"] = "Class",
			["name"] = "BST",
			["conditions"] = {},
			["items"] = {},
		},
		["CLR"] = {
			["category"] = "Class",
			["name"] = "CLR",
			["conditions"] = {},
			["items"] = {},
		},
		["DRU"] = {
			["category"] = "Class",
			["name"] = "DRU",
			["conditions"] = {},
			["items"] = {
				["Fire Beetle Eye"] = {
					["setting"] = "Buy",
					["quantity"] = 10,
				},
			},
		},
		["ENC"] = {
			["category"] = "Class",
			["name"] = "ENC",
			["conditions"] = {},
			["items"] = {
				["Tiny Dagger"] = {
					["setting"] = "Buy",
					["quantity"] = 20,
				},
			},
		},
		["MAG"] = {
			["category"] = "Class",
			["name"] = "MAG",
			["conditions"] = {},
			["items"] = {
				["Malachite"] = {
					["setting"] = "Buy",
					["quantity"] = 20,
				},
			},
		},
		["MNK"] = {
			["category"] = "Class",
			["name"] = "MNK",
			["conditions"] = {},
			["items"] = {},
		},
		["NEC"] = {
			["category"] = "Class",
			["name"] = "NEC",
			["conditions"] = {},
			["items"] = {
				["Bone Chips"] = {
					["setting"] = "Buy",
					["quantity"] = 20,
				},
			},
		},
		["PAL"] = {
			["category"] = "Class",
			["name"] = "PAL",
			["conditions"] = {},
			["items"] = {},
		},
		["RNG"] = {
			["category"] = "Class",
			["name"] = "RNG",
			["conditions"] = {},
			["items"] = {
				["Arrow"] = {
					["setting"] = "Buy",
					["quantity"] = 500,
				},
				["Fire Beetle Eye"] = {
					["setting"] = "Buy",
					["quantity"] = 10,
				},
			},
		},
		["ROG"] = {
			["category"] = "Class",
			["name"] = "ROG",
			["conditions"] = {},
			["items"] = {},
		},
		["SHD"] = {
			["category"] = "Class",
			["name"] = "SHD",
			["conditions"] = {},
			["items"] = {
				["Bone Chips"] = {
					["setting"] = "Buy",
					["quantity"] = 20,
				},
			},
		},
		["SHM"] = {
			["category"] = "Class",
			["name"] = "SHM",
			["conditions"] = {},
			["items"] = {},
		},
		["WAR"] = {
			["category"] = "Class",
			["name"] = "WAR",
			["conditions"] = {},
			["items"] = {},
		},
		["WIZ"] = {
			["category"] = "Class",
			["name"] = "WIZ",
			["conditions"] = {},
			["items"] = {},
		},
	},
	["settings"] = {
		["always_loot"] = true,
		["dannet_delay"] = 250,
		["distribute_delay"] = "1s",
		["do_raid_loot"] = true,
		["frequency"] = 250,
		["log_level"] = "info",
		["save_slots"] = 3,
		["unmatched_item_delay"] = "10s",
		["unmatched_item_rule"] = {
			["setting"] = "Keep",
		},
	},
	["subcommands"] = {
		["Add"] = {
			["args"] = "<name>",
			["name"] = "Add",
			["trigger"] = "add",
			["help"] = "Adds a new %s with the given name",
			["category"] = "Helper",
		},
		["Create"] = {
			["args"] = "<name>",
			["name"] = "Create",
			["trigger"] = "create",
			["help"] = "Creates a new %s with the given name",
			["category"] = "Helper",
		},
		["Delete"] = {
			["args"] = "<name>",
			["name"] = "Delete",
			["trigger"] = "delete",
			["help"] = "Deletes a %s with the given name",
			["category"] = "Helper",
		},
		["Edit"] = {
			["args"] = "<name>",
			["name"] = "Edit",
			["trigger"] = "edit",
			["help"] = "Opens a %s with the given name in your preferred editor",
			["category"] = "Helper",
		},
		["Help"] = {
			["name"] = "Help",
			["trigger"] = "help",
			["help"] = "Display this help output",
			["category"] = "Helper",
		},
		["List"] = {
			["name"] = "List",
			["trigger"] = "list",
			["help"] = "List all available %s",
			["category"] = "Helper",
		},
		["Remove"] = {
			["args"] = "<name>",
			["name"] = "Remove",
			["trigger"] = "remove",
			["help"] = "Removes a new %s with the given name",
			["category"] = "Helper",
		},
		["Rename"] = {
			["args"] = "<name> <new_name>",
			["name"] = "Rename",
			["trigger"] = "rename",
			["help"] = "Renames a %s with the given name",
			["category"] = "Helper",
		},
		["Set"] = {
			["args"] = "<setting> <value>",
			["name"] = "Set",
			["trigger"] = "set",
			["help"] = "Updates setting to the given value",
			["category"] = "Helper",
		},
	},
}
