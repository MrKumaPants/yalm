do
	local _ = {
		categories = {},
		commands = {},
		conditions = {},
		items = {},
		preferences = {},
		rules = {},
		settings = {
			always_loot = true,
			save_slots = 3,
			unmatched_item_rule = {
				setting = "Keep",
			},
		},
	}
	return _
end
