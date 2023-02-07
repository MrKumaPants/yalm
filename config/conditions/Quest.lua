---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Quest()
end

return { condition_func = condition }
