do
	local _ = {
		categories = {
			"Class",
			"Configuration",
			"Helper",
			"Item",
		},
		commands = {
			Buy = {
				name = "Buy",
				trigger = "buy",
				help = "Buys designated items from the targeted merchant",
				category = "Item",
			},
			Character = {
				name = "Character",
				trigger = "char",
				help = "Manage character. Type \ay/yalm char help\ax for more information.",
				category = "Configuration",
			},
			Check = {
				name = "Check",
				trigger = "check",
				help = "Print loot preference for all items in inventory or item on cursor",
				category = "Item",
			},
			Command = {
				name = "Command",
				trigger = "command",
				help = "Manage commands. Type \ay/yalm command help\ax for more information.",
				category = "Configuration",
			},
			Condition = {
				name = "Condition",
				trigger = "condition",
				help = "Manage conditions. Type \ay/yalm condition help\ax for more information.",
				category = "Configuration",
			},
			Convert = {
				name = "Convert",
				trigger = "convert",
				help = "Converts other loot systems to YALM. Type \ay/yalm convert help\ax for more information",
				category = "Item",
			},
			Destroy = {
				name = "Destroy",
				trigger = "destroy",
				help = "Destroy any designated items in your bags",
				category = "Item",
			},
			Donate = {
				args = "[guild|me]",
				name = "Donate",
				trigger = "donate",
				help = "Donates designated items",
				category = "Item",
			},
			Guild = {
				name = "Guild",
				trigger = "guild",
				help = "Deposits designated items into the guild bank",
				category = "Item",
			},
			Rule = {
				name = "Rule",
				trigger = "rule",
				help = "Manage rules. Type \ay/yalm rule help\ax for more information.",
				category = "Configuration",
			},
			Sell = {
				name = "Sell",
				trigger = "sell",
				help = "Sells designated items to the targeted merchant",
				category = "Item",
			},
			SetItem = {
				args = "<item> <preference> (all|me)",
				name = "SetItem",
				trigger = "setitem",
				help = "Set loot preference for item on cursor or by name",
				category = "Item",
			},
			Simulate = {
				name = "Simulate",
				trigger = "simulate",
				help = "Simulate looting item on cursor or by name",
				category = "Item",
			},
		},
		conditions = {},
		functions = {
			GetClassList = {
				name = "GetClassList",
			},
			GetEquipmentQuantity = {
				name = "GetEquipmentQuantity",
			},
		},
		items = {},
		preferences = {
			Buy = {
				name = "Buy",
			},
			Destroy = {
				name = "Destroy",
				leave = true,
			},
			Guild = {
				name = "Guild",
			},
			Ignore = {
				name = "Ignore",
				leave = true,
			},
			Keep = {
				name = "Keep",
			},
			Sell = {
				name = "Sell",
			},
			Tribute = {
				name = "Tribute",
			},
		},
		rules = {
			BER = {
				category = "Class",
				name = "BER",
				conditions = {},
				items = {},
			},
			BRD = {
				category = "Class",
				name = "BRD",
				conditions = {},
				items = {},
			},
			BST = {
				category = "Class",
				name = "BST",
				conditions = {},
				items = {},
			},
			CLR = {
				category = "Class",
				name = "CLR",
				conditions = {},
				items = {},
			},
			DRU = {
				category = "Class",
				name = "DRU",
				conditions = {},
				items = {
					["Fire Beetle Eye"] = {
						setting = "Buy",
						quantity = 10,
					},
				},
			},
			MNK = {
				category = "Class",
				name = "MNK",
				conditions = {},
				items = {},
			},
			NEC = {
				category = "Class",
				name = "NEC",
				conditions = {},
				items = {},
			},
			PAL = {
				category = "Class",
				name = "PAL",
				conditions = {},
				items = {},
			},
			RNG = {
				category = "Class",
				name = "RNG",
				conditions = {},
				items = {
					Arrow = {
						setting = "Buy",
						quantity = 500,
					},
					["Fire Beetle Eye"] = {
						setting = "Buy",
						quantity = 10,
					},
				},
			},
			ROG = {
				category = "Class",
				name = "ROG",
				conditions = {},
				items = {},
			},
			SHD = {
				category = "Class",
				name = "SHD",
				conditions = {},
				items = {},
			},
			SHM = {
				category = "Class",
				name = "SHM",
				conditions = {},
				items = {},
			},
			WAR = {
				category = "Class",
				name = "WAR",
				conditions = {},
				items = {},
			},
			WIZ = {
				category = "Class",
				name = "WIZ",
				conditions = {},
				items = {},
			},
		},
		settings = {
			always_loot = true,
			distribute_delay = "1s",
			frequency = 250,
			save_slots = 3,
			unmatched_item_delay = "10s",
			dannet_delay = 250,
			unmatched_item_rule = {
				setting = "Keep",
			},
		},
		subcommands = {
			Create = {
				args = "<name>",
				name = "Create",
				trigger = "create",
				help = "Creates a new %s with the given name",
				category = "Helper",
			},
			Delete = {
				args = "<name>",
				name = "Delete",
				trigger = "delete",
				help = "Deletes a %s with the given name",
				category = "Helper",
			},
			Edit = {
				args = "<name>",
				name = "Edit",
				trigger = "edit",
				help = "Opens a %s with the given name in your preferred editor",
				category = "Helper",
			},
			Help = {
				name = "Help",
				trigger = "help",
				help = "Display this help output",
				category = "Helper",
			},
			List = {
				name = "List",
				trigger = "list",
				help = "List all available %s",
				category = "Helper",
			},
			Rename = {
				args = "<name> <new_name>",
				name = "Rename",
				trigger = "rename",
				help = "Renames a %s with the given name",
				category = "Helper",
			},
			Set = {
				args = "<setting> <value>",
				name = "Set",
				trigger = "set",
				help = "Updates setting to the given value",
				category = "Helper",
			},
		},
	}
	return _
end
