-- Persistent Data
local multiRefObjects = {} -- multiRefObjects
local obj1 = {
	["items"] = {},
	["rules"] = {
		[1] = {
			["name"] = "Reagents",
			["enabled"] = true,
		},
		[2] = {
			["name"] = "Defiant",
			["enabled"] = true,
		},
		[3] = {
			["name"] = "Leveling",
			["enabled"] = true,
		},
	},
	["settings"] = {
		["unmatched_item_rule"] = {
			["setting"] = "Sell",
		},
	},
}
return obj1
