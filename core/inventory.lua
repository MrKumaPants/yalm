--- @type Mq
local mq = require("mq")

local dannet = require("yalm.lib.dannet")

local utils = require("yalm.lib.utils")

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

inventory.check_total_save_slots = function(member, char_settings, save_slots, dannet_delay)
	local total_save_slots = save_slots

	local name = member.Name()

	if not char_settings.saved or utils.length(char_settings.saved) == 0 then
		return total_save_slots
	end

	for i in ipairs(char_settings.saved) do
		local slots = char_settings.saved[i]

		if slots.itemslot then
			local container_slots, item_count, item_name

			if slots.itemslot2 then
				if name == mq.TLO.Me.DisplayName() then
					item_name = mq.TLO.Me.Inventory(slots.itemslot).Item(slots.itemslot2).Name()
				else
					item_count = tostring(
						dannet.query(
							name,
							("Me.Inventory[%s].Item[%s].Name"):format(slots.itemslot, slots.itemslot2),
							dannet_delay
						)
					) or nil
				end

				if not item_name then
					total_save_slots = total_save_slots + 1
				end
			else
				if name == mq.TLO.Me.DisplayName() then
					container_slots = mq.TLO.Me.Inventory(slots.itemslot).Container()
					item_count = mq.TLO.Me.Inventory(slots.itemslot).Items()
					item_name = mq.TLO.Me.Inventory(slots.itemslot).Name()
				else
					container_slots = tonumber(
						dannet.query(name, ("Me.Inventory[%s].Container"):format(slots.itemslot), dannet_delay)
					) or 0
					item_count = tonumber(
						dannet.query(name, ("Me.Inventory[%s].Items"):format(slots.itemslot), dannet_delay)
					) or 0
					item_count = tostring(
						dannet.query(name, ("Me.Inventory[%s].Name"):format(slots.itemslot), dannet_delay)
					) or nil
				end

				if not item_name then
					total_save_slots = total_save_slots + 1
				elseif container_slots > 0 and item_count < container_slots then
					total_save_slots = total_save_slots + container_slots - item_count
				end
			end
		end
	end
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
			mq.cmd("/notify ConfirmationDialogBox CD_YES_Button leftmouseup")

			while mq.TLO.Window(confirmation_dialog_box).Open() do
				mq.delay(100)
			end
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
		count = mq.TLO.FindItemCount(item_id)()
		bankcount = mq.TLO.FindItemBankCount(item_id)()
	else
		-- use dannet
		count = tonumber(dannet.query(name, string.format("FindItemCount[%s]", item_id), dannet_delay)) or 0
		bankcount = tonumber(dannet.query(name, string.format("FindItemBankCount[%s]", item_id), dannet_delay)) or 0
	end

	if (count + bankcount) >= quantity then
		return false
	end

	return true
end

return inventory
