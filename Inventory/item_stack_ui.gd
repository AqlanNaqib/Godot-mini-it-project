extends Panel

class_name ItemStackUi

var item_visual: Sprite2D 
var amount_text: Label 

var invSlot: InvSlot

func _ready():
	item_visual = get_node("item_display")
	amount_text = get_node("Label")
	call_deferred("update")
	
func update():
	if !invSlot || !invSlot.item: 
		return
	
	if item_visual == null or amount_text == null:
		return
	
	item_visual.visible = true
	item_visual.texture = invSlot.item.texture
	
	if invSlot.amount >= 2:
		amount_text.visible = true
		amount_text.text = str(invSlot.amount)
	else:
		if invSlot.amount == 1:
			amount_text.visible = false
			
