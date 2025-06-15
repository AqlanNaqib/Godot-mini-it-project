extends TextureProgressBar

# Removed: @export var player : Player (No longer needed as we use Globals)

func _ready():
	# Connect to the global health_changed signal
	# The signal will pass the current health and max health as arguments
	Globals.health_changed.connect(update_health_bar)
	
	# Perform an initial update in case the HUD loads after Globals has already emitted
	update_health_bar(Globals.player_current_health, Globals.player_max_health)

# Function to be called when Globals.health_changed signal is emitted
func update_health_bar(current_health: int, max_health: int):
	self.max_value = max_health
	self.value = current_health
	# Optional: print current health to debug
	# print("Health Bar Updated: ", current_health, "/", max_health)
