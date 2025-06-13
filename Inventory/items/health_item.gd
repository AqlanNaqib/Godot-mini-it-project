extends InvItem

class_name HealthItem

@export var health_increase: int = 1

func use(player: Player):
	player.increase_health(health_increase)
