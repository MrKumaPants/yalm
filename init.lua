--[[
yalm -- fuddles
]]
---@type Mq
local mq = require("mq")
local PackageMan = require("mq/PackageMan")
local Utils = require("mq/Utils")

require("yalm.lib.Write")

local sql = Utils.Library.Include("lsqlite3")
if not sql then
	if PackageMan.Install("lsqlite3") == 2 then
		print("User canceled the install, cannot proceed")
		mq.exit()
	end
end

local lfs = Utils.Library.Include("lfs")
if not lfs then
	if PackageMan.Install("lfs") == 2 then
		print("User canceled the install, cannot proceed")
		mq.exit()
	end
end

require("yalm.lib.database")

Database.database = assert(Database.OpenDatabase())

local looting = require("yalm.core.looting")
local loader = require("yalm.core.loader")
local settings = require("yalm.config.settings")

local utils = require("yalm.lib.utils")

local version = "0.8.1"

-- application state
local state = {
	terminate = false,
	command_running = nil,
	ui = {
		main = {
			title = ("Yet Another Loot Manager (v%s)###yalm"):format(version),
			open_ui = true,
			draw_ui = true,
		},
	},
}

local global_settings, char_settings

local function find_loot_command(command)
	for _, loot_command in pairs(global_settings.commands) do
		if loot_command.trigger == command then
			return loot_command
		end
	end

	return nil
end

local function print_command_help()
	local category_map = {}
	for _, command in pairs(global_settings.commands) do
		local category = command.category or "Uncategorized"
		if not category_map[category] then
			category_map[category] = {}
		end
		table.insert(category_map[category], command)
	end

	for category, commands in pairs(category_map) do
		Write.Help("\ax%s Commands Available:", category)
		table.sort(commands, function(left, right)
			return left.name < right.name
		end)
		for i in ipairs(commands) do
			local command = commands[i]
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
end

local function print_help()
	Write.Help("\at[\ax\ayYet Another Loot Manager v%s\ax\at]\ax", version)
	Write.Help("\axCommands Available:")
	Write.Help("\t  \ay/yalm help\ax -- Display this help output")
	--Write.Help("\t  \ay/yalm set <set_name> [on|1|true|off|0|false]\ax -- Toggle the named set on/off")
	Write.Help("\t  \ay/yalm reload\ax -- Reload settings (Currently just restarts the script)")

	print_command_help()
end

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
		if not state.command_running then
			state.command_running = command
			local success, result = pcall(loot_command.func.action_func, global_settings, char_settings, args)
			if not success then
				Write.Warn("Running command failed: %s - %s", loot_command.name, result)
			end
			state.command_running = nil
		else
			Write.Warn("Cannot run a command as \ao%s\ax is still running", state.command_running)
		end
	else
		Write.Warn("That is not a valid command")
	end
end

local function initialize()
	utils.plugin_check()

	mq.bind("/yalm", cmd_handler)

	global_settings, char_settings = settings.init_settings()
end

local function main()
	initialize()

	while not state.terminate do
		loader.manage(global_settings.commands, loader.types.commands, char_settings)
		loader.manage(global_settings.conditions, loader.types.conditions, char_settings)
		loader.manage(global_settings.rules, loader.types.rules, char_settings)

		looting.handle_master_looting(global_settings)
		looting.handle_personal_loot()
		looting.handle_solo_looting(global_settings)

		mq.doevents()
		mq.delay(global_settings.settings.frequency)
	end
end

main()
