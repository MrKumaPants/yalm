---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Value() == 0 or not item.Value()
end

return { condition_func = condition }
