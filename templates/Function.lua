---@type Mq
local mq = require("mq")

local function helper(item)
	return true
end

return { helper_func = helper }
