--- @type Mq
local mq = require("mq")

local inspect = require("yalm.lib.inspect")

Write = { _version = "1.6" }

Write.usecolors = true
Write.loglevel = "info"
Write.prefix = "\at[\ax\apYALM\ax\at]\ax"
Write.postfix = ""
Write.separator = ":: "

Write.loglevels = {
	["trace"] = { level = 1, mqcolor = "\at" },
	["debug"] = { level = 2, mqcolor = "\am" },
	["info"] = { level = 3, mqcolor = "\ag" },
	["warn"] = { level = 4, mqcolor = "\ay" },
	["error"] = { level = 5, mqcolor = "\ao" },
	["fatal"] = { level = 6, mqcolor = "\ar" },
	["help"] = { level = 7, mqcolor = "\aw" },
}

Write.callstringlevel = Write.loglevels["debug"].level

local function Terminate()
	mq.exit()
end

local function GetColorStart(paramLogLevel)
	if Write.usecolors then
		return Write.loglevels[paramLogLevel].mqcolor
	end
	return ""
end

local function GetColorEnd()
	if Write.usecolors then
		if mq then
			return "\ax"
		end
		return "\27[0m"
	end
	return ""
end

local function GetCallerString()
	if Write.loglevels[Write.loglevel:lower()].level > Write.callstringlevel then
		return ""
	end

	local callString = "unknown"
	local callerInfo = debug.getinfo(4, "Sl")
	if callerInfo and callerInfo.short_src ~= nil and callerInfo.short_src ~= "=[C]" then
		callString = string.format(
			"%s%s%s",
			callerInfo.short_src:match("[^\\^/]*.lua$"),
			Write.separator,
			callerInfo.currentline
		)
	end

	return string.format("(%s) ", callString)
end

local function Output(paramLogLevel, message)
	if Write.loglevels[Write.loglevel:lower()].level <= Write.loglevels[paramLogLevel].level then
		print(
			string.format(
				"%s%s%s%s%s%s%s",
				type(Write.prefix) == "function" and Write.prefix() or Write.prefix,
				GetCallerString(),
				type(Write.postfix) == "function" and Write.postfix() or Write.postfix,
				Write.separator,
				GetColorStart(paramLogLevel),
				message,
				GetColorEnd()
			)
		)
	end
end

-- TODO: Genericize all of these based on table
function Write.Trace(message, ...)
	Output("trace", string.format(message, ...))
end

function Write.Debug(message, ...)
	Output("debug", string.format(message, ...))
end

function Write.Info(message, ...)
	Output("info", string.format(message, ...))
end

function Write.Warn(message, ...)
	Output("warn", string.format(message, ...))
end

function Write.Error(message, ...)
	Output("error", string.format(message, ...))
end

function Write.Fatal(message, ...)
	Output("fatal", string.format(message, ...))
	Terminate()
end

function Write.Help(message, ...)
	Output("help", string.format(message, ...))
end

function Write.Inspect(object)
	Output("debug", inspect(object))
end

return Write
