--[[
yalm -- fuddles
]]
---@type Mq
local mq = require("mq")
--- @type ImGui
require("ImGui")

local PackageMan = require("mq/PackageMan")
local Utils = require("mq/Utils")

require("yalm.lib.Write")

local sql = PackageMan.Require("lsqlite3")
local lfs = PackageMan.Require("luafilesystem", "lfs")

require("yalm.lib.database")

local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")
local state = require("yalm.config.state")

local looting = require("yalm.core.looting")
local loader = require("yalm.core.loader")

local utils = require("yalm.lib.utils")

local global_settings, char_settings

local function print_help()
	Write.Help("\at[\ax\ayYet Another Loot Manager v%s\ax\at]\ax", state.version)
	Write.Help("\axCommands Available:")
	Write.Help("\t  \ay/yalm help\ax -- Display this help output")
	Write.Help("\t  \ay/yalm reload\ax -- Reloads yalm")

	configuration.print_type_help(global_settings, configuration.types.command.settings_key)
end

local function cmd_handler(...)
	local args = { ... }

	if #args < 1 then
		print_help()
		return
	end

	local command = args[1]
	local loot_command = utils.find_by_key(global_settings.commands, "trigger", command)

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

	Database.database = assert(Database.OpenDatabase())

	if not mq.TLO.Me.UseAdvancedLooting() then
		Write.Error("You must have AdvLoot enabled")
		mq.exit()
	end

	mq.bind("/yalm", cmd_handler)

	global_settings, char_settings = settings.init_settings()
end

local function main()
	initialize()

	while not state.terminate and mq.TLO.MacroQuest.GameState() == "INGAME" do
		if not mq.TLO.Me.Dead() then
			global_settings, char_settings = settings.reload_settings(global_settings, char_settings)

			loader.manage(global_settings.commands, configuration.types.command)
			loader.manage(global_settings.conditions, configuration.types.condition)
			loader.manage(global_settings.helpers, configuration.types.helpers)
			loader.manage(global_settings.subcommands, configuration.types.subcommand)

			looting.handle_master_looting(global_settings)
			looting.handle_solo_looting(global_settings)
			looting.handle_personal_loot()
		end

		mq.doevents()
		mq.delay(global_settings.settings.frequency)
	end
end

main()
