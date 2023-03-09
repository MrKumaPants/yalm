local mq = require("mq")

local configuration = require("yalm.config.configuration")
local settings = require("yalm.config.settings")

local evaluate = require("yalm.core.evaluate")

local LIP = require("yalm.lib.LIP")
local utils = require("yalm.lib.utils")

local command = {}

command.help = function(global_settings, char_settings, type, args)
	Write.Help("\at[\ax\ay/yalm command help\ax\at]\ax")
	Write.Help("\axSubcommands Available:")
	Write.Help("\t  \ayhelp\ax -- Display this help output")
	Write.Help("\t  \ayadvloot\ax -- Converts Lootly file")
	Write.Help("\t  \aylootly\ax -- Converts AdvLoot files")
	Write.Help("\t  \ayset <setting> <value>\ax -- Updates setting to the given value")
	Write.Help("\axSettings Available:")
end

command.lootly = function(global_settings, char_settings, type, args)
	local lootly_file = ("%s/Lootly_Loot.ini"):format(mq.configDir)

	if not utils.file_exists(lootly_file) then
		Write.Error("Lootly loot file does not exist")
		return
	end

	Write.Info("Converting Lootly file...")

	local inifile = LIP.load(lootly_file)

	local items = {}

	for _, section in pairs(inifile) do
		for item_name, preference in pairs(section) do
			local converted_preference = evaluate.parse_preference_string(preference)
			Write.Info(
				"Found item \a-t%s\ax with %s",
				item_name,
				utils.get_item_preference_string(converted_preference)
			)
			items[item_name] = converted_preference
		end
	end

	Write.Info("Saving configuration...")

	settings.update_and_save_global_settings(global_settings, configuration.types.item.settings_key, items)

	Write.Info("Finished saving")

	Write.Info("Finished converting")
end

local function get_advloot_ini_path(advloot_rule)
	return ("%s/userdata/LF_%s_%s_%s.ini"):format(
		mq.TLO.EverQuest.Path(),
		advloot_rule,
		mq.TLO.Me.CleanName(),
		mq.TLO.EverQuest.Server()
	)
end

command.advloot = function(global_settings, char_settings, type, args)
	local advloot_rules = {
		"AN",
		"AG",
		"NVR",
		"RND",
	}

	Write.Info("Converting AdvLoot files...")

	for i = 1, #advloot_rules do
		local advloot_rule = advloot_rules[i]
		local advloot_file = get_advloot_ini_path(advloot_rule)

		if utils.file_exists(advloot_file) then
			local file = assert(io.open(advloot_file, "r"), "Error loading file : " .. advloot_file)
			for line in file:lines() do
				if not line:find("^#") then
					local item = utils.split(line, "^")
					local item_name = item[3]
					if item_name then
						if advloot_rule == "NVR" then
							char_settings["items"][item_name] = {
								["setting"] = "Leave",
							}
						else
							char_settings["items"][item_name] = {
								["setting"] = "Keep",
							}
						end

						Write.Info(
							"Found item \a-t%s\ax with %s",
							item_name,
							utils.get_item_preference_string(char_settings["items"][item_name])
						)
					end
				end
			end
			file:close()
		end
	end

	Write.Info("Saving character configuration...")

	settings.save_char_settings(char_settings)

	Write.Info("Finished saving")

	Write.Info("Finished converting")
end

command.valid_subcommands = {
	["help"] = {
		func = {
			action_func = command.help,
		},
	},
	["lootly"] = {
		func = {
			action_func = command.lootly,
		},
	},
	["advloot"] = {
		func = {
			action_func = command.advloot,
		},
	},
}

local function action(global_settings, char_settings, args)
	configuration.action(
		command.valid_subcommands,
		global_settings,
		char_settings,
		configuration.types.command.name,
		args
	)
end

return { action_func = action }
