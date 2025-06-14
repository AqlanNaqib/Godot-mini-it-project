extends InvItem

class_name Key

@export var key_id: String = ""

func use(player: Player):
	print("Using key: ", key_id)
