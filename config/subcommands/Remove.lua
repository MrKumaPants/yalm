---@type Mq
local mq = require("mq")

local configuration = require("yalm.config.configuration")

local function action(type, global_settings, char_settings, args) end

return { action_func = action }
