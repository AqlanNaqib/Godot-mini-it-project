extends HBoxContainer

@onready var inv: Inv = preload("res://Inventory/playerInventory.tres")
@onready var slots: Array = get_children()

func _ready():
	update()
	inv.update.connect(update)

func update():
	for i in range(slots.size()):
		var invSlot: InvSlot = inv.slots[i]
		slots[i].update_to_slot(invSlot)
