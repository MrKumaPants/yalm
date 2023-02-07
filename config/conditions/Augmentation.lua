---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Type() == "Augmentation"
end

return { condition_func = condition }
