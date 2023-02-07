local mq = require("mq")

local evaluate = require("yalm.classes.evaluate")

local function action(loot, char_settings, global_settings, args)
	Write.Info("Depositing items into guild bank...")

	Write.Info("Finished depositing")
	mq.cmd("/cleanup")
end

return { action_func = action }
