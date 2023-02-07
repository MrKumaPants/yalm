---@type Mq
local mq = require("mq")

local function condition(item)
	return item.EffectType() == "Spell Scroll"
end

return { condition_func = condition }
