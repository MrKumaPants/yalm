local classes = require("yalm.definitions.Classes")

local function helper(item)
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

return { helper_func = helper }
