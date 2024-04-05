---@type Mq
local mq = require("mq")

local function condition(item)
	return true
end

return { condition_func = condition }
