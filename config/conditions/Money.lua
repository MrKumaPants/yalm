---@type Mq
local mq = require("mq")

local function condition(item)
	if mq.TLO.Merchant.Open() then
		return item.Merchant.BuyPrice() > 1000
	end
	-- aproximate the lowest price it could be
	return item.Value() * (1 / 1.05) > 1000
end

return { condition_func = condition }
