---@type Mq
local mq = require("mq")

local function condition(item)
	return item.Name():find("Ornament")
end

return { condition_func = condition }
