local mq = require("mq")

local dannet = {}

dannet.query = function(peer, query, timeout)
	mq.cmdf('/dquery %s -q "%s"', peer, query)
	mq.delay(timeout or 1000)
	local value = mq.TLO.DanNet(peer).Q(query)()
	return value
end

dannet.observe = function(peer, query, timeout)
	if not mq.TLO.DanNet(peer).OSet(query)() then
		mq.cmdf('/dobserve %s -q "%s"', peer, query)
	end
	mq.delay(timeout or 1000, function()
		return mq.TLO.DanNet(peer).O(query).Received() > 0
	end)
	local value = mq.TLO.DanNet(peer).O(query)()
	return value
end

dannet.unobserve = function(peer, query)
	mq.cmdf('/dobserve %s -q "%s" -drop', peer, query)
end

return dannet
