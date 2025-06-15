extends CanvasLayer

@onready var arrow_label: Label = $Control/Label

func _ready():
	# Connect to the global arrows_changed signal
	# The signal will pass the current count and max count as arguments
	Globals.arrows_changed.connect(update_arrow_count)
	
	# Perform an initial update
	update_arrow_count(Globals.player_current_arrows, Globals.player_max_arrows)

# Function to be called when Globals.arrows_changed signal is emitted
func update_arrow_count(current_count: int, max_count: int):
	arrow_label.text = "Arrows: %d/%d" % [current_count, max_count]
	# Optional: print current arrow count to debug
	# print("Arrow HUD Updated: ", current_count, "/", max_count)
