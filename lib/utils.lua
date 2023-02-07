--- @type Mq
local mq = require("mq")
local PackageMan = require("mq/PackageMan")
local lfs = PackageMan.Require("luafilesystem", "lfs")

local utils = {}

utils.FileExists = function(path)
	local f = io.open(path, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

utils.DirExists = function(path)
	if lfs.attributes(path, "mode") == "directory" then
		return true
	end
	return false
end

utils.MakeDir = function(base_dir, path)
	if not utils.DirExists(("%s/%s"):format(base_dir, path)) then
		local success, error_msg = lfs.chdir(base_dir)
		if not success then
			Write.Error("Could not change to config directory: %s", error_msg)
			return false
		end
		success, error_msg = lfs.mkdir("YALM")
		if not success then
			Write.Error("Could not create config directory: %s", error_msg)
			return false
		end
	end
	return true
end

utils.Merge = function(t1, t2)
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			utils.Merge(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

utils.ShallowCopy = function(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

-- Split a string using the provided separator, | by default
utils.Split = function(input, sep)
	if sep == nil then
		sep = "|"
	end
	local t = {}
	for str in string.gmatch(input, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

-- Create a table of {key:true, ..} from a list for checking a value is in the list
utils.Set = function(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end

utils.TitleCase = function(phrase)
	local result = string.gsub(phrase, "(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end)
	return result
end

utils.TableConcat = function(t1, t2)
	local t = {}
	for k, v in ipairs(t1) do
		table.insert(t, v)
	end
	for k, v in ipairs(t2) do
		table.insert(t, v)
	end
	return t
end

utils.TableClone = function(org)
	return { unpack(org) }
end

utils.DoTablesMatch = function(a, b)
	return table.concat(a) == table.concat(b)
end

-- Load required plugins
utils.PluginCheck = function()
	-- unload mq2autoloot
	if mq.TLO.Plugin("mq2autoloot")() ~= nil then
		Write.Info("Plugin MQ2AutoLoot conflicts. Unloading it now.")
		mq.cmdf("/plugin mq2autoloot unload noauto")
	end

	if not mq.TLO.Plugin("mq2dannet").IsLoaded() then
		Write.Info("Plugin MQ2DanNet is required. Loading it now.")
		mq.cmd("/plugin mq2dannet noauto")
	end
end

utils.GetZonePeerGroup = function()
	local zoneName = mq.TLO.Zone.ShortName()
	if zoneName:find("_") then
		return string.format("zone_%s", zoneName)
	else
		return string.format("zone_%s_%s", mq.TLO.EverQuest.Server(), zoneName)
	end
end

utils.GetGroupPeerGroup = function()
	return ("group_%s_%s"):format(mq.TLO.EverQuest.Server(), (mq.TLO.Group.Leader() or ""):lower())
end

utils.GetItemPreferenceString = function(preference)
	local message = ("preference: \ao%s\ax"):format(preference.setting)

	if preference.quantity then
		message = message .. (", quantity: \ao%s\ax"):format(preference.quantity and preference.quantity or "")
	end

	if preference.list then
		message = message .. (", list: \ao%s\ax"):format(preference.list and table.concat(preference.list, ",") or "")
	end

	return message
end

return utils
