-- Persistent Data
local multiRefObjects = {} -- multiRefObjects
local obj1 = {
	["conditions"] = {
		[1] = {
			["name"] = "Quest",
			["setting"] = "Destroy",
		},
		[2] = {
			["name"] = "Augmentation",
			["setting"] = "Destroy",
		},
		[3] = {
			["name"] = "Poisons",
			["setting"] = "Destroy",
		},
		[4] = {
			["name"] = "FoodDrink",
			["setting"] = "Keep",
		},
		[5] = {
			["name"] = "Temporary",
			["setting"] = "Destroy",
		},
		[6] = {
			["name"] = "Scrolls",
			["setting"] = "Keep",
			["quantity"] = 1,
		},
		[7] = {
			["name"] = "Collectible",
			["setting"] = "Keep",
			["quantity"] = 1,
		},
	},
	["items"] = {},
}
return obj1
