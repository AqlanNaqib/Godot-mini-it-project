extends InvItem

class_name WeaponItem

@export var weapon_class: PackedScene = preload("res://SCENES/arrow.tscn")
@export var arrow_amount: int = 1 


func use(player: Player):
	if player.has_method("add_arrows"):
		player.add_arrows(arrow_amount)
