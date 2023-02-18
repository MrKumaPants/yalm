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
	["categories"] = {},
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
	["preferences"] = {},
	["commands"] = {},
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
