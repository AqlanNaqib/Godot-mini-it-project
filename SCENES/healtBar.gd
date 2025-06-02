extends TextureProgressBar

@export var player : Player

func _ready():
	if player:
		player.healthChanged.connect(update)
		update()
	else:
		printerr("Player reference not set!")

func update():
	# Use the actual health variable from Player
	value = player.health  # Directly use health (0-100 scale)
	# Or if you want percentage:
	# value = player.health  # Since max is always 100
