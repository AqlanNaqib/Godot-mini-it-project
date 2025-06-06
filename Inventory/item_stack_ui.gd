extends Panel

class_name ItemStackUi

@onready var item_visual: Sprite2D = $item_display
@onready var amount_text: Label = $Label

var invSlot: InvSlot

func update():
	if !invSlot || !invSlot.item: return
	
	item_visual.visible = true
	item_visual.texture = invSlot.item.texture
	if invSlot.amount > 1:
		amount_text.visible = true
		amount_text.text = str(invSlot.amount)
