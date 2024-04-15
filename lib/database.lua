--- @type Mq
local mq = require("mq")

local sql = require("lsqlite3")

local utils = require("yalm.lib.utils")

Database = {
	database = nil,
	path = ("%s/MQ2LinkDB.db"):format(mq.TLO.MacroQuest.Path("resources")),
}

Database.OpenDatabase = function(path)
	if not path then
		path = Database.path
	end
	if not utils.file_exists(path) then
		Write.Error("Database file does not exist [%s]", path)
		return nil;
	end
	local db, ec, em = sql.open(path)
	if db then
		for row in db:nrows("select sqlite_version() as ver;") do
			Write.Info("Sqlite version: \ao%s\ax", row.ver)
		end
	else
		Write.Error("Could not open database [%s] (%i): %s", path, ec, em)
		return nil;
	end
	return db
end

Database.QueryDatabaseForItemId = function(item_id)
	local item_db = nil
	for row in Database.database:nrows(string.format("select * from raw_item_data_315 where id = %s", item_id)) do
		item_db = row
		break
	end
	return item_db
end

Database.QueryDatabaseForItemName = function(item_name)
	local item_db = nil
	for row in Database.database:nrows(string.format('select * from raw_item_data_315 where name = "%s"', item_name)) do
		item_db = row
		break
	end
	return item_db
end

return Database
