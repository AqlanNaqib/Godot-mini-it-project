extends Panel

@onready var inv: Inv = preload("res://Inventory/playerInventory.tres")
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector

var currently_selected: int = 0

func _ready():
	update()
	inv.update.connect(update)

func update():
	for i in range(slots.size()):
		var invSlot: InvSlot = inv.slots[i]
		slots[i].update_to_slot(invSlot)
	
func move_selector():
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		inv.use_item_atIndex(currently_selected)
	
	if event.is_action_pressed("move_selector"):
		move_selector()
