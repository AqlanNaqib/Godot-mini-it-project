extends Button

@onready var itemStackUi: ItemStackUi = $CenterContainer/Panel

func update_to_slot(slot: InvSlot):
	# Add a null check for 'slot' itself first
	if slot == null: #
		itemStackUi.visible = false # Hide the UI if there's no slot data
		return # Stop execution here

	# Now it's safe to check slot.item, because slot is guaranteed not to be null
	if !slot.item:
		itemStackUi.visible = false
		return
	
	itemStackUi.invSlot = slot
	itemStackUi.update()
	itemStackUi.visible = true
