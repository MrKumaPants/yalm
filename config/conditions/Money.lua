---@type Mq
local mq = require("mq")

local function condition(item)
	if mq.TLO.Merchant.Open() then
		return item.SellPrice() * (1 / mq.TLO.Merchant.Markup()) > 1000
	end
	-- aproximate the lowest price it could be
	return item.SellPrice() * (1 / 1.05) > 1000
end

return { condition_func = condition }
