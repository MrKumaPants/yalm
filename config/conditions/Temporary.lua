---@type Mq
local mq = require("mq")

local function condition(item)
	return item.NoRent()
end

return { condition_func = condition }
