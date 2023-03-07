--- @type Mq
local mq = require("mq")
local PackageMan = require("mq/PackageMan")
local lfs = PackageMan.Require("luafilesystem", "lfs")

local loader = {
	types = {
		categories = "categories",
		commands = "commands",
		conditions = "conditions",
		functions = "functions",
		items = "items",
		preferences = "preferences",
		rules = "rules",
		subcommands = "subcommands",
	},
}

loader.filename = function(name, loot_type)
	return ("%s/yalm/config/%s/%s.lua"):format(mq.luaDir, loot_type, name)
end

loader.packagename = function(name, loot_type)
	return ("yalm.config.%s.%s"):format(loot_type, name)
end

loader.unload_package = function(name, loot_type)
	package.loaded[loader.packagename(name, loot_type)] = nil
end

loader.should_load = function(loot_type)
	if
		loot_type == loader.types.commands
		or loot_type == loader.types.conditions
		or loot_type == loader.types.functions
		or loot_type == loader.types.subcommands
	then
		return true
	end

	return false
end

loader.load = function(rule, loot_type, reload)
	if reload then
		loader.unload_package(rule.name, loot_type)
	end

	local success, result = pcall(require, ("yalm.config.%s.%s"):format(loot_type, rule.name))
	if not success then
		result = nil
		rule.failed = true
		Write.Warn("%s registration failed: %s", loot_type, rule.name)
		Write.Warn('To get more error output, you could try: "/lua run yalm/config/%s/%s"', loot_type, rule.name)
	else
		if loot_type == loader.types.commands or loot_type == loader.types.subcommands then
			rule.func = result

			if type(rule.func) == "function" then
				local tmp_func = rule.func
				rule.func = { action_func = tmp_func }
			elseif type(rule.func) ~= "table" then
				result = nil
				rule.failed = true
				Write.Warn("%s registration failed: %s, command functions not correctly defined", loot_type, rule.name)
				return
			end
		elseif loot_type == loader.types.conditions then
			rule.func = result

			if type(rule.func) == "function" then
				local tmp_func = rule.func
				rule.func = { condition_func = tmp_func }
			elseif type(rule.func) ~= "table" then
				result = nil
				rule.failed = true
				Write.Warn(
					"%s registration failed: %s, condition functions not correctly defined",
					loot_type,
					rule.name
				)
				return
			end
		elseif loot_type == loader.types.functions then
			rule.func = result

			if type(rule.func) == "function" then
				local tmp_func = rule.func
				rule.func = { helper_func = tmp_func }
			elseif type(rule.func) ~= "table" then
				result = nil
				rule.failed = true
				Write.Warn("%s registration failed: %s, helper function not correctly defined", loot_type, rule.name)
				return
			end
		end
		Write.Info("Registering %s: \ao%s\ax", loot_type, rule.name)
		rule.loaded = true

		local timestamp = lfs.attributes(loader.filename(rule.name, loot_type), "modification")
		if timestamp then
			rule.timestamp = timestamp
		end
	end
end

loader.unload = function(rule, loot_type)
	Write.Info("Deregistering %s: \ao%s\ax", loot_type, rule.name)
	rule.unload_package(rule.name, loot_type)
	rule.loaded = false
	rule.func = nil
	rule.failed = nil
end

loader.reload = function(rule, loot_type)
	loader.unload(rule, loot_type)
	loader.load(rule, loot_type)
end

loader.has_modified = function(rule, loot_type)
	local old_timestamp = rule.timestamp or 0
	local current_timestamp = lfs.attributes(loader.filename(rule.name, loot_type), "modification")
	if current_timestamp then
		return current_timestamp > old_timestamp
	end
	return false
end

loader.manage = function(rule_list, loot_type)
	if not rule_list then
		return
	end

	for _, rule in pairs(rule_list) do
		local load_event = loader.should_load(loot_type)
		local has_modified = loader.has_modified(rule, loot_type)

		if (has_modified or not rule.loaded) and not rule.failed and load_event then
			loader.load(rule, loot_type, has_modified)
		elseif rule.loaded and not load_event then
			loader.unload(rule, loot_type)
		end
	end
end

return loader
