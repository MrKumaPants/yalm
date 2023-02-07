---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Collectible()
end

return { condition_func = condition }
