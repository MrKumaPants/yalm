local Classes = require("yalm.definitions.Classes")
local InventorySlots = require("yalm.definitions.InventorySlots")
local ItemTypes = require("yalm.definitions.ItemTypes")

local Item = {
	item_db = nil,
}

local function parseFlags(flags, object)
	local values = {}
	local newFlags = flags

	for i in ipairs(object) do
		local flag = bit.band(newFlags, 1)
		newFlags = bit.rshift(newFlags, 1)
		if flag == 1 then
			table.insert(values, object[i])
		end
	end

	return values
end

function Item:new(o, item_db)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.item_db = item_db
	return o
end

Item.AugSlot1 = function()
	return Item.item_db.augslot1type
end

Item.AugSlot2 = function()
	return Item.item_db.augslot2type
end

Item.AugSlot3 = function()
	return Item.item_db.augslot3type
end

Item.AugSlot4 = function()
	return Item.item_db.augslot4type
end

Item.AugSlot5 = function()
	return Item.item_db.augslot5type
end

Item.AugSlot6 = function()
	return Item.item_db.augslot6type
end

Item.AugType = function()
	return Item.item_db.augtype
end

Item.CastTime = function()
	return Item.item_db.CastTime
end

Item.CHA = function()
	return Item.item_db.acha
end

Item.Charges = function()
	return Item.item_db.maxcharges
end

Item.Clairvoyance = function()
	return Item.item_db.clairvoyance
end

Item.Class = function(class)
	local classes = parseFlags(Item.item_db.classes, Classes)
	for i in ipairs(classes) do
		if classes[i]:find(class) then
			return class
		end
	end
	return "NULL"
end

Item.Classes = function()
	local slots = parseFlags(Item.item_db.classes, Classes)
	return #slots
end

Item.Clicky = function() end

Item.Collectible = function()
	return Item.item_db.collectible > 0
end

Item.CombatEffects = function() end

Item.Combinable = function() end

Item.Container = function()
	return Item.item_db.bagslots
end

Item.ContentSize = function()
	return Item.item_db.bagsize
end

Item.Damage = function()
	return Item.item_db.damage
end

Item.DamageShieldMitigation = function() end

Item.DamShield = function() end

Item.Deities = function() end

Item.Deity = function(name) end

Item.Delay = function()
	return Item.item_db.delay
end

Item.Dex = function()
	return Item.item_db.adex
end

Item.DMGBonus = function()
	return Item.item_db.extradmgamt
end

Item.DMGBonusType = function() end

Item.DoTShielding = function() end

Item.EffectType = function() end

Item.Endurance = function()
	return Item.item_db.endurance
end

Item.EnduranceRegen = function()
	return Item.item_db.enduranceregen
end

Item.Evolving = function() end

Item.Expendable = function() end

Item.Familiar = function() end

Item.FirstFreeSlot = function() end

Item.Focus = function() end

Item.Focus2 = function() end

Item.FocusID = function()
	return Item.item_db.focuseffect
end

Item.FreeStack = function() end

Item.Haste = function()
	return Item.item_db.Haste
end

Item.HealAmount = function()
	return Item.item_db.healamt
end

Item.Heirloiom = function()
	return Item.item_db.heirloom
end

Item.HeroicAGI = function()
	return Item.item_db.heroic_agi
end

Item.HeroicCHA = function()
	return Item.item_db.heroic_cha
end

Item.HeroicDEX = function()
	return Item.item_db.heroic_dex
end

Item.HeroicINT = function()
	return Item.item_db.heroic_int
end

Item.HeroicSTA = function()
	return Item.item_db.heroic_sta
end

Item.HeroicSTR = function()
	return Item.item_db.heroic_str
end

Item.HeroicSvCold = function() end

Item.HeroicSvCorruption = function() end

Item.HeroicSvDisease = function() end

Item.HeroicSvFire = function() end

Item.HeroicSvMagic = function() end

Item.HeroicSvPoison = function() end

Item.HeroicWIS = function()
	return Item.item_db.heroic_wis
end

Item.HP = function()
	return Item.item_db.hp
end

Item.HPRegen = function()
	return Item.item_db.regen
end

Item.Icon = function()
	return Item.item_db.icon
end

Item.ID = function()
	return Item.item_db.id
end

Item.IDFile = function()
	return Item.item_db.idfile
end

Item.IDFile2 = function()
	return Item.item_db.idfileextra
end

Item.Illusion = function() end

Item.InstrumentMod = function()
	return Item.item_db.bardvalue
end

Item.InstrumentType = function()
	return Item.item_db.bardtype
end

Item.INT = function()
	return Item.item_db.aint
end

Item.Lore = function()
    return Item.item_db.loregroup ~= 0
end

Item.LoreEquip = function()
    return Item.item_db.loreequippedgroup ~= 0
end

Item.Name = function()
	return Item.item_db.name
end

Item.NoDrop = function()
	return Item.item_db.nodrop == 0
end

Item.NoRent = function()
	return Item.item_db.norent == 0
end

Item.Quest = function()
	return Item.item_db.questitemflag > 0
end

Item.RecommendLevel = function()
	return Item.item_db.reclevel
end

Item.RequiredLevel = function()
	return Item.item_db.reqlevel
end

Item.SellPrice = function()
	return nil
end

Item.StackSize = function()
	return Item.item_db.stacksize
end

Item.Tradeskills = function()
	return Item.item_db.tradeskills > 0
end

Item.Type = function()
	return ItemTypes[Item.item_db.itemtype + 1]
end

Item.Value = function()
	return Item.item_db.price
end

Item.WornSlot = function(slot)
	if type(slot) == "number" then
		return nil
	end

	local slots = parseFlags(Item.item_db.slots, InventorySlots)
	for i in ipairs(slots) do
		if slots[i]:find(slot) then
			return true
		end
	end

	return false
end

Item.WornSlots = function()
	local slots = parseFlags(Item.item_db.slots, InventorySlots)
	return #slots
end

return Item
