extends Button

@onready var container: CenterContainer = $CenterContainer

@onready var inv: Inv = Globals.player_inventory

var itemStackUi: ItemStackUi
var index: int

func insert(isg: ItemStackUi):
	itemStackUi = isg
	container.add_child(itemStackUi)
	
	if inv and index >= 0 and index < inv.slots.size() and itemStackUi and itemStackUi.invSlot:
		inv.insertSlot(index, itemStackUi.invSlot)

func takeItem():
	var item = itemStackUi
	
	if inv and itemStackUi and itemStackUi.invSlot:
		inv.removeSlot(itemStackUi.invSlot)
	
	# Clear the UI representation
	if itemStackUi: # Ensure itemStackUi is not null before trying to remove
		container.remove_child(itemStackUi)
	itemStackUi = null # Set to null after removing from container
	
	return item

func isEmpty():
	return !itemStackUi

func clear():
	if itemStackUi:
		container.remove_child(itemStackUi)
		itemStackUi = null

func update_to_slot(slot: InvSlot):
	# Add a null check for 'slot' itself first
	if slot == null:
		if itemStackUi: # Only hide if it exists
			itemStackUi.visible = false
		return
	
	# Now it's safe to check slot.item, because slot is guaranteed not to be null
	if !slot.item:
		if itemStackUi: # Only hide if it exists
			itemStackUi.visible = false
		return
	
	# Ensure itemStackUi exists before trying to assign properties
	if !itemStackUi:
		printerr("UiSlot: itemStackUi is null, cannot update visual for slot with item!")
		return
	
	itemStackUi.invSlot = slot
	itemStackUi.update()
	itemStackUi.visible = true
