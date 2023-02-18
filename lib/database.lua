--- @type Mq
local mq = require("mq")

local PackageMan = require("mq/PackageMan")
local sql = PackageMan.Require("lsqlite3")

Database = {
	database = nil,
	path = ("%s/yalm/items.db"):format(mq.luaDir),
}

Database.OpenDatabase = function(path)
	if not path then
		path = Database.path
	end
	local db, ec, em = sql.open(path)
	if db then
		for row in db:nrows("select sqlite_version() as ver;") do
			Write.Info("Sqlite version: \ao%s\ax", row.ver)
		end
	else
		Write.Error("Could not open database [%s] (%i): %s", path, ec, em)
	end
	return db
end

Database.QueryDatabaseForItemId = function(item_id)
	local item_db
	for row in Database.database:nrows(string.format("select * from items where id = %s", item_id)) do
		item_db = row
		break
	end
	return item_db
end

Database.QueryDatabaseForItemName = function(item_name)
	local item_db = nil
	for row in Database.database:nrows(string.format('select * from items where name = "%s"', item_name)) do
		item_db = row
		break
	end
	return item_db
end

return Database
