---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Name():find("Defiant") and item.WornSlots() > 0
end

return { condition_func = condition }
