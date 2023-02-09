local mq = require("mq")

local evaluate = require("yalm.classes.evaluate")
local helpers = require("yalm.classes.helpers")

local function get_free_bank_count()
	local handle = "GuildBankWnd/GBANK_BankCountLabel"
	return tonumber(mq.TLO.Window(handle).Text():match("(%d+)$"))
end

local function get_free_deposit_count()
	local handle = "GuildBankWnd/GBANK_DepositCountLabel"
	return tonumber(mq.TLO.Window(handle).Text():match("(%d+)$"))
end

local function get_guild_bank_deposit_count()
	local handle = "GuildBankWnd/GBANK_DepositList"
	return mq.TLO.Window(handle).Items()
end

local function get_guild_bank_deposit_item_name(i)
	local handle = "GuildBankWnd/GBANK_DepositList"
	return mq.TLO.Window(handle).List(i, 2)()
end

local function get_guild_bank_item_count()
	local handle = "GuildBankWnd/GBANK_ItemList"
	return mq.TLO.Window(handle).Items()
end

local function get_guild_bank_item_name_and_permission(i)
	local handle = "GuildBankWnd/GBANK_ItemList"
	return mq.TLO.Window(handle).List(i, 2)(), mq.TLO.Window(handle).List(i, 4)()
end

local function is_promote_button_enabled()
	local handle = "GuildBankWnd/GBANK_PromoteButton"
	return mq.TLO.Window(handle).Enabled()
end

local function is_bank_deposit_button_enabled()
	local handle = "GuildBankWnd/GBANK_DepositButton"
	return mq.TLO.Window(handle).Enabled()
end

local function is_permission_combo_enabled()
	local handle = "GuildBankWnd/GBANK_PermissionCombo"
	return mq.TLO.Window(handle).Enabled()
end

local function is_valid_deposit(item)
	local handle = "GuildBankWnd/GBANK_ItemList"

	if get_free_bank_count() == 0 and get_free_deposit_count() == 0 then
		return false
	end

	if item.NoTrade() and item.NoRent() then
		return false
	end

	if item.Lore() then
		return mq.TLO.Window(handle).List(item.Name(), 2)() == nil
	end

	return true
end

local function can_deposit_item(item, loot, char_settings, global_settings)
	if item.Name() then
		local preference = evaluate.get_loot_preference(item, loot, char_settings, global_settings.unmatched_item_rule)

		if preference then
			local loot_preference = loot.preferences[preference.setting]
			if loot_preference and loot_preference.name == "Guild" and is_valid_deposit(item) then
				if not evaluate.is_item_in_saved_slot(item, char_settings) then
					return true
				end
			end
		end
	end

	return false
end

local function promote_item()
	local item_name = get_guild_bank_deposit_item_name(1)
	Write.Info("Promoting \a-t%s\ax", item_name)

	-- select item to promote
	mq.cmdf("/nomodkey /notify GuildBankWnd GBANK_DepositList listselect 1")
	mq.delay(250)

	-- wait for the promote button
	while not is_promote_button_enabled() do
		mq.delay(250)
	end

	-- promote item
	mq.cmdf("/nomodkey /notify GuildBankWnd GBANK_PromoteButton leftmouseup")
	mq.delay(1000)
end

local function promote_items()
	local free_bank_count = get_free_bank_count()

	Write.Info("Promoting all items in deposit list")

	if free_bank_count == 0 then
		Write.Warn("Guild bank is out of space")
		return
	end

	while get_guild_bank_deposit_count() > 0 do
		if free_bank_count > 0 then
			promote_item()
			free_bank_count = get_free_bank_count()
		else
			Write.Warn("Guild bank is out of space")
			return
		end
	end

	Write.Info("Finished promoting")
end

local function change_permissions()
	for i = 1, get_guild_bank_item_count() do
		local item_name, permission = get_guild_bank_item_name_and_permission(i)

		if permission ~= "Public" then
			Write.Info("Changing \a-t%s\ax from \ao%s\ax to \atPublic\ax", item_name, permission)

			mq.cmdf("/notify GuildBankWnd GBANK_ItemList listselect %d", i)
			mq.delay(250)

			while not is_permission_combo_enabled() do
				mq.delay(250)
			end

			mq.cmdf("/nomodkey /notify GuildBankWnd GBANK_PermissionCombo listselect 4")
			mq.delay(1000)
		end
	end
end

local function deposit_item(item, loot, char_settings, global_settings)
	local can_deposit = can_deposit_item(item, loot, char_settings, global_settings)
	if can_deposit then
		-- pick up the item
		if item.ItemSlot2() ~= nil then
			mq.cmdf("/shift /itemnotify in pack%s %s leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
		else
			mq.cmdf("/shift /itemnotify %s leftmouseup", item.ItemSlot())
		end
		mq.delay(250)

		while not is_bank_deposit_button_enabled() do
			mq.delay(250)
		end

		-- deposit item if the cursor matches what we expect
		if mq.TLO.Cursor.ID() == item.ID() then
			Write.Info("Depositing \a-t%s\ax", item.Name())

			mq.cmdf("/nomodkey /notify GuildBankWnd GBANK_DepositButton leftmouseup")
			mq.delay(1000)

			while is_bank_deposit_button_enabled() do
				mq.delay(250)
			end

			promote_item()
		else
			Write.Warn("Cursor doesn't match. Expected: \a-t%s\ax; Actual: \ar%s\ax", item.Name(), mq.TLO.Cursor.Name())
			-- if cursor doesn't match what we expect, put it back
			if mq.TLO.Cursor.ID() ~= nil then
				mq.cmd("/autoinventory")
			end
		end

		mq.delay(250)
	end
end

local function action(loot, char_settings, global_settings, args)
	Write.Info("Depositing items...")

	if helpers.ready_guild_bank_window(true) then
		promote_items()

		for i = 23, 32 do
			local inventory_item = mq.TLO.Me.Inventory(i)

			if inventory_item.Name() then
				if inventory_item.Container() > 0 then
					if inventory_item.Items() > 0 then
						for j = 1, inventory_item.Container() do
							local item = mq.TLO.Me.Inventory(i).Item(j)
							deposit_item(item, loot, char_settings, global_settings)
						end
					end
				else
					deposit_item(inventory_item, loot, char_settings, global_settings)
				end
			end
		end

		change_permissions()
	end

	Write.Info("Finished depositing")
	mq.cmd("/cleanup")
end

return { action_func = action }
