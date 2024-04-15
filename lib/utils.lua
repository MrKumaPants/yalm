--- @type Mq
local mq = require("mq")
local lfs = require("lfs")

local inspect = require("yalm.lib.inspect")

local utils = {}

utils.copy_file = function(source, dest)
	local f = io.open(source, "r")
	local contents = f:read("*a")
	io.close(f)
	f = io.open(dest, "w")
	f:write(contents)
	io.close(f)
end

utils.delete_file = function(source)
	os.remove(source)
end

utils.write_file = function(path, contents)
	local f = io.open(path, "w")
	f:write(contents)
	io.close(f)
end

utils.file_exists = function(path)
	local f = io.open(path, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

utils.dir_exists = function(path)
	if lfs.attributes(path, "mode") == "directory" then
		return true
	end
	return false
end

utils.make_dir = function(base_dir, dir)
	if not utils.dir_exists(("%s/%s"):format(base_dir, dir)) then
		local success, error_msg = lfs.chdir(base_dir)
		if not success then
			Write.Error("Could not change to config directory: %s", error_msg)
			return false
		end
		success, error_msg = lfs.mkdir(dir)
		if not success then
			Write.Error("Could not create config directory: %s", error_msg)
			return false
		end
	end
	return true
end

utils.merge = function(t1, t2)
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			utils.merge(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

utils.length = function(t1)
	local l = 0
	for k, _ in pairs(t1) do
		l = l + 1
	end
	return l
end

utils.shallow_copy = function(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else
		copy = orig
	end
	return copy
end

utils.deep_copy = function(original)
	local copy = {}
	if type(original) ~= table then
		return original
	end
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = utils.deep_copy(v)
		end
		copy[k] = v
	end
	return copy
end

-- Split a string using the provided separator, | by default
utils.split = function(input, sep)
	if sep == nil then
		sep = "|"
	end
	local t = {}
	for str in string.gmatch(input, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

utils.find = function(list, value)
	for i in ipairs(list) do
		if list[i] == value then
			return i
		end
	end
	return nil
end

utils.find_by_key = function(list, key, value)
	for _, entry in pairs(list) do
		if entry[key] == value then
			return entry
		end
	end

	return nil
end

-- Create a table of {key:true, ..} from a list for checking a value is in the list
utils.set = function(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end

utils.title_case = function(phrase)
	local result = string.gsub(phrase, "(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end)
	return result
end

utils.table_concat = function(t1, t2)
	local t = {}
	for k, v in ipairs(t1) do
		table.insert(t, v)
	end
	for k, v in ipairs(t2) do
		table.insert(t, v)
	end
	return t
end

utils.do_tables_match = function(a, b)
	return table.concat(a) == table.concat(b)
end

-- Load required plugins
utils.plugin_check = function()
	-- unload mq2autoloot
	if mq.TLO.Plugin("mq2autoloot")() ~= nil then
		Write.Info("Plugin MQ2AutoLoot conflicts. Unloading it now.")
		mq.cmdf("/plugin mq2autoloot unload noauto")
	end

	if not mq.TLO.Plugin("mq2dannet").IsLoaded() then
		Write.Info("Plugin MQ2DanNet is required. Loading it now.")
		mq.cmd("/plugin mq2dannet noauto")
	end

	if not utils.file_exists(("%s/MQ2LinkDB.db"):format(mq.TLO.MacroQuest.Path("resources"))) then
		if not mq.TLO.Plugin("mq2linkdb").IsLoaded() then
			Write.Info("Plugin MQ2LinkDB is required. Loading it now.")
			mq.cmd("/plugin mq2linkdb noauto")
		end

		Write.Info("MQ2LinkDB.db does not exist. Creating it now.")
		mq.cmd("/link /import")
	end
end

utils.get_zone_peer_group = function()
	local zoneName = mq.TLO.Zone.ShortName()
	if zoneName:find("_") then
		return string.format("zone_%s", zoneName)
	else
		return string.format("zone_%s_%s", mq.TLO.EverQuest.Server(), zoneName)
	end
end

utils.get_group_peer_group = function()
	return ("group_%s_%s"):format(mq.TLO.EverQuest.Server(), (mq.TLO.Group.Leader() or ""):lower())
end

utils.get_item_preference_string = function(preference)
	local message = ("preference: \ao%s\ax"):format(preference.setting)

	if preference.name then
		message = message .. (", condition: \ao%s\ax"):format(preference.name or "")
	end

	if preference.quantity then
		message = message .. (", quantity: \ao%s\ax"):format(preference.quantity or "")
	end

	if preference.list then
		message = message .. (", list: \ao%s\ax"):format(preference.list and table.concat(preference.list, ",") or "")
	end


	return message
end

return utils
