extends CanvasLayer

@onready var inventory_ui = $Inventory

func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		print("inventory is open...")
