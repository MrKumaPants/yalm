---@type Mq
local mq = require("mq")

local classes = require("yalm.definitions.Classes")

-- Persistent Data
local multiRefObjects = {} -- multiRefObjects

local function get_setting(item)
	local setting = "Sell"
	if mq.TLO.Me.Level() >= item.RequiredLevel() then
		setting = "Keep"
	end

	return setting
end

local function get_quantity(item)
	local quantity = 1
	return quantity
end

local function get_list(item)
	local list = {}

	for i in ipairs(classes) do
		if tostring(item.Class(classes[i])) ~= "NULL" then
			table.insert(list, classes[i])
		end
	end

	if #list == #classes then
		return nil
	end

	return list
end

local obj1 = {
	["conditions"] = {
		[1] = {
			["name"] = "Defiant",
			["setting"] = get_setting,
			["quantity"] = get_quantity,
			["list"] = get_list,
		},
	},
	["items"] = {},
}
return obj1
