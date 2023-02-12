--- @type Mq
local mq = require("mq")

local dannet = require("yalm.lib.dannet")

local inventory = {}

inventory.check_group_member = function(member, list, dannet_delay, always_loot)
	if always_loot then
		return true
	end

	local class

	if not list or #list == 0 then
		return true
	end

	local name = member.Name()

	if name == mq.TLO.Me.DisplayName() then
		class = mq.TLO.Me.Class.ShortName()
	else
		class = tostring(dannet.query(name, "Me.Class.ShortName", dannet_delay)) or nil
	end

	for i in ipairs(list) do
		if list[i] == name or list[i] == class then
			return true
		end
	end

	return false
end

inventory.check_inventory = function(member, item, save_slots, dannet_delay)
	local slots, count, stacksize

	local name = member.Name()
	local item_id = item.ID()

	if name == mq.TLO.Me.DisplayName() then
		slots = mq.TLO.Me.FreeInventory()
		count = mq.TLO.FindItemCount(item_id)() or 0
		stacksize = mq.TLO.FindItem(item_id).StackSize() or 0
	else
		-- use dannet
		slots = tonumber(dannet.query(name, "Me.FreeInventory", dannet_delay)) or 0
		count = tonumber(dannet.query(name, string.format("FindItemCount[%s]", item_id), dannet_delay)) or 0
		stacksize = tonumber(dannet.query(name, string.format("FindItem[%s].StackSize", item_id), dannet_delay)) or 0
	end

	if (count == 0 or (count > 0 and count + 1 > stacksize)) and slots <= save_slots then
		return false
	end

	return true
end

inventory.check_lore = function(member, item, dannet_delay)
	local lore, banklore

	local name = member.Name()
	local item_id = item.ID()

	-- if it's me, do this locally
	if name == mq.TLO.Me.DisplayName() then
		lore = mq.TLO.FindItem(item_id).Lore()
		banklore = mq.TLO.FindItemBank(item_id).Lore()
	else
		-- use dannet
		lore = tostring(dannet.query(name, string.format("FindItem[%s].Lore", item_id), dannet_delay)) == "TRUE"
		banklore = tostring(dannet.query(name, string.format("FindItemBank[%s].Lore", item_id), dannet_delay)) == "TRUE"
	end

	if lore == true or banklore == true then
		return false
	end

	return true
end

inventory.check_lore_equip_prompt = function()
	local confirmation_dialog_box = "ConfirmationDialogBox"
	local confirmation_dialog_box_text = confirmation_dialog_box .. "/CD_TextOutput"
	if mq.TLO.Window(confirmation_dialog_box).Open() then
		if mq.TLO.Window(confirmation_dialog_box_text).Text():find("LORE-EQUIP", 1, true) then
			mq.cmd("/yes")
			mq.delay("10s")
		end
	end
end

inventory.check_quantity = function(member, item, quantity, dannet_delay, always_loot)
	local count, bankcount

	if quantity == nil or always_loot then
		return true
	end

	local name = member.Name()
	local item_id = item.ID()

	-- if it's me, do this locally
	if name == mq.TLO.Me.DisplayName() then
		count = math.max(mq.TLO.FindItemCount(item_id)(), mq.TLO.FindItemCount(item)())
		bankcount = math.max(mq.TLO.FindItemBankCount(item_id)(), mq.TLO.FindItemBankCount(item)())
	else
		-- use dannet
		count = math.max(
			tonumber(dannet.query(name, string.format("FindItemCount[%s]", item_id), dannet_delay)) or 0,
			tonumber(dannet.query(name, string.format("FindItemCount[%s]", item), dannet_delay)) or 0
		)
		bankcount = math.max(
			tonumber(dannet.query(name, string.format("FindItemBankCount[%s]", item_id), dannet_delay)) or 0,
			tonumber(dannet.query(name, string.format("FindItemBankCount[%s]", item), dannet_delay)) or 0
		)
	end

	if (count + bankcount) >= quantity then
		return false
	end

	return true
end

return inventory
