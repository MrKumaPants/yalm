-- Persistent Data
local multiRefObjects = {} -- multiRefObjects
local obj1 = {
	["conditions"] = {
		[1] = {
			["name"] = "Money",
			["setting"] = "Sell",
		},
		[2] = {
			["name"] = "Quest",
			["setting"] = "Destroy",
		},
		[3] = {
			["name"] = "Augmentation",
			["setting"] = "Destroy",
		},
		[4] = {
			["name"] = "Poisons",
			["setting"] = "Destroy",
		},
		[5] = {
			["name"] = "FoodDrink",
			["setting"] = "Keep",
		},
		[6] = {
			["name"] = "Temporary",
			["setting"] = "Destroy",
		},
		[7] = {
			["name"] = "Scrolls",
			["setting"] = "Keep",
			["quantity"] = 1,
		},
		[8] = {
			["name"] = "Collectible",
			["setting"] = "Keep",
			["quantity"] = 1,
		},
	},
	["items"] = {},
}
return obj1
