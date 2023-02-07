---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Type() == "Potion" and item.Class("ROG") == "Rogue"
end

return { condition_func = condition }
