--[[
yalm -- fuddles
]]
---@type Mq
local mq = require("mq")

local Write = require("yalm.Write")

local looting = require("yalm.classes.looting")
local loader = require("yalm.classes.loader")
local settings = require("yalm.config.settings")

local utils = require("yalm.lib.utils")

local version = "0.1"

-- application state
local state = {
	terminate = false,
	ui = {
		main = {
			title = ("Yet Another Loot Manager (v%s)###yalm"):format(version),
			open_ui = true,
			draw_ui = true,
		},
	},
}

local loot, global_settings, char_settings

local function toggle_set(set, loot_type)
	char_settings[loot_type][set.name] = not char_settings[set][set.name]
	settings.save_character_settings(char_settings)
end

local function find_loot_command(command)
	for _, loot_command in pairs(loot.commands) do
		if loot_command.trigger == command then
			return loot_command
		end
	end

	return nil
end

local function print_help()
	Write.Help("\at[\ax\ayYet Another Loot Manager v%s\ax\at]\ax", version)
	Write.Help("\axCommands Available:")
	Write.Help("\t  \ay/yalm help\ax -- Display this help output")
	--Write.Help("\t  \ay/yalm set <set_name> [on|1|true|off|0|false]\ax -- Toggle the named set on/off")
	Write.Help("\t  \ay/yalm reload\ax -- Reload settings (Currently just restarts the script)")
	Write.Help("\axUser Commands Available:")
	for _, command in pairs(loot.commands) do
		if command.loaded then
			local message = ("\t  \ay/yalm %s"):format(command.trigger)
			if command.args then
				message = ("%s %s\ax"):format(message, command.args)
			else
				message = ("%s\ax"):format(message)
			end
			if command.help then
				message = ("%s -- %s"):format(message, command.help)
			end
			Write.Help(message)
		end
	end
end

local ON_VALUES = { ["on"] = 1, ["1"] = 1, ["true"] = 1 }
local OFF_VALUES = { ["off"] = 1, ["0"] = 1, ["false"] = 1 }

local function cmd_handler(...)
	local args = { ... }

	if #args < 1 then
		print_help()
		return
	end

	local command = args[1]
	local loot_command = find_loot_command(command)

	if command == "help" then
		print_help()
	elseif command == "reload" then
		mq.cmd("/timed 10 /lua run yalm")
		state.terminate = true
	elseif loot_command and loot_command.loaded then
		local success, result =
			pcall(loot_command.func.action_func, loot, char_settings, global_settings.settings, args)
		if not success then
			Write.Warn("Running command failed: %s - %s", loot_command.name, result)
		end
	end
end

local function initialize()
	utils.PluginCheck()

	mq.bind("/yalm", cmd_handler)

	global_settings, char_settings = settings.init_settings()

	loot = {
		["categories"] = global_settings.categories or {},
		["commands"] = global_settings.commands or {},
		["conditions"] = global_settings.conditions or {},
		["items"] = global_settings.items or {},
		["preferences"] = global_settings.preferences or {},
		["rules"] = global_settings.rules or {},
	}
end

initialize()

while not state.terminate do
	loader.manage(loot.commands, loader.types.commands, char_settings)
	loader.manage(loot.conditions, loader.types.conditions, char_settings)
	loader.manage(loot.rules, loader.types.rules, char_settings)

	looting.handle_master_looting(loot, global_settings.settings, char_settings)
	looting.handle_personal_loot()

	mq.doevents()
	mq.delay(global_settings.settings.frequency)
end
