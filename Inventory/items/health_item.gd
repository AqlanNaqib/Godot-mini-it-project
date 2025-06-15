extends InvItem

class_name HealthItem

@export var health_increase: int = 1

# Change signature to match parent (InvItem)
func use(): # Removed 'player: Player' argument
	Globals.increase_health(health_increase) # Call Globals directly
