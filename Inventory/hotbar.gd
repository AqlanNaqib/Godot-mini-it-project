extends Panel

@onready var inv: Inv = Globals.player_inventory
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector

var currently_selected: int = 0

func _ready():
	if inv:
		update()
		inv.update.connect(update)
	else:
		printerr("Hotbar: Globals.player_inventory is null! Hotbar cannot initialize.")

func update():
	# Ensure inv is not null before proceeding
	if !inv:
		printerr("Hotbar: Inventory (inv) is null during update.")
		return

	for i in range(slots.size()):
		if i < inv.slots.size():
			var invSlot: InvSlot = inv.slots[i]
			# Pass the invSlot (which could be null if playerInventory.tres is malformed)
			slots[i].update_to_slot(invSlot)
		else:
			# If the Hotbar has more UI slots than actual inventory slots, clear them
			slots[i].update_to_slot(null)
	
func move_selector():
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		if inv:
			inv.use_item_atIndex(currently_selected)
	
	if event.is_action_pressed("move_selector"):
		move_selector()
