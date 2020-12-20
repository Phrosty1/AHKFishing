-- For menu & data
AHKFishing = {}
AHKFishing.name = "AHKFishing"

local ptk = LibPixelControl

local ms_time = GetGameTimeMilliseconds()
local function dmsg(txt)
	d((GetGameTimeMilliseconds() - ms_time) .. ") " .. txt)
	ms_time = GetGameTimeMilliseconds()
end

-- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
function AHKFishing.OnInventorySingleSlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
	if (GetItemType(bagId,slotId) == ITEMTYPE_LURE 
		and isNewItem == false 
		and stackCountChange == -1 
		and itemSoundCategory == 39) 
	then
		dmsg("Lure used, pressing E")
		ptk.SetIndOnFor(ptk.VK_E, 100)
		zo_callLater(function() ptk.SetIndOnFor(ptk.VK_E, 100) end, 500)
	end
end

function AHKFishing:Initialize()
	EVENT_MANAGER:RegisterForEvent(AHKFishing.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKFishing.OnInventorySingleSlotUpdate)
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function AHKFishing.OnAddOnLoaded(event, addonName) -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
    if addonName == AHKFishing.name then AHKFishing:Initialize() end
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(AHKFishing.name, EVENT_ADD_ON_LOADED, AHKFishing.OnAddOnLoaded)
