extends Button

@onready var itemStackUi: ItemStackUi = $CenterContainer/Panel

func update_to_slot(slot:InvSlot):
	if !slot.item:
		itemStackUi.visible = false
		return
	
	itemStackUi.invSlot = slot
	itemStackUi.update()
	itemStackUi.visible = true
