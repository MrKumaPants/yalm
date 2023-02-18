-- Persistent Data
local multiRefObjects = {} -- multiRefObjects
local obj1 = {
	["conditions"] = {
		[1] = {
			["name"] = "Temporary",
			["setting"] = "Destroy",
		},
		[2] = {
			["name"] = "Poisons",
			["setting"] = "Destroy",
			["list"] = "ROG",
		},
		[3] = {
			["name"] = "Scrolls",
			["setting"] = "Keep",
			["quantity"] = 1,
		},
		[4] = {
			["name"] = "Money",
			["setting"] = "Sell",
		},
		[5] = {
			["name"] = "Collectible",
			["setting"] = "Keep",
			["quantity"] = 10,
		},
		[6] = {
			["name"] = "Tradeskill",
			["setting"] = "Keep",
		},
		[7] = {
			["name"] = "Ornament",
			["setting"] = "Guild",
		},
	},
	["items"] = {},
}
return obj1
