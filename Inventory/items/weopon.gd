extends InvItem

class_name WeaponItem

@export var weapon_class: PackedScene = preload("res://SCENES/arrow.tscn")
@export var arrow_amount: int = 1

# Change signature to match parent (InvItem)
func use(): # Removed 'player: Player' argument
	Globals.add_arrows(arrow_amount) # Call Globals directly
	print("Added ", arrow_amount, " arrows globally. Current: ", Globals.player_current_arrows)
