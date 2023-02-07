---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Type() == "Food" or item.Type() == "Drink"
end

return { condition_func = condition }
